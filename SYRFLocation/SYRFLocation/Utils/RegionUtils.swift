//
//  RegionUtils.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/21/21.
//

import Foundation
import CoreLocation

/**
 Region Utils class containing general methods for Region functionality
 - Methods:
    - canUseRegionMonitoring
    - canMonitorForRegion
    - canMonitorForConfiguration
*/
class RegionUtils {
    
    /**
     Utility method for verifying CoreLocation access to Region monitoring functionality
     
     - Parameters:
        - regionType: The region type. Only allowed value is a circular region.
     
     - Returns:
        A tuple value of Bool and Error
        The Bool value indicates if the CoreLocation region monitoring is available. If true, the second tuple value can be ignored
        The Error value indicates a specific SYRFRegionError to be further used down the chain of actions
     
     - Note:
        To be used before CoreLocation methods that access region monitoring (e.g. startMonitoring, stopMonitoring)
     */
    static func canUseRegionMonitoring(_ regionType: SYRFRegionType) -> (Bool, Error?) {
        var canUse = false
        var error: Error? = nil
        
        switch regionType {
            case .circle:
                canUse = CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self)
                error = SYRFRegionError.notAvailable
            default:
                canUse = false
                error = SYRFRegionError.notAvailable
                
        }
        
        return (canUse, error)
    }
    
    /**
     Utility method for verifying that a specific SYRFRegion can be monitored
     
     - Parameters:
        - region: The region object.
     
     - Returns:
        A tuple value of Bool and Error
        The Bool value indicates if the region monitoring is available for this region. If true, the second tuple value can be ignored
        The Error value indicates a specific SYRFRegionError to be further used down the chain of actions
     
     - Note:
        To be used before CoreLocation methods that access region monitoring (e.g. startMonitoring, stopMonitoring) to check the validity of the region
     */
    static func canMonitorForRegion(_ region: SYRFRegion) -> (Bool, Error?) {
        var canMonitor = false
        var error: Error? = nil
        
        if let _ = region as? SYRFCircularRegion {
            canMonitor = true
        } else {
            canMonitor = false
            error = SYRFRegionError.invalidRegion
        }
        
        return (canMonitor, error)
    }
    
    /**
     Utility method for verifying a correct configuration for the RegionManager
     
     - Parameters:
        - configuration: The RegionManager configuration
     
     - Returns:
        A tuple value of Bool and Error
        The Bool value indicates if the configuration is valid. If true, the second tuple value can be ignored
        The Error value indicates a specific SYRFRegionError to be further used down the chain of actions
     
     - Note:
        To be used before CoreLocation methods that access region monitoring (e.g. startMonitoring, stopMonitoring) to check if the validity of the configuration
     */
    static func canMonitorForConfiguration(_ configuration: RegionManagerConfig) -> (Bool, Error?) {
        var canMonitor = false
        var error: Error? = nil
        
        if (configuration.updateOnEnter ?? false || configuration.updateOnExit ?? false) {
            canMonitor = true
        } else {
            canMonitor = false
            error = SYRFRegionError.notConfigured
        }
        
        return (canMonitor, error)
    }
}
