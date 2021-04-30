//
//  SensorsMagnetoData.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/22/21.
//

import Foundation
import CoreMotion

public class SYRFSensorsMagnetoData {
    
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
    
    public init(magnetoData: CMMagnetometerData) {
        self.x = magnetoData.magneticField.x
        self.y = magnetoData.magneticField.y
        self.z = magnetoData.magneticField.z
        self.timestamp = magnetoData.timestamp
    }
}

public enum SYRFSensorsMagnetoError: Error {
    case notAvailable
    case notUpdating
}
