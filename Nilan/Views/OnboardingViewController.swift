//
//  OnboardingViewController.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 17/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func didTapConnect()
}

class OnboardingViewController: UIViewController {
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    
    @IBAction func didTapConnect(_ sender: Any) {
        UserDefaults.standard.set(addressTextField.text, forKey: UserDefaults.serverAddressKey)
        if let portString = portTextField.text {
            UserDefaults.standard.set(Int(portString), forKey: UserDefaults.serverPortKey)
        }
        UserDefaults.standard.synchronize()
        delegate?.didTapConnect()
    }
}

extension OnboardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didTapConnect(self)
        return true
    }
}

extension UserDefaults {
    static let serverAddressKey = "ServerAddress"
    static let serverPortKey = "ServerPort"
}
