//
//  SensorsConfig.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/22/21.
//

import Foundation

public class SensorsGyroConfig {
    
    public var updateInterval: Double?
    public var runInBackground: Bool?
    
    public init() {
        self.updateInterval = 100
        self.runInBackground = true
    }
    
    public init(updateInterval: Double, runInBackground: Bool) {
        self.updateInterval = updateInterval
        self.runInBackground = runInBackground
    }
}

public class SensorsAcceleroConfig {
    
    public var updateInterval: Double?
    public var runInBackground: Bool?
    
    public init() {
        self.updateInterval = 100
        self.runInBackground = true
    }
    
    public init(updateInterval: Double, runInBackground: Bool) {
        self.updateInterval = updateInterval
        self.runInBackground = runInBackground
    }
}

public class SensorsMagnetoConfig {
    
    public var updateInterval: Double?
    public var runInBackground: Bool?
    
    public init() {
        self.updateInterval = 100
        self.runInBackground = true
    }
    
    public init(updateInterval: Double, runInBackground: Bool) {
        self.updateInterval = updateInterval
        self.runInBackground = runInBackground
    }
}
