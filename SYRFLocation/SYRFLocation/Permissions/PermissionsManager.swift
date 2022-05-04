//
//  PermissionsManager.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation

/**
 Manager class responsible for providing core location permissions status and requesting permissions
 
 PermissionsManager is to be used before requesting monitoring or one-time location through the use of the LocationManager.
 
 PermissionsManager informs about the permissions status through:
 - checkAuthorization
 - checkAccuracy
 
 PermissionsManager can request permissions for core location through:
 - requestAuthorization
 - requestAccuracy
 */
public class PermissionsManager: NSObject {
    
    //MARK: - Properties
    
    /// The manager delegate, used to pass back location information as they are obtained
    public var delegate: PermissionsDelegate?
    
    /// The root object providing access to Core Location functionality
    private let locationManager: CLLocationManager!
    
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?

    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core location manager
     */
    override public init() {
        self.locationManager = CLLocationManager()
        self.delegate = nil
        
        super.init()
        
        self.locationManager.delegate = self
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back permissions information
     */
    public convenience init(delegate: PermissionsDelegate?) {
        self.init()
        
        self.delegate = delegate
    }
    
    /**
     Deinitializer of the manager
    */
    deinit {
        
    }
    
    //MARK: - Public Methods
    
    /**
     Retrive Core Location authorization permissions status
     
     - Returns:
        A PermissionsAuthorization status
     */
    public func checkAuthorization() -> PermissionsAuthorization {
        return self.getAuthorizationStatus()
    }
    
    /**
     Retrive Core Location accuracy permissions status
     
     - Returns:
        A PermissionsAccuracy status
     */
    public func checkAccuracy() -> PermissionsAccuracy {
        return self.getAccuracyStatus()
    }
    
    /**
     Request Core Location authorization permissions
     Allowed permissions are always and whenInUse
     
     - Parameters:
        - type: A permission type that will be requested
     */
    public func requestAuthorization(_ type: PermissionsType) {
        switch type {
        case .always:
            if #available(iOS 13.4, *) {
                self.requestLocationAuthorizationCallback = { status in
                    if status == .authorizedWhenInUse {
                        self.locationManager.requestAlwaysAuthorization()
                    }
                }
                self.locationManager.requestWhenInUseAuthorization()
            } else {
                self.locationManager.requestAlwaysAuthorization()
            }
        case .whenInUse:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /**
     Request Core Location accuracy permissions
     Allowed permissions are full and reduced
     
     - Parameters:
        - type: A permission purpose description key
     */
    public func requestAccuracy(_ purposeKey: String) {
        if #available(iOS 14.0, *) {
            self.locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposeKey)
        } else {
            self.delegate?.accuracyUpdated(.notAvailable)
        }
    }
    
    //MARK: - Private Methods
    
    /**
     Checks Core Location authorization permissions status
     Based on Core Location authorization permissions the PermissionsAuthorization status is returned
     
     - Returns:
        A PermissionsAuthorization status
     */
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
    
    /**
     Checks Core Location accuracy permissions status
     Based on Core Location accuracy permissions the PermissionsAccuracy status is returned
     
     - Returns:
        A PermissionsAccuracy status
     */
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

/**
 Core Location Manager Delegate Extension
 Permissions updates are provided through the Core Location Manager Delegate
 Each time the permissions authorization or accuracy status changes the coresponding PermissionsDelegate method is called
 */
extension PermissionsManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.delegate?.authorizationUpdated(self.getAuthorizationStatus())
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.requestLocationAuthorizationCallback?(CLLocationManager.authorizationStatus())
        self.delegate?.authorizationUpdated(self.getAuthorizationStatus())
        self.delegate?.accuracyUpdated(self.getAccuracyStatus())
    }
}
