//
//  TimeManager.swift
//  SYRFTime
//
//  Created by SYRF on 5/10/21.
//

import Foundation
import Kronos
/**
 Manager class responsible for providing time information.
 
 Time information is reported based on the HeadingManagerConfig.
 The headingOrientation from the config determines the heading information as it's relative to the value used.
 The heading information updates are obtained based on the headingFilter value, each heading update means that the headingFilter was exceeded.
 
 A normal setup for the getting time updates would be:
 - set up the TimeDelegate, as time updates are passed back through the delegate
 - configure the TimeManager through the configure method
 - request time updates through the startTimeUpdates method
 - timeUpdated is called each time a new relevant time information is obtained
 - when finished request to stop the updates through the stopTimeUpdates method
 */
public class TimeManager: NSObject {
    
    //MARK: - Properties
    
    /// The timer on which ntp delivers updates
    private var timer: Timer?
    
    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: TimeConfig!

    /// The manager delegate, used to pass back time information as they are obtained
    public var delegate: TimeDelegate?
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core location manager and its configuration
     */
    public override init() {
        self.configuration = TimeConfig()
        
        super.init()
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back time information
     */
    public convenience init(delegate: TimeDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Provide the manager with a specific TimeConfig object
     The configuration values are used for the clock NTP server pool
     
     - Parameters:
        - configuration: The manager configuration values
     */
    public func configure(_ configuration: TimeConfig) {
        self.configuration = configuration
    }
    
    /**
     Entry point for requesting time information updates based on the default or custom configuration
     */
    public func startTimeUpdates() {
        Clock.sync(from: self.configuration.ntpHost, samples: self.configuration.samples, first: nil) { time, offset in
            if let time = time {
                self.delegate?.timeUpdated(time: time)
            }
            
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimeManager.tick), userInfo: nil, repeats: true)
        }
    }
    
    /**
     Entry point for stoping the time information updates
     */
    public func stopTimeUpdates() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    /**
     Callback method of fired timer for time updates
     */
    @objc func tick() {
        if let time = Clock.now {
            self.delegate?.timeUpdated(time: time)
        }
    }
    
}
