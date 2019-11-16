//
//  TemperatureViewModel.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 16/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation

protocol TemperatureSettingViewModel {
    var title: String { get }
    var temperature: Int { get set }
    var maxTemperature: Int { get }
    var minTemperature: Int { get }
}

struct RoomTemperatureSettingViewModel: TemperatureSettingViewModel {
    var title: String {
        return "Room Temperature Setting"
    }
    
    var temperature: Int {
        didSet {
            var settings = Settings()
            let newTemperature = temperature
            settings.desiredRoomTemperature = newTemperature * 10
            settings.post { result in
                switch result {
                case .failure(let error):
                    print("Could not submit new desired room temperature (\(newTemperature) ℃): \(error)")
                case .success:
                    print("Desired room temperature successfuly set to: \(newTemperature) ℃")
                }
            }
        }
    }
    
    var maxTemperature: Int {
        return 40
    }
    
    var minTemperature: Int {
        return 5
    }
}

struct FlowTemperatureSettingViewModel: TemperatureSettingViewModel {
    var title: String {
        return "Supply Flow Temperature Setting"
    }
    
    var temperature: Int {
        didSet {
            var settings = Settings()
            let newTemperature = temperature
            settings.setpointSupplyTemperature = newTemperature * 10
            settings.post { result in
                switch result {
                case .failure(let error):
                    print("Could not submit new supply flow temperature (\(newTemperature) ℃): \(error)")
                case .success:
                    print("New supply flow temperature successfuly set to: \(newTemperature) ℃")
                }
            }
        }
    }
    
    var maxTemperature: Int {
        return 50
    }
    
    var minTemperature: Int {
        return 5
    }
}

struct DHWTemperatureSettingViewModel: TemperatureSettingViewModel {
    var title: String {
        return "Domestic Hot Water Temperature Setting"
    }
    
    var temperature: Int {
        didSet {
            var settings = Settings()
            let newTemperature = temperature
            settings.desiredDHWTemperature = newTemperature * 10
            settings.post { result in
                switch result {
                case .failure(let error):
                    print("Could not submit new DHW temperature (\(newTemperature) ℃): \(error)")
                case .success:
                    print("New DHW temperature successfuly set to: \(newTemperature) ℃")
                }
            }
        }
    }
    
    var maxTemperature: Int {
        return 60
    }
    
    var minTemperature: Int {
        return 10
    }
}
