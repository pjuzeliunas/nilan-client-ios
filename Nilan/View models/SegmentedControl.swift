//
//  SegmentedControl.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 14/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import Foundation

protocol SegmentedControl {
    static var segments: [String] { get }
    static var title: String { get }
}

struct FanSpeedSegmentedControl: SegmentedControl {
    static var segments: [String] {
        return ["I", "II", "III", "IV"]
    }
    
    static var title: String {
        return "Fan speed"
    }
}

struct VentilationModelSegmentedControl: SegmentedControl {
    static var segments: [String] {
        return ["Auto", "Cooling", "Heating"]
    }
    
    static var title: String {
        return "Ventilation mode"
    }
}
