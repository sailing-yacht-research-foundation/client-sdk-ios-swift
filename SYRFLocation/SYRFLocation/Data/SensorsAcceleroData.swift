//
//  SensorsAcceleroData.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/22/21.
//

import Foundation
import CoreMotion

public class SYRFSensorsAcceleroData {
    
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
    
    public init(acceleroData: CMAccelerometerData) {
        self.x = acceleroData.acceleration.x
        self.y = acceleroData.acceleration.y
        self.z = acceleroData.acceleration.z
        self.timestamp = acceleroData.timestamp
    }
}

public enum SYRFSensorsAcceleroError: Error {
    case notAvailable
    case notUpdating
}
