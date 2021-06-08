//
//  HeadingConfig.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation

/**
 Heading Manager configuration class
 Specifies manager operation parameters
*/
public class HeadingManagerConfig {
    
    /// The physical device orientation used as a reference for heading calculation
    public var headingOrientation: CLDeviceOrientation?
    
    /// The minumum change in degrees for which heading updates are received
    public var headingFilter: CLLocationDegrees?
    
    /**
     Default initializer
     Configuration parameters are set to default values
     */
    public init() {
        self.headingOrientation = .portrait
        self.headingFilter = kCLHeadingFilterNone
    }
    
    /**
     Initializer using specific heading orientation and filter values
     Heading configuration is set from parameters
        
     - Parameters:
        - orientation: The device orientation value.
        - filter : The degree filter value.
     */
    public init(orientation: CLDeviceOrientation, filter: CLLocationDegrees) {
        self.headingOrientation = orientation
        self.headingFilter = filter
    }
}
