//
//  Settings.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 12/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation

struct Settings {
    var fanSpeed: Int
    var desiredRoomTemperature: Int
    var desiredDHWTemperature: Int
    var dhwProductionPaused: Bool
    var dhwProductionPauseDuration: Int
    var centralHeatingPaused: Bool
    var centralHeatingPauseDuration: Int
    var ventilationMode: Int
    var ventilationOnPause: Bool
    var setpointSupplyTemperature: Int
}

extension Settings: Codable {
    enum CodingKeys: String, CodingKey {
        case fanSpeed = "FanSpeed"
        case desiredRoomTemperature = "DesiredRoomTemperature"
        case desiredDHWTemperature = "DesiredDHWTemperature"
        case dhwProductionPaused = "DHWProductionPaused"
        case dhwProductionPauseDuration = "DHWProductionPauseDuration"
        case centralHeatingPaused = "CentralHeatingPaused"
        case centralHeatingPauseDuration = "CentralHeatingPauseDuration"
        case ventilationMode = "VentilationMode"
        case ventilationOnPause = "VentilationOnPause"
        case setpointSupplyTemperature = "SetpointSupplyTemperature"
    }
}
