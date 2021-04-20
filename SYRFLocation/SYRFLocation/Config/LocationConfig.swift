//
//  LocationConfig.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

public class LocationManagerConfig {
    
    public var activityType: CLActivityType?
    public var distanceFilter: CLLocationDistance?
    public var desiredAccuracy: CLLocationAccuracy?
    public var pauseUpdatesAutomatically: Bool?
    public var allowUpdatesInBackground: Bool?
    public var allowIndicatorInBackground: Bool?
    
    public init() {
        self.activityType = .otherNavigation
        self.distanceFilter = kCLDistanceFilterNone
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.pauseUpdatesAutomatically = false
        self.allowUpdatesInBackground = true
        self.allowIndicatorInBackground = true
    }

}
