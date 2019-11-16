//
//  PauseViewController.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 16/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    
    var viewModel: PauseViewModel? {
        didSet {
            if viewIfLoaded != nil {
                updateView(animated: true)
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var daysPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(animated: false)
    }
    
    @IBAction func didTapHideButton(_ sender: Any) {
        if let propertyListViewController = presentingViewController as? PropertyListViewController {
            propertyListViewController.reloadData()
        }
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func didSwitch(_ sender: Any) {
        viewModel?.isOn = onOffSwitch.isOn
    }
    
    func updateView(animated: Bool = true) {
        guard let viewModel = viewModel else {
            titleLabel.text = nil
            onOffSwitch.isOn = false
            daysPicker.reloadAllComponents()
            return
        }
        titleLabel.text = viewModel.title
        onOffSwitch.isOn = viewModel.isOn
        setDuration(days: viewModel.duration, animated: animated)
    }
    
    private func setDuration(days: Int, animated: Bool = true) {
        guard let viewModel = viewModel else {
            return
        }
        daysPicker.selectRow(viewModel.duration - viewModel.minDays, inComponent: 0, animated: animated)
    }
    
}

extension PauseViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.maxDays - viewModel.minDays + 1
    }
}

extension PauseViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = viewModel else {
            return ""
        }
        return "\(row + viewModel.minDays)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = viewModel else {
            return
        }
        let duration = viewModel.minDays + row
        self.viewModel?.duration = duration
    }
    
}
