//
//  EngineOneData.swift
//  SYRFGeospatial
//
//  Created by Radu Rad on 5/28/21.
//

/**
 Geospacial Engine One usage errors
 */
public enum SYRFGeospecialEngineOne: Error {
    
    /// Engine capabilities not initialized, internal error
    case notInitialized
    
    /// Engine capabilities not allowed
    case notAllowed
}
