//
//  SensorsAccleroManager.swift
//  SYRFLocation
//
//  Created by SYRF on 4/22/21.
//

import Foundation
import CoreMotion

/**
 Manager class responsible for providing accelerometer data information.
 
 Accelerometer monitoring is reported based on the SensorsAcceleroConfig.
 Accelerometer monitoring is done on a background queue or the main queue and provides new data at a specified interval
 
 A normal setup for the getting accelerometer data would be:
 - set up the SensorsAcceleroDelegate, as data updates are passed back through the delegate either set up at initialization time or by using the stored property
 - configure the SensorsAcceleroManager through the configure method
 - request acceleromater data updates through the startAcceleroUpdates method
 - acceleroUpdated is called each time new accelerometer data is obtained
 - when finished request to stop the updates through the stopAcceleroUpdates method
 */
public class SensorsAcceleroManager: NSObject {
    
    //MARK: - Properties
    
    /// The root object providing access to Core Motion functionality
    private let motionManager: CMMotionManager!
    
    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: SensorsAcceleroConfig!
    
    /// The manager delegate, used to pass back accelerometer data updates as they are gathered based on the update interval
    public var delegate: SensorsAcceleroDelegate?
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core motion manager and its configuration
     */
    public override init() {
        self.motionManager = CMMotionManager()
        self.configuration = SensorsAcceleroConfig()
        
        super.init()
        
        self.configure(self.configuration)
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back accelerometer monitoring updates
     */
    public convenience init(delegate: SensorsAcceleroDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Provide the manager with a specific SensorsAcceleroConfig object
     The configuration values are used for the core motion manager
     
     - Parameters:
        - configuration: The manager configuration values
     */
    public func configure(_ configuration: SensorsAcceleroConfig) {
        self.configuration = configuration
    }
    
    /**
     Entry point for monitoring accelerometer updates based on the default or custom configuration
     
     Before starting accelerometer data gathering the availability of core motion functionality is checked.
     If cannot proceed with monitoring the accelerometer sensor, the manager delegate will be informed of the failing error
     
     If accelerometer data can be retrieved the acceleroUpdated method of the delegate is called each time a new data is obtained
     The accelerometer data updates are provided using either a background queue or the main queue as configured
     */
    public func startAcceleroUpdates() {
        let (canUse, error) = SensorsUtils.canMonitorAccelero(self.motionManager)
        if (canUse) {
            let operationQueue = (self.configuration.runInBackground ?? true) ? OperationQueue() : OperationQueue.main
            self.motionManager.accelerometerUpdateInterval = self.configuration.updateInterval ?? 0
            self.motionManager.startAccelerometerUpdates(to: operationQueue) { ( acceleroData, error) in
                guard error == nil else {
                    self.delegate?.acceleroFailed(error!)
                    return
                }
                
                guard let acceleroData = acceleroData else {
                    return
                }
                
                self.delegate?.acceleroUpdated(SYRFSensorsAcceleroData(acceleroData: acceleroData))
            }
        } else if let error = error {
            self.delegate?.acceleroFailed(error)
        }
    }
    
    /**
     Entry point for stopping accelerometer data updates
     
     Before stopping accelerometer updates the availability of core motion functionality is checked.
     If cannot proceed with stopping the accelerometer updates the manager delegate will be informed of the failing error
     */
    public func stopAcceleroUpdates() {
        if (self.motionManager.isAccelerometerActive) {
            self.motionManager.stopAccelerometerUpdates()
        } else {
            self.delegate?.acceleroFailed(SYRFSensorsAcceleroError.notUpdating)
        }
    }
    
    //MARK: - Private Methods
    
}
