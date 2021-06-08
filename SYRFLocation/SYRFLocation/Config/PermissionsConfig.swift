//
//  PermissionsConfig.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation

/**
 Location Manager permissions for obtaining location updates
 */
public enum PermissionsType {
    /// Location Manager permission for running in background and foreground
    case always
    /// Location Manager permission for running in foreground
    case whenInUse
}

/**
 Location Manager authorization status of location updates permissions
 */
public enum PermissionsAuthorization {
    
    /// Location Manager is not capable of obtaining location updates, location services are turned off
    case notAvailable
    
    /// Location Manager authorization status pending, user has not granted permissions either way
    case notDetermined
    
    /// Location Manager authorization status not approved
    case notAuthorized
    
    /// Location Manager always authorization status approved
    case authorizedAlways
    
    /// Location Manager when in use authorization status approved
    case authorizedWhenInUse
}

/**
 Location Manager permissions for accuracy of location updates
 */
public enum PermissionsAccuracy {
    
    /// Location Manager is not capable of obtaining location updates, location services are turned off
    case notAvailable
    
    /// Location Manager accuracy status is fully approved, location updates accuracy is at maximum capability
    case full
    
    /// Location Manager accuracy status is reduced, location updates accuracy is very low
    case reduced
}
