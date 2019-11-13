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

class ReadingsListViewController: UIViewController {
    
    var readings: Readings? {
        didSet {
            listView.reloadData()
        }
    }
    
    var settings: Settings? {
        didSet {
            listView.reloadData()
        }
    }
    
    var listView: UITableView!
    
    fileprivate let fanSpeedCellIdentifier = "FanSpeed"
    
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
        listView.register(FanSpeedCell.self, forCellReuseIdentifier: fanSpeedCellIdentifier)
        
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
        fetchReadings() { [weak self] in
            self?.fetchSettings() { [weak self] in
                self?.isLoading = false
            }
        }
    }
    
    func fetchReadings(_ callback: SimpleCallback? = nil) {
        AF.request("http://192.168.1.8:8080/readings").responseDecodable { [weak self] (response: DataResponse<Readings, AFError>) in
            switch response.result {
            case .success(let readings):
                self?.readings = readings
            case .failure(let error):
                self?.readings = nil
                print(error)
            }
            callback?()
        }
    }
    
    func fetchSettings(_ callback: SimpleCallback? = nil) {
        AF.request("http://192.168.1.8:8080/settings").responseDecodable { [weak self] (response: DataResponse<Settings, AFError>) in
            switch response.result {
            case .success(let settings):
                self?.settings = settings
            case .failure(let error):
                self?.settings = nil
                print(error)
            }
            callback?()
        }
    }
}


extension ReadingsListViewController: UITableViewDataSource {
    
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
            return readings != nil ? 5 : 0
        case 1:
            return settings != nil ? 7 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 0 {
            // Fan speed cell
            if let cell = listView.dequeueReusableCell(withIdentifier: fanSpeedCellIdentifier, for: indexPath) as? FanSpeedCell {
                cell.segmentedControl.selectedSegmentIndex = settings!.fanSpeed.toSegmentedControlIndex()
                cell.delegate = self
                return cell
            } else {
                return nil!
            }
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
            cell.textLabel?.text = readingsKey(forRow: indexPath.row)
            cell.detailTextLabel?.text = readingsValue(forRow: indexPath.row)
        case 1:
            cell.textLabel?.text = settingsKey(forRow: indexPath.row)
            cell.detailTextLabel?.text = settingsValue(forRow: indexPath.row)
        default:
            break
        }
        
        return cell
    }
    
    private func readingsKey(forRow row: Int) -> String {
        switch row {
        case 0:
            return "Room temperature"
        case 1:
            return "Outdoor temperature"
        case 2:
            return "Humidity"
        case 3:
            return "DHW temperature"
        case 4:
            return "Flow temperature"
        default:
            return ""
        }
    }
    
    private func readingsValue(forRow row: Int) -> String {
        guard let readings = readings else {
            return ""
        }
        switch row {
        case 0:
            return readings.roomTemperature.temperatureString()
        case 1:
            return readings.outdoorTemperature.temperatureString()
        case 2:
            return readings.actualHumidity.percentageString()
        case 3:
            return readings.dhwTankTopTemperature.temperatureString()
        case 4:
            return readings.supplyFlowTemperature.temperatureString()
        default:
            return ""
        }
    }
    
    private func settingsKey(forRow row: Int) -> String {
        switch row {
        case 0:
            return "Fan speed"
        case 1:
            return "Ventilation mode"
        case 2:
            return "Desired room temperature"
        case 3:
            return "Supply flow temperature setting"
        case 4:
            return "Central heating standby mode"
        case 5:
            return "DHW temperature setting"
        case 6:
            return "DHW standby mode"
        default:
            return ""
        }
    }
    
    private func settingsValue(forRow row: Int) -> String {
        guard let settings = settings else {
            return ""
        }
        switch row {
        case 0:
            return settings.fanSpeed.readableString()
        case 1:
            return settings.ventilationMode.readableString()
        case 2:
            return settings.desiredRoomTemperature.temperatureString()
        case 3:
            return settings.setpointSupplyTemperature.temperatureString()
        case 4:
            return settings.centralHeatingPaused.swithString()
        case 5:
            return settings.desiredDHWTemperature.temperatureString()
        case 6:
            return settings.dhwProductionPaused.swithString()
        default:
            return ""
        }
    }
}

extension ReadingsListViewController: FanSpeedCellDelegate {
    func didSelectSpeed(atIndex index: Int) {
        let fanSpeed = FanSpeed(rawValue: index + 101)
        var settings = Settings()
        settings.fanSpeed = fanSpeed
        AF.request("http://192.168.1.8:8080/settings",
                   method: .put,
                   parameters: settings,
                   encoder: JSONParameterEncoder.default).response { _ in }
    }
}

extension Int {
    func temperatureString() -> String {
        return "\(self / 10).\(self % 10) ℃"
    }
    
    func percentageString() -> String {
        return "\(self) %"
    }
}

extension FanSpeed {
    func readableString() -> String {
        switch self {
        case .level1:
            return "I"
        case .level2:
            return "II"
        case .level3:
            return "III"
        case .level4:
            return "IV"
        }
    }
}

extension VentilationMode {
    func readableString() -> String {
        switch self {
        case .auto:
            return "Auto"
        case .cooling:
            return "Cooling"
        case .heating:
            return "Heating"
        }
    }
}

extension Bool {
    func swithString() -> String {
        return self ? "On" : "Off"
    }
}

