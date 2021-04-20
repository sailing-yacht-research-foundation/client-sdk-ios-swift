//
//  LocationUtils.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation

class LocationUtils {
    
    static func canUseLocation() -> (Bool, Error?) {
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
