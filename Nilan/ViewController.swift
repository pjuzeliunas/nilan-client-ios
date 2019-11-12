//
//  ViewController.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 12/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("http://192.168.1.8:8080/readings").responseDecodable { (response: DataResponse<Readings, AFError>) in
            switch response.result {
            case .success(let readings):
                print(readings)
            case .failure(let error):
                print(error)
            }
        }
        
        AF.request("http://192.168.1.8:8080/settings").responseDecodable { (response: DataResponse<Settings, AFError>) in
            switch response.result {
            case .success(let settings):
                print(settings)
            case .failure(let error):
                print(error)
            }
        }
    }


}

