//
//  LocationUtils.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation

/**
 Location Utils class containing general methods for Location functionality
 - Methods:
    - canUseCoreLocation
*/
class LocationUtils {
    
    /**
     Utility method for verifying CoreLocation permissions and access to CoreLocation functionality
     
     - Returns:
        A tuple value of Bool and Error
        The Bool value indicates if the CoreLocation functionality is accessible and can be used. If true, the second tuple value can be ignored
        The Error value indicates a specific SYRFLocationError to be further used down the chain of actions
     
     - Note:
        To be used before CoreLocation methods that require permissions (e.g. requestLocation, startLocationUpdates)
     */
    static func canUseCoreLocation() -> (Bool, Error?) {
        let permissionsManager = PermissionsManager()
        let status = permissionsManager.checkAuthorization()
        var canUse = false
        var error: Error? = nil
        
        switch status {
        case .notAvailable:
            canUse = false
            error = SYRFLocationError.notAvailable
        case .authorizedAlways, .authorizedWhenInUse:
            canUse = true
        default:
            canUse = false
            error = SYRFLocationError.notAllowed
        }
        
        return (canUse, error)
    }
}
