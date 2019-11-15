//
//  PropertyListViewModel.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 15/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation
import Alamofire

struct PropertyListViewModel {
    
    let readings: Readings
    let settings: Settings
    
    static func load(_ callback: @escaping (Result<PropertyListViewModel, AFError>) -> Void) {
        Readings.fetch { result in
            switch result {
            case .failure(let error):
                callback(.failure(error))
            case .success(let readings):
                Settings.fetch { result in
                    switch result {
                    case .failure(let error):
                        callback(.failure(error))
                    case .success(let settings):
                        let propertyListViewModel = PropertyListViewModel(readings: readings, settings: settings)
                        callback(.success(propertyListViewModel))
                    }
                }
            }
        }
    }
    
    var numberOfReadings: Int {
        return 5
    }
    
    var numberOfSettings: Int {
        return 7
    }
    
    func settingsKey(forRow row: Int) -> String {
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
    
    func settingsValue(forRow row: Int) -> String {
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
    
    func readingsKey(forRow row: Int) -> String {
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
    
    func readingsValue(forRow row: Int) -> String {
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
