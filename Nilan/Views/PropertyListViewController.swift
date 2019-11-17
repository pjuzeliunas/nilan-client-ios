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
        listView.delegate = self
        listView.tableFooterView = UIView()
        listView.clipsToBounds = true
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        listView.register(SegmentedControlCell<FanSpeedSegmentedControl>.self, forCellReuseIdentifier: fanSpeedCellIdentifier)
        listView.register(SegmentedControlCell<VentilationModelSegmentedControl>.self, forCellReuseIdentifier: ventilationModelCellIdentifier)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startUpdatingReadings()
    }
    
    func startUpdatingReadings() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { [weak self] _ in
            self?.reloadData()
        }
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
                self?.updateTimer?.invalidate()
                self?.updateTimer = nil
                self?.flushUserDefaults()
                self?.presentOnboardingScreen()
            case .success(let newViewModel):
                self?.viewModel = newViewModel
            }
        }
    }
    
    private func presentOnboardingScreen() {
        self.performSegue(withIdentifier: "onboard", sender: self)
    }
    
    private func flushUserDefaults() {
        UserDefaults.standard.set(nil, forKey: UserDefaults.serverAddressKey)
        UserDefaults.standard.set(nil, forKey: UserDefaults.serverPortKey)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTemperature":
            guard let temperatureViewController = segue.destination as? TemperatureViewController,
                let roomTemperature = viewModel?.settings.desiredRoomTemperature,
                let flowTemperature = viewModel?.settings.setpointSupplyTemperature,
                let dhwTemperature = viewModel?.settings.desiredDHWTemperature else {
                    return
            }
            if let kind = sender as? String {
                switch kind {
                case "room":
                    let temperature = roomTemperature / 10
                    temperatureViewController.viewModel = RoomTemperatureSettingViewModel(temperature: temperature)
                case "flow":
                    let temperature = flowTemperature / 10
                    temperatureViewController.viewModel = FlowTemperatureSettingViewModel(temperature: temperature)
                case "dhw":
                    let temperature = dhwTemperature / 10
                    temperatureViewController.viewModel = DHWTemperatureSettingViewModel(temperature: temperature)
                default:
                    break
                }
            }
        case "showPause":
            guard let settings = viewModel?.settings,
                let pauseViewController = segue.destination as? PauseViewController else {
                    return
            }
            if let kind = sender as? String {
                switch kind {
                case "centralHeating":
                    pauseViewController.viewModel = CentralHeatingPauseViewModel(isOn: settings.centralHeatingPaused,
                                                                                 duration: settings.centralHeatingPauseDuration)
                case "dhw":
                    pauseViewController.viewModel = DHWPauseViewModel(isOn: settings.dhwProductionPaused,
                                                                      duration: settings.dhwProductionPauseDuration)
                default:
                    break
                }
            }
        case "onboard":
            if let onboardingViewController = segue.destination as? OnboardingViewController {
                onboardingViewController.delegate = self
            }
        default:
            return
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
            return viewModel?.numberOfSettings ?? 0
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
            cell.accessoryType = .none
        case 1:
            cell.textLabel?.text = viewModel?.settingsKey(forRow: indexPath.row)
            cell.detailTextLabel?.text = viewModel?.settingsValue(forRow: indexPath.row)
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
}

extension PropertyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row > 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 2):
            performSegue(withIdentifier: "showTemperature", sender: "room")
        case (1, 3):
            performSegue(withIdentifier: "showTemperature", sender: "flow")
        case (1, 5):
            performSegue(withIdentifier: "showTemperature", sender: "dhw")
        case (1, 4):
            performSegue(withIdentifier: "showPause", sender: "centralHeating")
        case (1, 6):
            performSegue(withIdentifier: "showPause", sender: "dhw")
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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

extension PropertyListViewController: OnboardingViewControllerDelegate {
    func didTapConnect() {
        if Routes.basePathIsValidAddress {
            dismiss(animated: true)
            startUpdatingReadings()
        }
    }
}
