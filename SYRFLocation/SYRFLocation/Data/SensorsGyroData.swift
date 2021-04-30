//
//  SensorsGyroData.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/22/21.
//

import Foundation
import CoreMotion

public class SYRFSensorsGyroData {
    
    public var x: Double
    public var y: Double
    public var z: Double
    public var timestamp: Double
    
    public init() {
        self.x = 0
        self.y = 0
        self.z = 0
        self.timestamp = 0
    }
    
    public init(gyroData: CMGyroData) {
        self.x = gyroData.rotationRate.x
        self.y = gyroData.rotationRate.y
        self.z = gyroData.rotationRate.z
        self.timestamp = gyroData.timestamp
    }
}

public enum SYRFSensorsGyroError: Error {
    case notAvailable
    case notUpdating
}
