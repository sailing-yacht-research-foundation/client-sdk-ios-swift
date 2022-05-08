//
//  HeadingManager.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation

/**
 Manager class responsible for providing heading information monitoring and updates.
 
 Heading monitoring is reported based on the HeadingManagerConfig.
 The headingOrientation from the config determines the heading information as it's relative to the value used.
 The heading information updates are obtained based on the headingFilter value, each heading update means that the headingFilter was exceeded.
 
 A normal setup for the monitoring heading updates would be:
 - set up the HeadingDelegate, as heading updates are passed back through the delegate set up either at initialization time or by using the stored property
 - configure the HeadingManager through the configure method
 - request heading updates through the startHeadingUpdates method
 - headingUpdated is called each time a new relevant heading information is obtained that respects the configuration
 - when finished request to stop the updates through the stopHeadingUpdates method
 */
public class HeadingManager: NSObject {
    
    //MARK: - Properties
    
    /// The root object providing access to Core Location functionality
    private let locationManager: CLLocationManager!
    
    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: HeadingManagerConfig!

    /// The manager delegate, used to pass back heading information as they are obtained
    public var delegate: HeadingDelegate?
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core location manager and its configuration
     */
    public override init() {
        self.locationManager = CLLocationManager()
        self.configuration = HeadingManagerConfig()
        
        super.init()
        
        self.locationManager.delegate = self
        self.configure(self.configuration)
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back heading information
     */
    public convenience init(delegate: HeadingDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Provide the manager with a specific HeadingManagerConfig object
     The configuration values are used for the core location manager
     
     - Parameters:
        - configuration: The manager configuration values
     */
    public func configure(_ configuration: HeadingManagerConfig) {
        self.configuration = configuration
        
        if let headingOrientation = configuration.headingOrientation {
            self.locationManager.headingOrientation = headingOrientation
        }
        if let headingFilter = configuration.headingFilter {
            self.locationManager.headingFilter = headingFilter
        }
    }
    
    public func configureEnabled(_ configuration: HeadingManagerConfig) {
        self.configure(configuration)
        
        if configuration.enabled {
            self.startHeadingUpdates()
        } else {
            self.stopHeadingUpdates()
        }
    }
    
    /**
     Entry point for monitoring heading information updates based on the default or custom configuration
     
     Before starting heading updates the current permissions access and availability of core location functionality is checked.
     If cannot proceed with monitoring heading updates the manager delegate will be informed of the failing error
     */
    public func startHeadingUpdates() {
        let (canUse, error) = LocationUtils.canUseCoreLocation()
        if (canUse) {
            self.locationManager.startUpdatingHeading()
        } else if let error = error {
            self.delegate?.headingFailed(error)
        }
    }
    
    /**
     Entry point for stoping the heading information updates monitoring
     
     Before stopping heading updates the current permissions access and availability of core location functionality is checked.
     If cannot proceed with stopping heading updates monitoring the manager delegate will be informed of the failing error
     */
    public func stopHeadingUpdates() {
        let (canUse, error) = LocationUtils.canUseCoreLocation()
        if (canUse) {
            self.locationManager.stopUpdatingHeading()
        } else if let error = error {
            self.delegate?.headingFailed(error)
        }
    }
    
}

/**
 Core Location Manager Delegate Extension
 Heading updates are provided through the Core Location Manager Delegate
 Each time a new heading is obtained the coresponding HeadingDelegate method is called with the custom SYRFHeading object created based on CLHeading
 Each time an error occurs while monitoring heading information the coresponding HeadingDelegate method is called with the failing error
 */
extension HeadingManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.delegate?.headingUpdated(SYRFHeading(heading: newHeading))
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.headingFailed(error)
    }
}
