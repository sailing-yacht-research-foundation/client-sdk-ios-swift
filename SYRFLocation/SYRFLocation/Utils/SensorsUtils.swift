//
//  SensorsUtils.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/22/21.
//

import Foundation
import CoreMotion

class SensorsUtils {
    
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
