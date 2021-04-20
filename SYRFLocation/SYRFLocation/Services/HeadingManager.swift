//
//  HeadingManager.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

// HeadingManager
public class HeadingManager: NSObject {
    
    //MARK: - Properties
    
    private let locationManager: CLLocationManager!
    private var configuration: HeadingManagerConfig!
    private var isUpdating: Bool = false
    
    public var delegate: HeadingDelegate?
    
    //MARK: - Lifecycle
    
    public override init() {
        self.locationManager = CLLocationManager()
        self.configuration = HeadingManagerConfig()
        
        super.init()
        
        self.locationManager.delegate = self
        self.configure(self.configuration)
    }
    
    public convenience init(delegate: HeadingDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    public func configure(_ configuration: HeadingManagerConfig) {
        self.configuration = configuration
        
        if let headingOrientation = configuration.headingOrientation {
            self.locationManager.headingOrientation = headingOrientation
        }
        if let headingFilter = configuration.headingFilter {
            self.locationManager.headingFilter = headingFilter
        }
    }
    
    public func startHeadingUpdates() {
        let (canUse, error) = LocationUtils.canUseLocation()
        if (canUse) {
            self.locationManager.startUpdatingHeading()
        } else if let error = error {
            self.delegate?.headingFailed(error)
        }
    }
    
    public func stopHeadingUpdates() {
        let (canUse, error) = LocationUtils.canUseLocation()
        if (canUse) {
            self.stopHeadingUpdates()
        } else if let error = error {
            self.delegate?.headingFailed(error)
        }
    }
    
    //MARK: - Private Methods
    
}

// Core Location Manager Delegate Extension
extension HeadingManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.delegate?.headingUpdated(SYRFHeading(heading: newHeading))
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.headingFailed(error)
    }
}
