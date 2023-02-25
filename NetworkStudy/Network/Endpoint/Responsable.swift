//
//  Responsable.swift
//  NetworkStudy
//
//  Created by jiinheo on 2023/02/16.
//

import Foundation
import Network

//- Responsable은 단순히 Request하는 곳인, Provider에서 Reponse의 타입을 알아야 제네릭을 적용할 수 있는데,
//  여기서 Endpoint객체 하나만 넘기면 따로 request할 때 Response 타입을 넘기지 않아도 되게끔 설계

protocol Responsable {
    associatedtype Response
}
