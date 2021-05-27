//
//  LocationManager.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

// LocationManager
public class LocationManager: NSObject {
    
    //MARK: - Properties
    
    private let locationManager: CLLocationManager!
    private var configuration: LocationManagerConfig!
    private var isUpdating: Bool = false
    private var isMonitoring: Bool = false
    private var isGettingLocation: Bool = false
    
    public var delegate: LocationDelegate?
    
    //MARK: - Lifecycle
    
    public override init() {
        self.locationManager = CLLocationManager()
        self.configuration = LocationManagerConfig()
        
        super.init()
        
        self.locationManager.delegate = self
        self.configure(self.configuration)
    }
    
    public convenience init(delegate: LocationDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
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
    
    public func getCurrentLocation() {
        let (canUse, error) = LocationUtils.canUseCoreLocation()
        if (canUse) {
            self.locationManager.requestLocation()
            self.isGettingLocation = true
        } else if let error = error {
            self.delegate?.locationFailed(error)
        }
    }
    
    public func startLocationUpdates() {
        let (canUse, error) = LocationUtils.canUseCoreLocation()
        if (canUse) {
            if (self.shouldUseMonitoring()) {
                self.locationManager.startMonitoringSignificantLocationChanges()
                self.isMonitoring = true
            } else {
                self.locationManager.startUpdatingLocation()
                self.isUpdating = true
            }
        } else if let error = error {
            self.delegate?.locationFailed(error)
        }
    }
    
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
    
    
    
    private func shouldUseMonitoring() -> Bool {
        if (CLLocationManager.significantLocationChangeMonitoringAvailable()) {
            return self.configuration.activityType == .other
        } else {
            return false
        }
    }
}

// Core Location Manager Delegate Extension
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
