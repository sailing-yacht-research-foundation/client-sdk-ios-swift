//
//  SensorsAcceleroData.swift
//  SYRFLocation
//
//  Created by SYRF on 4/22/21.
//

import Foundation
import CoreMotion

/**
 Accelerometer data model
 Returned as the data for the SensorsAcceleroManager through the SensorsAcceleroDelegate
 */
public class SYRFSensorsAcceleroData {
    
    /// The acceleration on the x-axis in G's
    public var x: Double
    
    /// The acceleration on the y-axis in G's
    public var y: Double
    
    /// The acceleration on the z-axis in G's
    public var z: Double
    
    /// The timestamp at which the accelerometer data was determined
    public var timestamp: Double
    
    /**
     Default initializer
     Accelerometer data is set to default 0 values
     */
    public init() {
        self.x = 0
        self.y = 0
        self.z = 0
        self.timestamp = 0
    }
    
    /**
     Initializer using CoreLocation
     Location data is set from CoreLocation data object
     
     - Parameters:
        - acceleroData:  The CMAccelerometerData object.
     */
    public init(acceleroData: CMAccelerometerData) {
        self.x = acceleroData.acceleration.x
        self.y = acceleroData.acceleration.y
        self.z = acceleroData.acceleration.z
        self.timestamp = acceleroData.timestamp
    }
}

/**
 Acceleromater sensors usage errors
 */
public enum SYRFSensorsAcceleroError: Error {
    
    /// Accelerometer sensors are not available
    case notAvailable
    
    /// Accelerometer updates not started
    case notUpdating
}
