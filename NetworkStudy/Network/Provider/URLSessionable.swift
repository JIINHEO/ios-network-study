//
//  URLSessionable.swift
//  NetworkStudy
//
//  Created by jiinheo on 2023/02/25.
//

import Foundation

/// URLSession 테스트를 위한 protocol 이다 (Provider 생성자에서 해당 인터페이스 참조)
/// 진짜 URLSession에게 URLSessionProtocol을 채택시킴으로서 URLSessionProtocol에 진짜 URLSession을 호출해도 정상적으로 돌아가게 된다
/// (URLsession인척 하면서 내가 만든 dataTask 메소드를 가진 가짜를 만들어야한다.)
/// (가짜가 진짜보다 높은 계급인척 하기?)
/// dataTask 구현의 경우 진짜 URLSession 안에 dataTask가 이미 있으므로 구현한 것으로 친다.

protocol URLSessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionable {}
