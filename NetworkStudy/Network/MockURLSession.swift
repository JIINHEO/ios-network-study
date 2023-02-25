//
//  MockURLSession.swift
//  NetworkStudy
//
//  Created by jiinheo on 2023/02/25.
//

import Foundation

struct MockData {
    let data: Data = Data()
}

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    /// 실제 네트워크 통신을 하지 않으니 이 메소드를 호출할 때 클로저가 실행되도록 새롭게 정의
    override func resume() {
        resumeDidCall
    }
}

/// URLSessionProvider의 session 역할을 대신 수행
class MockURLSession: URLSessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let sucessResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failureResponse = HTTPURLResponse(url: request.url!, statusCode: 402, httpVersion: "2", headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        
        /// dataTask의 성공 여부는 isRequestSuccess에 의해 결정, 결과에 따른 response 내용 또한 직접 정의
        if isRequestSuccess {
            sessionDataTask.resumeDidCall = {
                completionHandler(MockData().data, sucessResponse, nil)
            }
        } else {
            sessionDataTask.resumeDidCall = {
                completionHandler(nil, failureResponse, nil)
            }
        }
        self.sesionDataTask = sessionDataTask
        return sessionDataTask
    }
    
    
    var isRequestSuccess: Bool
    var sesionDataTask: MockURLSessionDataTask?
    
    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let sucessResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url, statusCode: 402, httpVersion: "2", headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        
        /// dataTask의 성공 여부는 isRequestSuccess에 의해 결정, 결과에 따른 response 내용 또한 직접 정의
        if isRequestSuccess {
            sessionDataTask.resumeDidCall = {
                completionHandler(MockData().data, sucessResponse, nil)
            }
        } else {
            sessionDataTask.resumeDidCall = {
                completionHandler(nil, failureResponse, nil)
            }
        }
        self.sesionDataTask = sessionDataTask
        return sessionDataTask
    }
 
}
