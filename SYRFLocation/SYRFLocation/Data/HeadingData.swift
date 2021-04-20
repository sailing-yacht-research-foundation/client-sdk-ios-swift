//
//  HeadingData.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

public class SYRFHeadingRaw {
    
    public var x: Double
    public var y: Double
    public var z: Double
    
    init() {
        self.x = 0
        self.y = 0
        self.z = 0
    }
    
    init(heading: CLHeading) {
        self.x = heading.x
        self.y = heading.y
        self.z = heading.z
    }
}

public class SYRFHeading {
    
    public var magneticHeading: Double
    public var trueHeading: Double
    public var accuracy: Double
    public var timestamp: Date
    public var rawData: SYRFHeadingRaw
    
    init() {
        self.magneticHeading = 0
        self.trueHeading = 0
        self.accuracy = 0
        self.timestamp = Date()
        self.rawData = SYRFHeadingRaw()
    }
    
    init(heading: CLHeading) {
        self.magneticHeading = heading.magneticHeading
        self.trueHeading = heading.trueHeading
        self.accuracy = heading.headingAccuracy
        self.timestamp = heading.timestamp
        self.rawData = SYRFHeadingRaw(heading: heading)
    }
}

public enum SYRFHeadingError: Error {
    case notAvailable
    case notAllowed
}
