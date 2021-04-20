//
//  HeadingConfig.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

public class HeadingManagerConfig {
    
    public var headingOrientation: CLDeviceOrientation?
    public var headingFilter: CLLocationDegrees?
    
    public init() {
        self.headingOrientation = .portrait
        self.headingFilter = kCLHeadingFilterNone
    }
}
