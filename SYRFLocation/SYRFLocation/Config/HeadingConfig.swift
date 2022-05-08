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
    
    /// Is enabled
    public var enabled: Bool
    
    /// The physical device orientation used as a reference for heading calculation
    public var headingOrientation: CLDeviceOrientation?
    
    /// The minumum change in degrees for which heading updates are received
    public var headingFilter: CLLocationDegrees?
    
    /**
     Default initializer
     Configuration parameters are set to default values
     */
    public init() {
        self.enabled = false
        self.headingOrientation = .portrait
        self.headingFilter = kCLHeadingFilterNone
    }
    
    /**
     Initializer using specific heading orientation and filter values
     Heading configuration is set from parameters
        
     - Parameters:
        - enabled: Is enabled
        - orientation: The device orientation value.
        - filter : The degree filter value.
     */
    public init(enabled: Bool, orientation: CLDeviceOrientation, filter: CLLocationDegrees) {
        self.enabled = enabled
        self.headingOrientation = orientation
        self.headingFilter = filter
    }
}
