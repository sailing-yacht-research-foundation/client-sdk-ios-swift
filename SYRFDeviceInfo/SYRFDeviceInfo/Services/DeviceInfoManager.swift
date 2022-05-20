//
//  DeviceManager.swift
//  SYRFDeviceInfo
//
//  Created by James on 23/04/2022.
//

import Foundation
import UIKit

public class DeviceInfoManager: NSObject {

    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: DeviceInfoManagerConfig!

    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core location manager and its configuration
     */
    public override init() {
        self.configuration = DeviceInfoManagerConfig()
        
        super.init()

        self.configure(self.configuration)
    }
    
    public func getPhoneModel() -> String {
        return UIDevice.modelName
    }
    
    public func getOsVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    public func getBatteryLevel() -> Float {
        return UIDevice.current.batteryLevel
    }
    
    public func configure(_ configuration: DeviceInfoManagerConfig) {
        self.configuration = configuration
    }
    
    public func configureEnabled(_ enabled: Bool) {
        self.configuration.enabled = enabled
        
        if configuration.enabled {
            self.startDeviceInfoUpdates()
        } else {
            self.stopDeviceInfoUpdates()
        }
    }
    
    public func startDeviceInfoUpdates() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    public func stopDeviceInfoUpdates() {
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
}
