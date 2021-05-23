//
//  RegionData.swift
//  SYRFLocation
//
//  Created by SYRF on 4/20/21.
//

import Foundation
import CoreLocation

/**
 Base Region data class
 */
public class SYRFRegion: NSObject {
    
    /// The unique identifier of the region
    var identifier: String = UUID().uuidString
    
}

/**
 Circular Region data model
 Used by RegionManager
 */
public class SYRFCircularRegion: SYRFRegion {
    
    /// The center coordinates of the region
    public var center: SYRFCoordinate
    
    /// The radius in meters of the region
    public var radius: Double
    
    /**
     Default initializer
     Circular Region data is set to default 0 values
     */
    public override init() {
        self.center = SYRFCoordinate(latitude: 0, longitude: 0)
        self.radius = 0
        
        super.init()
    }
    
    /**
     Initializer using center and radius
     
     - Parameters:
        - center:  The region center coordinates.
        - radius: The region radius in meters.
     */
    public init(center: SYRFCoordinate, radius: Double) {
        self.center = center
        self.radius = radius
        
        super.init()
    }
    
    /**
     Initializer using CoreLocation
     Location data is set from CoreLocation data object
     
     - Parameters:
        - region:  The CLCircularRegion object.
     */
    init(region: CLCircularRegion) {
        self.center = SYRFCoordinate(latitude: region.center.latitude, longitude: region.center.longitude)
        self.radius = region.radius
        
        super.init()
    }
}

/**
 Region monitoring allowed types
 */
public enum SYRFRegionType {
    
    /// The circular type
    case circle
    
    /// The default not allowed type
    case none
}

/**
 Region usage errors
 */
public enum SYRFRegionError: Error {
    
    /// Region monitoring capabilities not available
    case notAvailable
    
    /// Region monitoring not configured correctly
    case notConfigured
    
    /// Region monitoring requested for an invalid region
    case invalidRegion
}
