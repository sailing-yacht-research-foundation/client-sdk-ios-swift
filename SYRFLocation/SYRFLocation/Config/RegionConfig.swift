//
//  RegionConfig.swift
//  SYRFLocation
//
//  Created by SYRF on 4/21/21.
//

import Foundation

/**
 Region Manager configuration class
 Specifies manager operation parameters
 */
public class RegionManagerConfig {
    
    /// The region updates are provided for exiting a region
    public var updateOnExit: Bool?
    
    /// The region updates are provided for entering a region
    public var updateOnEnter: Bool?
    
    /**
     Default initializer
     Configuration parameters are set to default values
     */
    public init() {
        self.updateOnExit = false
        self.updateOnEnter = true
    }
    
    /**
     Initializer using specific update on enter and exit values
     Region configuration is set from parameters
        
     - Parameters:
        - updateOnEnter: The update region on entering value.
        - updateOnExit : The update region on exiting value.
     */
    public init(updateOnEnter: Bool, updateOnExit: Bool) {
        self.updateOnEnter = updateOnEnter
        self.updateOnExit = updateOnExit
    }
}
