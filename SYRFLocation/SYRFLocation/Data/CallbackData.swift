//
//  CallbackData.swift
//  SYRFLocation
//
//  Callbacks protocol definitions
//
//  Created by SYRF on 4/20/21.
//

import Foundation

/**
 Location Permissions protocol
 PermissionsManager class delegate
*/
public protocol PermissionsDelegate {
    
    /**
     Delegate method for location authorization permissions changes
     
     - Parameters:
        - status:  The authorization status.
     - Note:
        Called each time the authorization permissions have changed
     */
    func authorizationUpdated(_ status: PermissionsAuthorization)
    
    /**
     Delegate method for location accuracy permissions changes
     
     - Parameters:
        - status:  The accuracy status.
     - Note:
        Available from iOS 14 upwards
        Called each time the accuracy permissions have changed
     */
    func accuracyUpdated(_ status: PermissionsAccuracy)
}

/**
 Location Updates protocol
 LocationManager class delegate
*/
public protocol LocationDelegate {
    
    /**
     Delegate method for location updates when LocationManager is monitoring significant changes or location updates
     
     - Parameters:
        - location:  The location update object.
     - Note:
        Called each time the LocationManager has obtained a new location
     */
    func locationUpdated(_ location: SYRFLocation)
    
    /**
     Delegate method for a one time location information
     
     - Parameters:
        - location:  The location update object.
     - Note:
        Called when the LocationManager has obtained the location information.
     */
    func currentLocationUpdated(_ location: SYRFLocation)
    
    /**
     Delegate method for location updates errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during LocationManager lifecycle
        Erros can be permission errors, incorrect usage or CoreLocation errors
     */
    func locationFailed(_ error: Error)
}

/**
 Heading Updates protocol
 HeadingManager class delegate
*/
public protocol HeadingDelegate {
    
    /**
     Delegate method for heading updates when HeadingManager is monitoring heading updates
     
     - Parameters:
        - heading:  The heading update object.
     - Note:
        Called each time the HeadingManager has obtained a new heading
     */
    func headingUpdated(_ heading: SYRFHeading)
    
    /**
     Delegate method for heading updates errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during HeadingManager lifecycle
        Erros can be permission errors, incorrect usage or CoreLocation errors
     */
    func headingFailed(_ error: Error)
}

/**
 Region Updates protocol
 RegionManager class delegate
*/
public protocol RegionDelegate {
    
    /**
     Delegate method for region updates.
     
     - Parameters:
        - region:  The monitored region.
     - Note:
        Called each time the RegionManager has detected the monitored region was entered
     */
    func regionDidEnter(_ region: SYRFRegion)
    
    /**
     Delegate method for region updates.
     
     - Parameters:
        - region:  The monitored region.
     - Note:
        Called each time the RegionManager has detected the monitored region was exited
     */
    func regionDidExit(_ region: SYRFRegion)
    
    /**
     Delegate method for heading updates errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during RegionManager lifecycle
        Erros can be permission errors, incorrect usage or CoreLocation errors
     */
    func regionFailed(_ error: Error)
}

/**
 Gyroscope sensor updates protocol
 SensorsGyroManager class delegate
*/
public protocol SensorsGyroDelegate {
    
    /**
     Delegate method for gyroscope updates.
     
     - Parameters:
        - data:  The gyroscope sensors information.
     - Note:
        Called each time the SensorsGyroManage has obtained new sensors data
     */
    func gyroUpdated(_ data: SYRFSensorsGyroData)
    
    /**
     Delegate method for gyroscope updates errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during SensorsGyroManager lifecycle
        Erros can be incorrect usage or CoreMotion errors
     */
    func gyroFailed(_ error: Error)
}

/**
 Accelerometer sensor updates protocol
 SensorsAcceleroManager class delegate
*/
public protocol SensorsAcceleroDelegate {
    
    /**
     Delegate method for accelerometer updates.
     
     - Parameters:
        - data:  The accelerometer sensors information.
     - Note:
        Called each time the SensorsAcceleroManage has obtained new sensors data
     */
    func acceleroUpdated(_ data: SYRFSensorsAcceleroData)
    
    /**
     Delegate method for accelerometer updates errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during SensorsAcceleroManager lifecycle
        Erros can be incorrect usage or CoreMotion errors
     */
    func acceleroFailed(_ error: Error)
}

/**
 Magnetometer sensor updates protocol
 SensorsMagnetoManager class delegate
*/
public protocol SensorsMagnetoDelegate {
    
    /**
     Delegate method for magnetormeter updates.
     
     - Parameters:
        - data:  The magnetometer sensors information.
     - Note:
        Called each time the SensorsMagnetoManage has obtained new sensors data
     */
    func magnetoUpdated(_ data: SYRFSensorsMagnetoData)
    
    /**
     Delegate method for magnetometer updates errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during SensorsMagnetoManager lifecycle
        Erros can be incorrect usage or CoreMotion errors
     */
    func magnetoFailed(_ error: Error)
}



