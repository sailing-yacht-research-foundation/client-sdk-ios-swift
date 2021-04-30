//
//  RegionConfig.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/21/21.
//

import Foundation

public class RegionManagerConfig {
    
    public var updateOnExit: Bool?
    public var updateOnEnter: Bool?
    
    public init() {
        self.updateOnExit = false
        self.updateOnEnter = true
    }
    
    public init(updateOnEnter: Bool, updateOnExit: Bool) {
        self.updateOnEnter = updateOnEnter
        self.updateOnExit = updateOnExit
    }
}
