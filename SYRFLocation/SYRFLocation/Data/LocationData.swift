//
//  LocationData.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation
import UIKit

/**
 Location Coordinates data
 */
public class SYRFCoordinate {
    
    /// The latitude of the geographical coordinate.
    public var latitude: Double
    
    /// The longitude of the geographical coordinate.
    public var longitude: Double
    
    /**
     Default initializer
     Coordinates data is set to default 0 values
     */
    init() {
        self.latitude = 0
        self.longitude = 0
    }
    
    /**
     Initializer using CoreLocation
     Coordinates data is set from CLLocationCoordinate2D object
        
     - Parameters:
        - coordinate:  The CoreLocation location coordinate object.
     */
    public init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    /**
     Initializer using specific coordinates
     Coordinates data is set from parameters
        
     - Parameters:
        - latitude: The latitude value.
        - longitude : The longitude value.
     */
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

/**
 Location data model
 Returned as the data for the LocationManager through the LocationDelegate
 */
public class SYRFLocation {
    
    /// Location coordinates
    public var coordinate: SYRFCoordinate!
    
    /// Altitude in meters
    public var altitude: Double!
    
    /// Floor of the building
    public var floor: Int!
    
    /// Radius of coordinates precision in meters
    public var horizontalAccuracy: Double!
    
    /// Radius of altitude precision in meters
    public var verticalAccuracy: Double!
    
    /// Instantaneous speed of the device in meters/second unit
    public var speed: Double!
    
    /// Precision of speed
    public var speedAccuracy: Double!
    
    /// Precision of course
    public var courseAccuracy: Double!
    
    /// The direction in which the device is traveling in degrees to True North
    public var courseHeading: Double!
    
    /// The timestamp at which the location data was determined
    public var timestamp: Date!
    
    /// The battery level of device. Value range:  0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown
    public var batteryLevel: Double!

    /**
     Default initializer
     Location data is set to default 0 values
     */
    init() {
        self.coordinate = SYRFCoordinate()
        self.altitude = 0
        self.floor = 0
        self.horizontalAccuracy = 0
        self.verticalAccuracy = 0
        self.speed = 0
        self.speedAccuracy = 0
        self.courseAccuracy = 0
        self.courseHeading = 0
        self.timestamp = Date()
        self.batteryLevel = 0
    }
    
    /**
     Initializer using CoreLocation
     Location data is set from CoreLocation data object
     
     - Parameters:
        - heading:  The CoreLocation CLLocation object.
     */
    init(location: CLLocation) {
        self.coordinate = SYRFCoordinate(location.coordinate)
        self.altitude = location.altitude
        self.floor = location.floor?.level
        self.horizontalAccuracy = location.horizontalAccuracy
        self.verticalAccuracy = location.verticalAccuracy
        self.speed = location.speed
        self.speedAccuracy = location.speedAccuracy
        self.timestamp = location.timestamp
        if #available(iOS 13.4, *) {
            self.courseAccuracy = location.courseAccuracy
        } else {
            self.courseAccuracy = 0
        }
        self.courseHeading = location.course
        self.batteryLevel = Double(UIDevice.current.batteryLevel)
    }
}

/**
 Location usage errors
 */
public enum SYRFLocationError: Error {
    
    /// Location capabilities not available
    case notAvailable
    
    /// Location permissions are not allowed
    case notAllowed
}
