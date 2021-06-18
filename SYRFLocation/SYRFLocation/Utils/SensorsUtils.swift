//
//  SensorsUtils.swift
//  SYRFLocation
//
//  Created by SYRF on 4/22/21.
//

import Foundation
import CoreMotion

/**
 Sensors Utils class containing general methods for Sensors functionality
 - Methods:
    - canMonitorGyro
    - canMonitorAccelero
    - canMonitorMagneto
*/
class SensorsUtils {
    
    /**
     Utility method for verifying CoreMotion access to the Gyroscope sensor functionality
     
     - Parameters:
        - manager: The CMMotionManager object
     
     - Returns:
        A tuple value of Bool and Error
        The Bool value indicates if the CoreMotion is capable of using the Gyroscope sensors. If true, the second tuple value can be ignored
        The Error value indicates a specific SYRFSensorsGyroError to be further used down the chain of actions
     
     - Note:
        To be used before CoreMotion methods that access gyroscope data (e.g. startAccelerometerUpdates)
     */
    static func canMonitorGyro(_ manager: CMMotionManager) -> (Bool, Error?) {
        var canMonitor = false
        var error: Error? = nil
        
        if manager.isGyroAvailable {
            canMonitor = true
        } else {
            canMonitor = false
            error = SYRFSensorsGyroError.notAvailable
        }
        
        return (canMonitor, error)
    }
    
    /**
     Utility method for verifying CoreMotion access to the Accelerometer sensor functionality
     
     - Parameters:
        - manager: The CMMotionManager object
     
     - Returns:
        A tuple value of Bool and Error
        The Bool value indicates if the CoreMotion is capable of using the Accelerometer sensors. If true, the second tuple value can be ignored
        The Error value indicates a specific SYRFSensorsAcceleroError to be further used down the chain of actions
     
     - Note:
        To be used before CoreMotion methods that access accelerometer data (e.g. startAccelerometerUpdates)
     */
    static func canMonitorAccelero(_ manager: CMMotionManager) -> (Bool, Error?) {
        var canMonitor = false
        var error: Error? = nil
        
        if manager.isAccelerometerActive {
            canMonitor = true
        } else {
            canMonitor = false
            error = SYRFSensorsAcceleroError.notAvailable
        }
        
        return (canMonitor, error)
    }
    
    /**
     Utility method for verifying CoreMotion access to the Magnetometer sensor functionality
     
     - Parameters:
        - manager: The CMMotionManager object
     
     - Returns:
        A tuple value of Bool and Error
        The Bool value indicates if the CoreMotion is capable of using the Magnetometer sensors. If true, the second tuple value can be ignored
        The Error value indicates a specific SYRFSensorsMagnetoError to be further used down the chain of actions
     
     - Note:
        To be used before CoreMotion methods that access magnetometer data (e.g. startMagnetometerUpdates)
     */
    static func canMonitorMagneto(_ manager: CMMotionManager) -> (Bool, Error?) {
        var canMonitor = false
        var error: Error? = nil
        
        if manager.isMagnetometerAvailable {
            canMonitor = true
        } else {
            canMonitor = false
            error = SYRFSensorsMagnetoError.notAvailable
        }
        
        return (canMonitor, error)
    }
}
