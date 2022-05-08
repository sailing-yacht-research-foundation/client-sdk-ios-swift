//
//  LocationManager.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation

/**
 Manager class responsible for providing location information monitoring and updates.
 
 Location monitoring is reported based on the LocationManagerConfig.
 The combination of the configuration values will determine how often the updates are obtained and how accurate they are.
 In addition the execution mode of the manager is configured: the background mode, visible indicators etc.
 
 A normal setup for the monitoring location updates would be:
 - set up the LocationDelegate, as location updates are passed back through the delegate set up either at initialization time or by using the stored property
 - configure the LocationManager through the configure method
 - request location updates through the startLocationUpdates method
 - locationUpdated is called each time a new relevant location information is obtained that respects the configuration
 - when finished request to stop the updates through the stopLocationUpdates method
 
 A normal setup for obtaining a one-time location information would be:
 - set up the LocationDelegate, as location updates are passed back through the delegate either at initialization time or by using the stored property
 - configure the LocationManager through the configure method
 - request current location through the getCurrentLocation method
 - currentLocationUpdated is called one-time after the current location information is obtained that respects the configuration
 */

public class LocationManager: NSObject {
    
    //MARK: - Properties
    
    /// The root object providing access to Core Location functionality
    private let locationManager: CLLocationManager!
    
    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: LocationManagerConfig!
    
    /// The status of the location manager, indicating that standard location monitoring is enabled, obtaining the most accurate results
    private var isUpdating: Bool = false
    
    /// The status of the location manager, indicating that significant location monitoring is enabled, obtaining low accuracy results
    private var isMonitoring: Bool = false
    
    /// The status of the location manager, indicating that a one-time location information request is in progress
    private var isGettingLocation: Bool = false
    
    /// The manager delegate, used to pass back location information as they are obtained
    public var delegate: LocationDelegate?
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core location manager and its configuration
     */
    public override init() {
        self.locationManager = CLLocationManager()
        self.configuration = LocationManagerConfig()
        
        super.init()
        
        self.locationManager.delegate = self
        self.configure(self.configuration)
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back location information
     */
    public convenience init(delegate: LocationDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Provide the manager with a specific LocationManagerConfig object
     The configuration values are used for the core location manager
     
     - Parameters:
        - configuration: The manager configuration values
     */
    public func configure(_ configuration: LocationManagerConfig) {
        self.configuration = configuration
        
        if let activity = configuration.activityType {
            self.locationManager.activityType = activity
        }
        if let distanceFilter = configuration.distanceFilter {
            self.locationManager.distanceFilter = distanceFilter
        }
        if let desiredAccuracy = configuration.desiredAccuracy {
            self.locationManager.desiredAccuracy = desiredAccuracy
        }
        if let pauseAutomatically = configuration.pauseUpdatesAutomatically {
            self.locationManager.pausesLocationUpdatesAutomatically = pauseAutomatically
        }
        if let allowBackground = configuration.allowUpdatesInBackground {
            self.locationManager.allowsBackgroundLocationUpdates = allowBackground
        }
        if let allowIndicator = configuration.allowIndicatorInBackground {
            self.locationManager.showsBackgroundLocationIndicator = allowIndicator
        }
    }
    
    public func configureEnabled(_ configuration: LocationManagerConfig) {
        self.configure(configuration)
        
        if configuration.enabled {
            self.startLocationUpdates()
        } else {
            self.stopLocationUpdates()
        }
    }
    
    /**
     Entry point for requesting a one-time current location information
     
     If the current location can be retrieved the currentLocationUpdated method of the delegate is called
     If the current location cannot be retrieved due to permissions, access or internal error the locationFailed method of the delegate is called
     
     In addition to requesting the current location, use the most recent location as well, if available
     
     */
    public func getCurrentLocation() {
        let (canUse, error) = LocationUtils.canUseCoreLocation()
        if (canUse) {
            self.isGettingLocation = true
            self.locationManager.requestLocation()
        } else if let error = error {
            self.delegate?.locationFailed(error)
        }
    }
    
    /**
     Entry point for monitoring location information updates based on the default or custom configuration
     
     Before starting location updates the current permissions access and availability of core location functionality is checked.
     If cannot proceed with monitoring heading updates the manager delegate will be informed of the failing error
     
     If location updates can be retrieved the locationUpdated method of the delegate is called each time a new location is obtained that follows the configuration
     
     */
    public func startLocationUpdates() {
        let (canUse, error) = LocationUtils.canUseCoreLocation()
        if (canUse) {
            if (self.shouldUseMonitoring()) {
                self.isMonitoring = true
                self.locationManager.startMonitoringSignificantLocationChanges()
            } else {
                self.isUpdating = true
                self.locationManager.startUpdatingLocation()
            }
        } else if let error = error {
            self.delegate?.locationFailed(error)
        }
    }
    
    /**
     Entry point for stoping the location information updates monitoring
     
     Before stopping location updates the current permissions access and availability of core location functionality is checked.
     If cannot proceed with stopping location updates monitoring the manager delegate will be informed of the failing error
     */
    public func stopLocationUpdates() {
        let (canUse, error) = LocationUtils.canUseCoreLocation()
        if (canUse) {
            if (self.isMonitoring) {
                self.locationManager.stopMonitoringSignificantLocationChanges()
                self.isMonitoring = false
            } else {
                self.locationManager.stopUpdatingLocation()
                self.isUpdating = false
            }
        } else if let error = error {
            self.delegate?.locationFailed(error)
        }
    }
    
    //MARK: - Private Methods
    
    /**
     Determines the operation mode of location monitoring to be either significant updates only or standard updates.
     Significant updates only should be used only when the activity is not time-dependant.
     */
    private func shouldUseMonitoring() -> Bool {
        if (CLLocationManager.significantLocationChangeMonitoringAvailable()) {
            return self.configuration.activityType == .other
        } else {
            return false
        }
    }
    
    /**
     Retrieve most recent location information
     Notify the delegate if a location a available
     */
    private func updateRecentLocation() {
        if let lastLocation = self.locationManager.location {
            self.delegate?.currentLocationUpdated(SYRFLocation(location: lastLocation))
        }
    }
}

/**
 Core Location Manager Delegate Extension
 Location updates are provided through the Core Location Manager Delegate
 Each time a new location is obtained the coresponding LocationDelegate method is called with the custom SYRFLocation object created based on CLLocation
 Each time an error occurs while monitoring location information the coresponding LocationDelegate method is called with the failing error
 */
extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if (self.isGettingLocation) {
                self.delegate?.currentLocationUpdated(SYRFLocation(location: location))
                self.isGettingLocation = false
            }
            if (self.isUpdating || self.isMonitoring) {
                self.delegate?.locationUpdated(SYRFLocation(location: location))
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationFailed(error)
    }
}
