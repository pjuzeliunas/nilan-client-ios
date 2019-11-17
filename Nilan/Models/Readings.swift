//
//  Readings.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 12/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation

struct Readings {
    var roomTemperature: Int
    var outdoorTemperature: Int
    var averageHumidity: Int
    var actualHumidity: Int
    var dhwTankTopTemperature: Int
    var dhwTankBottomTemperature: Int
    var supplyFlowTemperature: Int
}

extension Readings: Codable {
    enum CodingKeys: String, CodingKey {
        case roomTemperature = "RoomTemperature"
        case outdoorTemperature = "OutdoorTemperature"
        case averageHumidity = "AverageHumidity"
        case actualHumidity = "ActualHumidity"
        case dhwTankTopTemperature = "DHWTankTopTemperature"
        case dhwTankBottomTemperature = "DHWTankBottomTemperature"
        case supplyFlowTemperature = "SupplyFlowTemperature"
    }
}

extension Readings: Fetchable {
    static var fetchURL: String? {
        return Routes.readings
    }
}
