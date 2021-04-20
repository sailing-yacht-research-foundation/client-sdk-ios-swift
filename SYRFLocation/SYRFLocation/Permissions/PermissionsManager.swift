//
//  PermissionsManager.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

// Permissions Manager
public class PermissionsManager: NSObject {
    
    //MARK: - Properties
    
    public var delegate: PermissionsDelegate?
    
    private let locationManager: CLLocationManager!
    
    //MARK: - Lifecycle
    
    override public init() {
        self.locationManager = CLLocationManager()
        self.delegate = nil
        
        super.init()
        
        self.locationManager.delegate = self
    }
    
    public convenience init(delegate: PermissionsDelegate?) {
        self.init()
        
        self.delegate = delegate
    }
    
    deinit {
        
    }
    
    //MARK: - Public Methods
    
    public func checkAuthorization() -> PermissionsAuthorization {
        return self.getAuthorizationStatus()
    }
    
    public func checkAccuracy() -> PermissionsAccuracy {
        return self.getAccuracyStatus()
    }
    
    public func requestAuthorization(_ type: PermissionsType) {
        switch type {
        case .always:
            self.locationManager.requestAlwaysAuthorization()
        case .whenInUse:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func requestAccuracy(_ purposeKey: String) {
        if #available(iOS 14.0, *) {
            self.locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposeKey)
        } else {
            self.delegate?.accuracyUpdated(.notAvailable)
        }
    }
    
    //MARK: - Private Methods
    
    private func getAuthorizationStatus() -> PermissionsAuthorization {
        var status = PermissionsAuthorization.notDetermined
        var authorizationStatus = CLAuthorizationStatus.notDetermined
        
        if (!CLLocationManager.locationServicesEnabled()) {
            return .notAvailable
        }
        
        if #available(iOS 14.0, *) {
            authorizationStatus = self.locationManager.authorizationStatus
            
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus {
        case .authorizedAlways:
            status = .authorizedAlways
        case .authorizedWhenInUse:
            status = .authorizedWhenInUse
        case .notDetermined:
            status = .notDetermined
        default:
            status = .notAuthorized
        }
        
        return status
    }
    
    private func getAccuracyStatus() -> PermissionsAccuracy {
        var status = PermissionsAccuracy.reduced
        
        if (!CLLocationManager.locationServicesEnabled()) {
            return .notAvailable
        }
        
        if #available(iOS 14.0, *) {
            switch self.locationManager.accuracyAuthorization {
            case .fullAccuracy:
                status = .full
            default:
                status = .reduced
            }
        } else {
            status = .notAvailable
        }
        
        return status
    }
    
}

// Core Location Manager Delegate extension
extension PermissionsManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.delegate?.authorizationUpdated(self.getAuthorizationStatus())
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.delegate?.authorizationUpdated(self.getAuthorizationStatus())
        self.delegate?.accuracyUpdated(self.getAccuracyStatus())
    }
}
