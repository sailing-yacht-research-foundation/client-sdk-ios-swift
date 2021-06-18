//
//  RegionManager.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation

/**
 Manager class responsible for providing region monitoring information.
 
 Region monitoring information is reported based on the RegionManagerConfig.
 A region can be monitored for either entering or exiting or for both.
 
 A normal setup for the monitoring a region would be:
 - set up the RegionDelegate, as region updates are passed back through the delegate set up either at initialization time or by using the stored property
 - configure the RegionManager through the configure method
 - request region monitoring for a provided region through the startRegionUpdates method
 - regionDidEnter or regionDidExit are called each time a the region boundries are crossed
 - when finished request to stop monitoring the provided region through the stopRegionUpdates method
 */
public class RegionManager: NSObject {
    
    //MARK: - Properties
    
    /// The root object providing access to Core Location functionality
    private let locationManager: CLLocationManager!
    
    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: RegionManagerConfig!
    
    /// The manager delegate, used to pass back region monitoring updates as they occur
    public var delegate: RegionDelegate?
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core location manager and its configuration
     */
    public override init() {
        self.locationManager = CLLocationManager()
        self.configuration = RegionManagerConfig()
        
        super.init()
        
        self.locationManager.delegate = self
        self.configure(self.configuration)
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back region monitoring updates
     */
    public convenience init(delegate: RegionDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Provide the manager with a specific RegionManagerConfig object
     The configuration values are used for the core location manager
     
     - Parameters:
        - configuration: The manager configuration values
     */
    public func configure(_ configuration: RegionManagerConfig) {
        self.configuration = configuration
    }
    
    /**
     Entry point for monitoring a specifc region updates based on the default or custom configuration
     
     Before starting region updates the availability of core location functionality for region monitiring is checked.
     If cannot proceed with monitoring a region the manager delegate will be informed of the failing error
     
     If region monitoring updates can be retrieved either regionDidExit or regionDidEnter methods of the delegate are called each time the region boundries are crossed
     
     - Parameters:
        - region: The region to monitor for changes
     */
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
    
    /**
     Entry point for stopping a specific region updates
     
     Before stopping region updates the availability of core location functionality is checked.
     If cannot proceed with stopping region updates monitoring the manager delegate will be informed of the failing error
     */
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
    
    /**
     Creates a Core Location region object based on a custom SYRFRegion
     The Core Location region is configured based on the RegionManagerConfig values
     
     - Parameters:
        - region: The custom region object
     */
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

/**
 Core Location Manager Delegate Extension
 Region updates are provided through the Core Location Manager Delegate
 Each time a monitored region is exited the coresponding RegionDelegate method is called with the custom SYRFRegion object created based on CLLocation
 Each time a monitored region is entered the coresponding RegionDelegate method is called with the custom SYRFRegion object created based on CLLocation
 Each time an error occurs while monitoring a region the coresponding LocationDelegate method is called with the failing error
 */
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
