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
 Heading Raw Geomagnetic data
 */
public class SYRFHeadingRaw {
    
    /// Geomagnetic data for the x-axis
    public var x: Double
    
    /// Geomagnetic data for the y-axis
    public var y: Double
    
    /// Geomagnetic data for the z-axis
    public var z: Double
    
    /**
     Default initializer
     Geomagnetic data is set to default 0 values
     */
    init() {
        self.x = 0
        self.y = 0
        self.z = 0
    }
    
    /**
     Initializer using CoreLocation
     Geomagnetic data is set from CLHeading object
        
     - Parameters:
        - heading:  The CoreLocation Heading object.
     */
    init(heading: CLHeading) {
        self.x = heading.x
        self.y = heading.y
        self.z = heading.z
    }
}

/**
 Heading data model
 Returned as the data for the HeadingManager through the HeadingDelegate
 */
public class SYRFHeading {
    
    /// The heading (measured in degrees) relative to magnetic north.
    public var magneticHeading: Double
    
    /// The heading (measured in degrees) relative to true north.
    public var trueHeading: Double
    
    /// The maximum deviation (measured in degrees) between the reported heading and the true geomagnetic heading.
    public var accuracy: Double
    
    /// The timestamp at which the heading data was determined
    public var timestamp: Date
    
    /// The geomagnetic raw heading data
    public var rawData: SYRFHeadingRaw
    
    /**
     Default initializer
     Raw and processed data are set to default 0 values
     */
    init() {
        self.magneticHeading = 0
        self.trueHeading = 0
        self.accuracy = 0
        self.timestamp = Date()
        self.rawData = SYRFHeadingRaw()
    }
    
    /**
     Initializer using CoreLocation
     Geomagnetic data is set from CLHeading object
     Processed data is set from the CLHeading object
     
     - Parameters:
        - heading:  The CoreLocation Heading object.
     */
    init(heading: CLHeading) {
        self.magneticHeading = heading.magneticHeading
        self.trueHeading = heading.trueHeading
        self.accuracy = heading.headingAccuracy
        self.timestamp = heading.timestamp
        self.rawData = SYRFHeadingRaw(heading: heading)
    }
}

/**
 Heading usage errors
 */
public enum SYRFHeadingError: Error {
    
    /// Heading capabilities not available
    case notAvailable
    
    /// Heading permissions not allowed
    case notAllowed
}
