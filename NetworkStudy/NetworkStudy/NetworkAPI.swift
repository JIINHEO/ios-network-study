//
//  NetworkAPI.swift
//  NetworkStudy
//
//  Created by jiinheo on 2023/02/12.
//

import Foundation

struct NetworkAPI {
    static let scheme = "https"
    static let host = "api.unsplahs.com"
    static let path = "/photos"
    
    func getRandomImageAPI(page: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = NetworkAPI.scheme
        components.host = NetworkAPI.host
        components.path = NetworkAPI.path
        
        components.queryItems = [
        URLQueryItem(name: "clent_id", value: "xxxxxxxxx"),
        URLQueryItem(name: "count", value: "15"),
        URLQueryItem(name: "page", value: String(page))
        ]
        return components
    }
}
