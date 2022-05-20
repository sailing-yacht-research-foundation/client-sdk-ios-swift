//
//  HeadingData.swift
//  SYRFLocation
//
//  Heading data models
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation

/**
 Device info data
 */
public class SYRFDeviceInfo {
    
    /// Battery level
    public var batteryLevel: Float
    
    /// iOS version
    public var osVersion: String
    
    /// Device model
    public var deviceModel: String
    
    /// The timestamp at which the data was determined
    public var timestamp: Date!
    
    /**
     Default initializer
     */
    public init() {
        self.batteryLevel = 0
        self.osVersion = ""
        self.deviceModel = ""
        self.timestamp = Date()
    }
}

/**
 Device info usage errors
 */
public enum SYRFDeviceInfoError: Error {
    
    /// Device info capabilities not available
    case notAvailable
    
    /// Device info permissions not allowed
    case notAllowed
}
