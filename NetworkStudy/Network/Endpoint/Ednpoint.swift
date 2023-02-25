//
//  Ednpoint.swift
//  NetworkStudy
//
//  Created by jiinheo on 2023/02/25.
//

import Foundation

/*
 Endpoint: path, queryParammeters, bodyParameter 등의 데이터 객체
 Endpoint는 요청, 응답 protocol을 준수하는 상태
 
 - requestable에는 baseURL, path, method, parma..같은 정보가 존재
 - Responsable은 단순히 Request하는 곳인, Provider에서 Reponse의 타입을 알아야 제네릭을 적용할 수 있는데,
   여기서 Endpoint객체 하나만 넘기면 따로 request할 때 Response 타입을 넘기지 않아도 되게끔 설계
 
 Provider: URLSession, DataTask를 이용하여 network 호출이 이루어지는 곳
 
 */
protocol RequestResponsable: Requestable, Responsable {}

class Endpoint<R>: RequestResponsable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HttpMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String : String]?
    var sampleData: Data?
    
    init(baseURL: String,
         path: String = "",
         method: HttpMethod = .get,
         queryParameters: Encodable? = nil,
         bodyParameters: Encodable? = nil,
         headers: [String: String]? = [:],
         sampleData: Data? = nil ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
        self.sampleData = sampleData
    }
}


enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
