//
//  Extension+Encodable.swift
//  NetworkStudy
//
//  Created by jiinheo on 2023/02/16.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with:data)
        return jsonData as? [String: Any]
    }
}
