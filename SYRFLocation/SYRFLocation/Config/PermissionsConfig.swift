//
//  PermissionsConfig.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation

public enum PermissionsType {
    case always
    case whenInUse
}

public enum PermissionsAuthorization {
    case notAvailable
    case notDetermined
    case notAuthorized
    case authorizedAlways
    case authorizedWhenInUse
}

public enum PermissionsAccuracy {
    case notAvailable
    case full
    case reduced
}
