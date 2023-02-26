//
//  Provider.swift
//  NetworkStudy
//
//  Created by jiinheo on 2023/02/25.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
}

enum CustomError: Error {
    case statusCodeError
    case unknownError
}

protocol Provider {
    /// 특정 responsable이 존재하는 request
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E, completion: @escaping (Result<R, Error>) -> Void) where E.Response == R

    /// data를 얻는 request
    func request(_ url: URL, completion: @escaping (Result<Data, Error>) -> ())
}

class URLSessionProvider: Provider {
    
    let session: URLSessionable
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func request<R, E>(with endpoint: E, completion: @escaping (Result<R, Error>) -> Void) where R : Decodable, R == E.Response, E : RequestResponsable {
        do {
            let urlRequest = try endpoint.getUrlReauest()

            session.dataTask(with: urlRequest) { [weak self] data, response, error in
                self?.checkError(with: data, response, error, completion: { result in
                    guard let self = self else {return}
                    
                    switch result {
                    case .success(let data):
                        completion(self.decode(data: data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            }.resume()
        } catch {
            completion(.failure(NetworkError.urlRequest(error)))
        }
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, CustomError>) -> Void) {

        let task = session.dataTask(with: request) { data, urlResponse, error in

            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.statusCodeError))
            }

            if let data = data {
                return completionHandler(.success(data))
            }

            completionHandler(.failure(.unknownError))
        }
        task.resume()
    }
    
    func request(_ url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        session.dataTask(with: url) { [weak self] data, response, error in
            self?.checkError(with: data, response, error, completion: { result in
                completion(result)
            })
        }.resume()
    }

    private func checkError(with data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping (Result<Data, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknownError))
            return
        }
        
        guard (200...299).contains(response.statusCode) else {
            completion(.failure(NetworkError.invalidHttpStatusCode(response.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.emptyData))
            return
        }
        
        completion(.success(data))
    }
    
    private func decode<T: Decodable>(data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.emptyData)
        }
    }
    
    func getUser(id: Int, completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        let baseURL = "https://www.testwebpage.com/"
        
        guard let url = URL(string: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
}
