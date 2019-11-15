//
//  Settings.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 12/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation

enum FanSpeed: Int, Codable {
    case level1 = 101
    case level2 = 102
    case level3 = 103
    case level4 = 104
}

enum VentilationMode: Int, Codable {
    case auto = 0
    case cooling = 1
    case heating = 2
}

struct Settings {
    var fanSpeed: FanSpeed!
    var desiredRoomTemperature: Int!
    var desiredDHWTemperature: Int!
    var dhwProductionPaused: Bool!
    var dhwProductionPauseDuration: Int!
    var centralHeatingPaused: Bool!
    var centralHeatingPauseDuration: Int!
    var ventilationMode: VentilationMode!
    var ventilationOnPause: Bool!
    var setpointSupplyTemperature: Int!
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

extension Settings: Fetchable {
    static var fetchURL: String {
        return Routes.settings
    }
}

extension Settings: Postable {
    var postURL: String {
        return Routes.settings
    }
}
