//
//  RegionUtils.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/21/21.
//

import Foundation
import CoreLocation

class RegionUtils {
    
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
    
    static func canMonitorForConfiguration(_ configuration: RegionManagerConfig) -> (Bool, Error?) {
        var canMonitor = false
        var error: Error? = nil
        
        if (configuration.updateOnEnter ?? false || configuration.updateOnExit ?? false) {
            canMonitor = true
        } else {
            canMonitor = false
            error = SYRFRegionError.invalidRegion
        }
        
        return (canMonitor, error)
    }
}
