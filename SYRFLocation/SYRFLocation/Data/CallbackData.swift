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
    func regionDidEnter(_ region: SYRFRegion)
    func regionDidExit(_ region: SYRFRegion)
    func regionFailed(_ error: Error)
}

public protocol SensorsGyroDelegate {
    func gyroUpdated(_ data: SYRFSensorsGyroData)
    func gyroFailed(_ error: Error)
}

public protocol SensorsAcceleroDelegate {
    func acceleroUpdated(_ data: SYRFSensorsAcceleroData)
    func acceleroFailed(_ error: Error)
}

public protocol SensorsMagnetoDelegate {
    func magnetoUpdated(_ data: SYRFSensorsMagnetoData)
    func magnetoFailed(_ error: Error)
}



