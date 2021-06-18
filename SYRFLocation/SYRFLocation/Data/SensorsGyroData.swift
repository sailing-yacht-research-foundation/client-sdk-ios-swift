//
//  SensorsGyroData.swift
//  SYRFLocation
//
//  Created by SYRF on 4/22/21.
//

import Foundation
import CoreMotion

/**
 Gyroscope data model
 Returned as the data for the SensorsGyroManager through the SensorsGyroDelegate
 */
public class SYRFSensorsGyroData {
    
    /// The rotation rate on the x-axis in degrees
    public var x: Double
    
    /// The rotation rate on the y-axis in degress
    public var y: Double
    
    /// The rotation rate on the z-axis in degrees
    public var z: Double
    
    /// The timestamp at which the gyrscope data was determined
    public var timestamp: Double
    
    /**
     Default initializer
     Gyroscope data is set to default 0 values
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
        - gyroData:  The CMGyroData object.
     */
    public init(gyroData: CMGyroData) {
        self.x = gyroData.rotationRate.x
        self.y = gyroData.rotationRate.y
        self.z = gyroData.rotationRate.z
        self.timestamp = gyroData.timestamp
    }
}

/**
 Gyroscope sensors usage errors
 */
public enum SYRFSensorsGyroError: Error {
    
    /// Gyrscope sensors are not available
    case notAvailable
    
    /// Gyroscope updates not started
    case notUpdating
}
