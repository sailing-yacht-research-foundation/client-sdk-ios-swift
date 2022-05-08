//
//  NavigationData.swift
//  SYRFNavigation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation
import SYRFLocation
import SYRFDeviceInfo

/**
 Navigation data model
 Returned as the data for the LocationManager through the LocationDelegate
 */
public class SYRFNavigation {
    
    /// Location coordinates
    public var location: SYRFLocation?
    
    /// Heading data
    public var heading: SYRFHeading?
    
    /// Device data
    public var deviceInfo: SYRFDeviceInfo?
}

/**
 Navigation usage errors
 */
public enum SYRFNavigationError: Error {
    
    /// Navigation capabilities not available
    case notAvailable
    
    /// Navigation permissions are not allowed
    case notAllowed
}
