//
//  LocationData.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

public class SYRFCoordinate {
    
    public var latitude: Double
    public var longitude: Double
    
    init() {
        self.latitude = 0
        self.longitude = 0
    }
    
    public init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public class SYRFLocation {
    
    public var coordinate: SYRFCoordinate!
    public var altitude: Double!
    public var floor: Int!
    public var horizontalAccuracy: Double!
    public var verticalAccuracy: Double!
    public var speedAccuracy: Double!
    public var courseAccuracy: Double!
    public var timestamp: Date!
    
    init() {
        self.coordinate = SYRFCoordinate()
        self.altitude = 0
        self.floor = 0
        self.horizontalAccuracy = 0
        self.verticalAccuracy = 0
        self.speedAccuracy = 0
        self.courseAccuracy = 0
        self.timestamp = Date()
    }
    
    init(location: CLLocation) {
        self.coordinate = SYRFCoordinate(location.coordinate)
        self.altitude = location.altitude
        self.floor = location.floor?.level
        self.horizontalAccuracy = location.horizontalAccuracy
        self.verticalAccuracy = location.verticalAccuracy
        self.speedAccuracy = location.speedAccuracy
        self.timestamp = location.timestamp
        if #available(iOS 13.4, *) {
            self.courseAccuracy = location.courseAccuracy
        } else {
            self.courseAccuracy = 0
        }
    }
}

public enum SYRFLocationError: Error {
    case notAvailable
    case notAllowed
}
