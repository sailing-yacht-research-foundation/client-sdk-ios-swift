//
//  EngineOneData.swift
//  SYRFGeospatial
//
//  Created by SYRF on 5/28/21.
//

/**
 Geospacial Engine One usage errors
 */
public enum SYRFGeospecialEngineTwo: Error {
    
    /// Engine capabilities not initialized, internal error
    case notInitialized
    
    /// Engine not able to produce a result
    case notAvailable
}
