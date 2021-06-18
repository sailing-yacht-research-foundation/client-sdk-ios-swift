//
//  SensorsMagnetoData.swift
//  SYRFLocation
//
//  Created by SYRF on 4/22/21.
//

import Foundation
import CoreMotion

/**
 Magnetometer data model
 Returned as the data for the SensorsMagnetoManager through the SensorsMagnetoDelegate
 */
public class SYRFSensorsMagnetoData {
    
    /// The magnetic field on the x-axis in microteslas
    public var x: Double
    
    /// The magnetic field of the y-axis in microteslas
    public var y: Double
    
    /// The magnetic field of the z-axis in microteslas
    public var z: Double
    
    /// The timestamp at which the magnetometer data was determined
    public var timestamp: Double
    
    /**
     Default initializer
     Magnetometer data is set to default 0 values
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
        - magnetoData:  The CMMagnetometerData object.
     */
    public init(magnetoData: CMMagnetometerData) {
        self.x = magnetoData.magneticField.x
        self.y = magnetoData.magneticField.y
        self.z = magnetoData.magneticField.z
        self.timestamp = magnetoData.timestamp
    }
}

/**
 Magnetometer sensors usage errors
 */
public enum SYRFSensorsMagnetoError: Error {
    
    /// Magnetometer sensors are not available
    case notAvailable
    
    /// Magnetormeter updates not started
    case notUpdating
}
