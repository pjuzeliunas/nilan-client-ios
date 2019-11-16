//
//  TemperatureViewController.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 15/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {
    
    var viewModel: TemperatureSettingViewModel? {
        didSet {
            if viewIfLoaded != nil {
                updateView()
            }
        }
    }
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBAction func didTapHideButton(_ sender: Any) {
        if let propertyListViewController = presentingViewController as? PropertyListViewController {
            propertyListViewController.reloadData()
        }
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func minusAction(_ sender: Any) {
        viewModel?.temperature -= 1
    }
    
    @IBAction func plusAction(_ sender: Any) {
        viewModel?.temperature += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        guard let viewModel = viewModel else {
            titleLabel.text = nil
            temperatureLabel.text = "N/A"
            return
        }
        titleLabel.text = viewModel.title
        temperatureLabel.text = "\(viewModel.temperature) ℃"
        minusButton.isEnabled = viewModel.temperature > viewModel.minTemperature
        plusButton.isEnabled = viewModel.temperature < viewModel.maxTemperature
    }
}
