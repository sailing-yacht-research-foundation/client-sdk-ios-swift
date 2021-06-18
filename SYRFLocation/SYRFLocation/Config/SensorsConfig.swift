//
//  SensorsConfig.swift
//  SYRFLocation
//
//  Created by SYRF on 4/22/21.
//

import Foundation

/**
 Sensors Gyroscope Manager configuration class
 Specifies manager operation parameters
 */
public class SensorsGyroConfig {
    
    /// The update interval at which to deliver gyroscope data updates in units of seconds
    public var updateInterval: Double?
    
    /// The queue on which to deviler gyroscope date updates. If true, will use a background queue, otherwise the main queue
    public var runInBackground: Bool?
    
    /**
     Default initializer
     Configuration parameters are set to default values of 100 seconds and running on a background queue
     */
    public init() {
        self.updateInterval = 100
        self.runInBackground = true
    }
    
    /**
     Initializer using specific update interval and queue values
     Gyroscope Manager configuration is set from parameters
        
     - Parameters:
        - updateInterval: The update interval value.
        - runInBackground : The run on background queue value.
     */
    public init(updateInterval: Double, runInBackground: Bool) {
        self.updateInterval = updateInterval
        self.runInBackground = runInBackground
    }
}

/**
 Sensors Accelerometer Manager configuration class
 Specifies manager operation parameters
 */
public class SensorsAcceleroConfig {
    
    /// The update interval at which to deliver accelerometer data updates in units of seconds
    public var updateInterval: Double?
    
    /// The queue on which to deviler gyroscope date updates. If true, will use a background queue, otherwise the main queue
    public var runInBackground: Bool?
    
    /**
     Default initializer
     Configuration parameters are set to default values of 100 seconds and running on a background queue
     */
    public init() {
        self.updateInterval = 100
        self.runInBackground = true
    }
    
    /**
     Initializer using specific update interval and queue values
     Accelerometer Manager configuration is set from parameters
        
     - Parameters:
        - updateInterval: The update interval value.
        - runInBackground : The run on background queue value.
     */
    public init(updateInterval: Double, runInBackground: Bool) {
        self.updateInterval = updateInterval
        self.runInBackground = runInBackground
    }
}

/**
 Sensors Magnetometer Manager configuration class
 Specifies manager operation parameters
 */
public class SensorsMagnetoConfig {
    
    /// The update interval at which to deliver magnetometer data updates in units of seconds
    public var updateInterval: Double?
    
    /// The queue on which to deviler gyroscope date updates. If true, will use a background queue, otherwise the main queue
    public var runInBackground: Bool?
    
    /**
     Default initializer
     Configuration parameters are set to default values of 100 seconds and running on a background queue
     */
    public init() {
        self.updateInterval = 100
        self.runInBackground = true
    }
    
    /**
     Initializer using specific update interval and queue values
     Magnetometer Manager configuration is set from parameters
        
     - Parameters:
        - updateInterval: The update interval value.
        - runInBackground : The run on background queue value.
     */
    public init(updateInterval: Double, runInBackground: Bool) {
        self.updateInterval = updateInterval
        self.runInBackground = runInBackground
    }
}
