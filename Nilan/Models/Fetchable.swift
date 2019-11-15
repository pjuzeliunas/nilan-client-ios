//
//  Fetchable.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 15/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation
import Alamofire

protocol Fetchable: Codable {
    static var fetchURL: String { get }
}

extension Fetchable {
    static func fetch(_  callback: @escaping (Result<Self, AFError>) -> Void) {
        AF.request(fetchURL).responseDecodable { (response: DataResponse<Self, AFError>) in
            callback(response.result)
        }
    }
}
