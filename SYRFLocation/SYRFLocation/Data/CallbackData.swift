//
//  CallbackData.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation

public protocol PermissionsDelegate {
    func authorizationUpdated(_ status: PermissionsAuthorization)
    func accuracyUpdated(_ status: PermissionsAccuracy)
}

public protocol LocationDelegate {
    func locationUpdated(_ location: SYRFLocation)
    func currentLocationUpdated(_ location: SYRFLocation)
    func locationFailed(_ error: Error)
}

public protocol HeadingDelegate {
    func headingUpdated(_ heading: SYRFHeading)
    func headingFailed(_ error: Error)
}

public protocol RegionDelegate {
    
}



