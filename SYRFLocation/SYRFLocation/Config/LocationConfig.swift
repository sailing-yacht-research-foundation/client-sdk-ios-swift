//
//  LocationConfig.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation

/**
 Location Manager configuration class
 Specifies manager operation parameters
*/
public class LocationManagerConfig {
    
    /// The used activity type to determine the optimization level of the location updates
    public var activityType: CLActivityType?
    
    /// The minimum changes in distance for which location updates are provided
    public var distanceFilter: CLLocationDistance?
    
    /// The accuracy of the location updates. The accuracy is not guaranteed by the location manager, but a lower value will yield a better accuracy
    public var desiredAccuracy: CLLocationAccuracy?
    
    /// The battery optimization value specifying if location manager updates can be suspended when possible
    public var pauseUpdatesAutomatically: Bool?
    
    /// The location manager can provide updates while the application is in background. If set to true, the background mode for location updates should also be set in the plist file
    public var allowUpdatesInBackground: Bool?
    
    /// The visual indicator value. The config value is only taken into consideration when permission are always and application runs in background
    public var allowIndicatorInBackground: Bool?
    
    /**
     Default initializer
     Configuration parameters are set to default values for best accuracy and all location updates
     */
    public init() {
        self.activityType = .otherNavigation
        self.distanceFilter = kCLDistanceFilterNone
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.pauseUpdatesAutomatically = false
        self.allowUpdatesInBackground = false
        self.allowIndicatorInBackground = true
    }

}
