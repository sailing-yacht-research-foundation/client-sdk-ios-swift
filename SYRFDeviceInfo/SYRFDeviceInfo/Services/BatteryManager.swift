//
//  BatteryManager.swift
//  SYRFDeviceInfo
//
//  Created by James on 23/04/2022.
//

import Foundation
import UIKit

public class BatteryManager: NSObject {
    
    public func enableBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    public func getBatteryLevel() -> Float {
        return UIDevice.current.batteryLevel
    }
    
    public func disableBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
}
