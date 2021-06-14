//
//  TimeConfig.swift
//  SYRFTime
//
//  Created by SYRF on 5/10/21.
//

import Foundation

/**
 Time Manager configuration class
 Specifies manager operation parameters
*/
public class TimeConfig {
    
    /// The NTP server for time
    public var ntpHost: String
    
    /// The NTP server first synchronization number of samples
    public var samples: Int
    
    /**
     Default initializer
     Configuration parameters are set to default values
     */
    public init() {
        self.ntpHost = "time.apple.com"
        self.samples = 4
    }
    
    /**
     Initializer using specific NTP server values and number of samples
        
     - Parameters:
        - ntpHost: The NTP server
        - samples: The samples count
     */
    public init(ntpHost: String, samples: Int) {
        self.ntpHost = ntpHost
        self.samples = samples
    }
}
