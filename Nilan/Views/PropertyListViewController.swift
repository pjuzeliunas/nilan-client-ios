//
//  ReadingsListViewController.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 12/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

typealias SimpleCallback = () -> Void

class PropertyListViewController: UIViewController {
    
    var viewModel: PropertyListViewModel? {
        didSet {
            listView.reloadData()
        }
    }
    
    var listView: UITableView!
    
    fileprivate let fanSpeedCellIdentifier = "FanSpeed"
    fileprivate let ventilationModelCellIdentifier = "VentilationMode"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView = UITableView()
        listView.dataSource = self
        listView.tableFooterView = UIView()
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        listView.register(SegmentedControlCell<FanSpeedSegmentedControl>.self, forCellReuseIdentifier: fanSpeedCellIdentifier)
        listView.register(SegmentedControlCell<VentilationModelSegmentedControl>.self, forCellReuseIdentifier: ventilationModelCellIdentifier)
        
        reloadData()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { [weak self] _ in
            self?.reloadData()
        }
    }
    
    private var updateTimer: Timer!
    
    var isLoading = false
    
    func reloadData() {
        if isLoading {
            return
        }
        isLoading = true
        PropertyListViewModel.load { [weak self] (result) in
            self?.isLoading = false
            switch result {
            case .failure:
                break
            case .success(let newViewModel):
                self?.viewModel = newViewModel
            }
        }
    }
}


extension PropertyListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Readings"
        case 1:
            return "Settings"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel?.numberOfReadings ?? 0
        case 1:
            return viewModel?.numberOfReadings ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 0 {
            // Fan speed cell
            guard let cell = listView.dequeueReusableCell(withIdentifier: fanSpeedCellIdentifier,
                                                          for: indexPath)
                as? SegmentedControlCell<FanSpeedSegmentedControl> else { return nil! }
            
            cell.segmentedControl.selectedSegmentIndex = viewModel!.settings.fanSpeed.toSegmentedControlIndex()
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 && indexPath.row == 1 {
            // Ventilation mode cell
            guard let cell = listView.dequeueReusableCell(withIdentifier: ventilationModelCellIdentifier,
                                                          for: indexPath)
                as? SegmentedControlCell<VentilationModelSegmentedControl> else { return nil! }

            cell.segmentedControl.selectedSegmentIndex = viewModel!.settings.ventilationMode.toSegmentedControlIndex()
            cell.delegate = self
            return cell
        } else {
            return basicCell(forIndexPath: indexPath)
        }
    }
    
    private func basicCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let identifier = "BasicCell"
        
        cell = listView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = viewModel?.readingsKey(forRow: indexPath.row)
            cell.detailTextLabel?.text = viewModel?.readingsValue(forRow: indexPath.row)
        case 1:
            cell.textLabel?.text = viewModel?.settingsKey(forRow: indexPath.row)
            cell.detailTextLabel?.text = viewModel?.settingsValue(forRow: indexPath.row)
        default:
            break
        }
        
        return cell
    }
    
}

extension PropertyListViewController: SegmentedControlCellDelegate {
    
    func didSelectSegment(sender: Any, atIndex index: Int) {
        if sender is SegmentedControlCell<FanSpeedSegmentedControl> {
            let fanSpeed = FanSpeed(rawValue: index + 101)
            var settings = Settings()
            settings.fanSpeed = fanSpeed
            settings.post { _ in }
        }
        
        if sender is SegmentedControlCell<VentilationModelSegmentedControl> {
            var settings = Settings()
            settings.ventilationMode = VentilationMode(rawValue: index)
            settings.post { _ in }
        }
    }
}

extension FanSpeed {
    func toSegmentedControlIndex() -> Int {
        return rawValue - 101
    }
}

extension VentilationMode {
    func toSegmentedControlIndex() -> Int {
        return rawValue
    }
}