//
//  LocationConfig.swift
//  SYRFNavigation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation
import SYRFLocation
import SYRFDeviceInfo

/**
 Navigation Manager configuration class
 Specifies manager operation parameters
*/

let DefaultThrottleForegroundDelay = 0.4
let DefaultThrottleBackgroundDelay = 1.0

public class NavigationManagerConfig {
    
    /// Location configuration
    public var locationConfig: LocationManagerConfig?
    
    /// Heading configuration
    public var headingConfig: HeadingManagerConfig?
    
    /// Device info configuration
    public var deviceInfoConfig: DeviceInfoManagerConfig?
    
    /// Callback invoke update delay foreground
    public var throttleForegroundDelay: Double?
    
    /// Callback invoke update delay background
    public var throttleBackgroundDelay: Double?
    
    /**
     Default initializer
     */
    public init() {
        self.throttleForegroundDelay = DefaultThrottleForegroundDelay
        self.throttleBackgroundDelay = DefaultThrottleBackgroundDelay
    }

}
