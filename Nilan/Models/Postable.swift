//
//  Postable.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 15/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation
import Alamofire

protocol Postable: Codable {
    var postURL: String { get }
}

extension Postable {
    func post(_  callback: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(postURL,
                   method: .put,
                   parameters: self,
                   encoder: JSONParameterEncoder.default).response { response in
            callback(response.result)
        }
    }
}

