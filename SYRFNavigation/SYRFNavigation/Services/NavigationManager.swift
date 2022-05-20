//
//  LocationManager.swift
//  SYRFNavigation
//
//  Created by SYRF on 4/20/21.
//

import UIKit
import CoreLocation
import SYRFLocation
import SYRFDeviceInfo

/**
 Navigation Updates protocol
 NavigationManager class delegate
*/
public protocol NavigationDelegate {
    
    /**
     Delegate method for navigation updates when NavigationManager is monitoring significant changes or navigation updates
     
     - Parameters:
        - navigation:  The navigation update object.
     - Note:
        Called each time the NavigationManager has obtained a new navigation
     */
    func navigationUpdated(_ navigation: SYRFNavigation)
    
    /**
     Delegate method for navigation updates errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during NavigationManager lifecycle
        Erros can be permission errors, incorrect usage or CoreNavigation errors
     */
    func navigationFailed(_ error: Error)
}

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

public class NavigationManager: NSObject {
    
    //MARK: - Properties
    
    /// The location manager
    private var locationManager: LocationManager!
    
    /// The heading manager
    private var headingManager: HeadingManager!
    
    /// The device info manager
    private var deviceInfoManager: DeviceInfoManager!
    
    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: NavigationManagerConfig!
    
    /// The manager delegate, used to pass back navigation information as they are obtained
    public var delegate: NavigationDelegate?
    
    private var updateThrottle = Throttle(minimumDelay: DefaultThrottleForegroundDelay)
    private var lastLocation: SYRFLocation? = nil
    private var lastHeading: SYRFHeading? = nil
    private var lastDeviceInfo: SYRFDeviceInfo? = nil
    
    private var currentNavigationCompletion: ((SYRFNavigation?, Error?) -> ())? = nil
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core location manager and its configuration
     */
    public override init() {
        self.locationManager = LocationManager()
        self.headingManager = HeadingManager()
        self.deviceInfoManager = DeviceInfoManager()
        self.configuration = NavigationManagerConfig()
        
        super.init()
        
        self.locationManager.delegate = self
        self.headingManager.delegate = self
        self.configure(self.configuration)
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back location information
     */
    public convenience init(delegate: NavigationDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Provide the manager with a specific NavigationManagerConfig object
     The configuration values are used for the navigation manager modules
     
     - Parameters:
        - configuration: The manager configuration values
     */
    public func configure(_ configuration: NavigationManagerConfig) {
        self.configuration = configuration
        
        if let config = configuration.locationConfig {
            self.locationManager.configure(config)
        }
        if let config = configuration.headingConfig {
            self.headingManager.configure(config)
        }
        if let config = configuration.deviceInfoConfig {
            self.deviceInfoManager.configure(config)
        }
    }
    
    /**
     Entry point for requesting a one-time current location information
     
     If the current location can be retrieved the currentLocationUpdated method of the delegate is called
     If the current location cannot be retrieved due to permissions, access or internal error the locationFailed method of the delegate is called
     
     In addition to requesting the current location, use the most recent location as well, if available
     
     */
    public func getCurrentNavigation(_ options: [String: Any]?, _ completion: ((SYRFNavigation?, Error?) -> ())?) {
        if (options?["location"] as? Bool ?? false) == false {
            completion?(prepareData(), nil)
            return
        }
        
        self.currentNavigationCompletion = { (navigation, error) in
            self.currentNavigationCompletion = nil
            completion?(navigation, error)
        }
        self.locationManager.getCurrentLocation()
    }
    
    /**
     Provide the manager with a specific LocationManagerConfig object
     The configuration values are used for the core location manager
     
     - Parameters:
        - options: The manager configuration values
     */
    public func updateNavigationSettings(_ options: [String: Any]?, _ completion: ((Error?) -> ())?) {
        if let val = options?["location"] as? Bool {
            self.locationManager.configureEnabled(val)
        }
        if let val = options?["heading"] as? Bool {
            self.headingManager.configureEnabled(val)
        }
        if let val = options?["deviceInfo"] as? Bool {
            self.deviceInfoManager.configureEnabled(val)
        }
        
        completion?(nil)
    }
    
    
    //MARK: - Private Methods
    
    func prepareData() -> SYRFNavigation {
        let data = SYRFNavigation()
        if let _ = self.configuration.deviceInfoConfig {
            let deviceInfo = SYRFDeviceInfo()
            deviceInfo.deviceModel = deviceInfoManager.getPhoneModel()
            deviceInfo.osVersion = deviceInfoManager.getOsVersion()
            deviceInfo.batteryLevel = deviceInfoManager.getBatteryLevel()
            lastDeviceInfo = deviceInfo
            data.deviceInfo = lastDeviceInfo
        }
        if let _ = self.configuration.locationConfig {
            data.location = lastLocation
        }
        if let _ = self.configuration.headingConfig {
            data.heading = lastHeading
        }
        return data
    }
    
    func fireUpdate() {
        let data = prepareData()
        
        self.delegate?.navigationUpdated(data)
    }
    
    func processUpdate() {
        if (lastLocation != nil && lastHeading == nil && self.configuration.headingConfig?.enabled == true) ||
            (lastHeading != nil && lastLocation == nil && self.configuration.locationConfig?.enabled == true)
        {
            return
        }
        
        let delay = UIApplication.shared.applicationState == .background ?
        (self.configuration.throttleBackgroundDelay ?? DefaultThrottleBackgroundDelay) :
        (self.configuration.throttleForegroundDelay ?? DefaultThrottleForegroundDelay)
        
        if (updateThrottle.minimumDelay != delay) {
            updateThrottle.updateMinimumDelay(interval: delay)
        }
        
        updateThrottle.throttle {
            self.fireUpdate()
        }
    }
    
    func processCurrentUpdate(_ error: Error? = nil) {
        if let completion = currentNavigationCompletion {
            if let error = error {
                completion(nil, error)
            } else {
                completion(prepareData(), nil)
            }
        }
    }
    
    func processError(_ error: Error) {
        self.delegate?.navigationFailed(error)
        processCurrentUpdate(error)
    }
}


// MARK: - Extension for LocationManager Delegate
extension NavigationManager: LocationDelegate {
    
    public func locationFailed(_ error: Error) {
        processError(error)
    }
    
    public func locationUpdated(_ location: SYRFLocation) {
        lastLocation = location
        processUpdate()
    }
    
    public func currentLocationUpdated(_ location: SYRFLocation) {
        lastLocation = location
        processCurrentUpdate()
    }
}

// MARK: - Extension for HeadingManager Delegate
extension NavigationManager: HeadingDelegate {
    
    public func headingFailed(_ error: Error) {
        processError(error)
    }
    
    public func headingUpdated(_ heading: SYRFHeading) {
        lastHeading = heading
        processUpdate()
    }
}
