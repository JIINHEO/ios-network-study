//
//  Requestable.swift
//  NetworkStudy
//
//  Created by jiinheo on 2023/02/16.
//

import Foundation
import Network

// - requestable에는 baseURL, path, method, parma..같은 정보가 존재
protocol Requestable {
    var baseURL: String {get}
    var path: String {get}
    var method: HttpMethod {get}
    var queryParameters: Encodable? {get}
    var bodyParameters: Encodable? {get}
    var headers: [String: String]? {get}
    var sampleData: Data? {get}
}

extension Requestable {
    func getUrlReauest() throws -> URLRequest {
        let url = try url()
        var urlReauest = URLRequest(url: url)
        
        // httpBody
        if let bodyParameters = try bodyParameters?.toDictionary() {
            if !bodyParameters.isEmpty {
                urlReauest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
            }
        }
        
        // httpMethod
        urlReauest.httpMethod = method.rawValue
        
        // header
        headers?.forEach{ urlReauest.setValue($1, forHTTPHeaderField: $0)}
        
        return urlReauest
    }
    
    func url() throws -> URL {
        
        // baseURL + path
        let fullPath = "\(baseURL)\(path)"
        guard var urlComponents = URLComponents(string: fullPath) else { throw NetworkError.components }
        
        // (baseURL + paht) + queryParameters
        var urlQueryItems = [URLQueryItem]()
        if let queryParameters = try queryParameters?.toDictionary() {
            queryParameters.forEach {
                urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            }
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else { throw NetworkError.components }
        return url
    }
}
