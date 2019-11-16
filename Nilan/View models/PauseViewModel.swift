//
//  PauseViewModel.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 16/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation

protocol PauseViewModel {
    var title: String { get }
    var isOn: Bool { get set }
    var duration: Int { get set }
    var minDays: Int { get }
    var maxDays: Int { get }
}

struct CentralHeatingPauseViewModel: PauseViewModel {
    var title: String {
        return "Put Central Heating on Standby"
    }
    
    var isOn: Bool {
        didSet {
            var settings = Settings()
            settings.centralHeatingPaused = isOn
            let paused = isOn
            settings.post { result in
                switch result {
                case .failure(let error):
                    print("Could not change central heating pause setting (\(paused ? "On" : "Off")): \(error)")
                case .success:
                    print("Central heating pause is set to \(paused ? "On" : "Off")")
                }
            }
        }
    }
    
    var duration: Int {
        didSet {
            var settings = Settings()
            settings.centralHeatingPauseDuration = duration
            let newDuration = duration
            settings.post { result in
                switch result {
                case .failure(let error):
                    print("Could not change central heating pause duration to \(newDuration) days: \(error)")
                case .success:
                    print("Central heating pause duration is set to \(newDuration) days")
                }
            }
        }
    }
    
    var minDays: Int {
        return 1
    }
    
    var maxDays: Int {
        return 180
    }
}

struct DHWPauseViewModel: PauseViewModel {
    var title: String {
        return "Put Domestic Hot Water on Standby"
    }
    
    var isOn: Bool {
        didSet {
            var settings = Settings()
             settings.dhwProductionPaused = isOn
             let paused = isOn
             settings.post { result in
                 switch result {
                 case .failure(let error):
                     print("Could not change DHW pause setting (\(paused ? "On" : "Off")): \(error)")
                 case .success:
                     print("DHW pause is set to \(paused ? "On" : "Off")")
                 }
             }
        }
    }
    
    var duration: Int {
        didSet {
            var settings = Settings()
            settings.dhwProductionPauseDuration = duration
            let newDuration = duration
            settings.post { result in
                switch result {
                case .failure(let error):
                    print("Could not change DHW pause duration to \(newDuration) days: \(error)")
                case .success:
                    print("DHW pause duration is set to \(newDuration) days")
                }
            }
        }
    }
    
    var minDays: Int {
        return 1
    }
    
    var maxDays: Int {
        return 180
    }
}
