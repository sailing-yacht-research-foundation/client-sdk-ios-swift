//
//  RegionManager.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

/// RegionManager
public class RegionManager: NSObject {
    
    //MARK: - Properties
    
    private let locationManager: CLLocationManager!
    private var configuration: RegionManagerConfig!
    
    public var delegate: RegionDelegate?
    
    //MARK: - Lifecycle
    
    public override init() {
        self.locationManager = CLLocationManager()
        self.configuration = RegionManagerConfig()
        
        super.init()
        
        self.locationManager.delegate = self
        self.configure(self.configuration)
    }
    
    public convenience init(delegate: RegionDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    public func configure(_ configuration: RegionManagerConfig) {
        self.configuration = configuration
    }
    
    public func startRegionUpdates(region: SYRFRegion) {
        let (canUse, error) = RegionUtils.canUseRegionMonitoring(.circle)
        
        if (canUse) {
            let (validConfig, errorConfig) = RegionUtils.canMonitorForConfiguration(self.configuration)
            if (validConfig) {
                let (validRegion, errorRegion) = RegionUtils.canMonitorForRegion(region)
                if (validRegion) {
                    if let region = self.getCLRegion(region) {
                        self.locationManager.startMonitoring(for: region)
                    }
                } else if let error = errorRegion {
                    self.delegate?.regionFailed(error)
                }
            } else if let error = errorConfig {
                self.delegate?.regionFailed(error)
            }
        } else if let error = error {
            self.delegate?.regionFailed(error)
        }
    }
    
    public func stopRegionUpdates(region: SYRFRegion) {
        let (canUse, error) = RegionUtils.canUseRegionMonitoring(.circle)
        if (canUse) {
            if let region = self.getCLRegion(region) {
                self.locationManager.stopMonitoring(for: region)
            }
        } else if let error = error {
            self.delegate?.regionFailed(error)
        }
    }
    
    //MARK: - Private Methods
    
    private func getCLRegion(_ region: SYRFRegion) -> CLRegion? {
        if let region = region as? SYRFCircularRegion {
            let center = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
            let radius = self.locationManager.maximumRegionMonitoringDistance > region.radius ? self.locationManager.maximumRegionMonitoringDistance : region.radius
            let circularRegion = CLCircularRegion(center: center, radius: radius, identifier: region.identifier)
            circularRegion.notifyOnExit = self.configuration.updateOnExit ?? false
            circularRegion.notifyOnEntry = self.configuration.updateOnEnter ?? false
            return circularRegion
        } else {
            return nil
        }
    }
}

/// Core Location Manager Delegate Extension
extension RegionManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            self.delegate?.regionDidEnter(SYRFCircularRegion(region: region))
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            self.delegate?.regionDidExit(SYRFCircularRegion(region: region))
        }
    }
}
