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
    var postURL: String? { get }
}

extension Postable {
    func post(_  callback: @escaping (Result<Data?, Error>) -> Void) {
        guard let postURL = postURL else {
            callback(.failure(NetworkError.unknownHost))
            return
        }
        let request = AF.request(postURL,
                                 method: .put,
                                 parameters: self,
                                 encoder: JSONParameterEncoder.default)
        request.response { response in
            switch response.result {
            case .failure(let error):
                callback(.failure(error))
            case .success(let result):
                callback(.success(result))
            }
        }
    }
}

