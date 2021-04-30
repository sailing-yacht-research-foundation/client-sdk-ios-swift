//
//  RegionData.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/20/21.
//

import Foundation
import CoreLocation

public class SYRFRegion: NSObject {
    
    var identifier: String = UUID().uuidString
    
}

public class SYRFCircularRegion: SYRFRegion {
    
    public var center: SYRFCoordinate
    public var radius: Double
    
    public override init() {
        self.center = SYRFCoordinate(latitude: 0, longitude: 0)
        self.radius = 0
        
        super.init()
    }
    
    public init(center: SYRFCoordinate, radius: Double) {
        self.center = center
        self.radius = radius
        
        super.init()
    }
    
    init(region: CLCircularRegion) {
        self.center = SYRFCoordinate(latitude: region.center.latitude, longitude: region.center.longitude)
        self.radius = region.radius
        
        super.init()
    }
}

public enum SYRFRegionType {
    case circle
    case none
}

public enum SYRFRegionError: Error {
    case notAvailable
    case notConfigured
    case invalidRegion
}
