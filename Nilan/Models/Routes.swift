//
//  Routes.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 14/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case unknownHost
}

struct Routes {
    static var basePath: String? {
        guard let address = UserDefaults.standard.string(forKey: UserDefaults.serverAddressKey) else {
            return nil
        }
        let port = UserDefaults.standard.integer(forKey: UserDefaults.serverPortKey)
        return "http://\(address):\(port)"
    }
    
    static var basePathIsValidAddress: Bool {
        guard let basePath = basePath else {
            return false
        }
        if let url = URL(string: basePath) {
            return url.host != nil && url.host != "" && url.port != nil
        }
        return false
    }
    
    static var readings: String? {
        guard let basePath = basePath else {
            return nil
        }
        return basePath + "/readings"
    }
    
    static var settings: String? {
        guard let basePath = basePath else {
            return nil
        }
        return basePath + "/settings"
    }
}
