//
//  SensorsGyroManager.swift
//  SYRFLocation
//
//  Created by SYRF on 4/22/21.
//

import Foundation
import CoreMotion

/**
 Manager class responsible for providing gyroscope data information.
 
 Gyroscope monitoring is reported based on the SensorsGyroConfig.
 Gyroscope monitoring is done on a background queue or the main queue and provides new data at a specified interval
 
 A normal setup for the getting gyroscope data would be:
 - set up the SensorsGyroDelegate, as data updates are passed back through the delegate either set up at initialization time or by using the stored property
 - configure the SensorsGyroManager through the configure method
 - request gyroscope data updates through the startGyroUpdates method
 - gyroUpdated is called each time new gyroscope data is obtained
 - when finished request to stop the updates through the stopGyroUpdates method
 */
public class SensorsGyroManager: NSObject {
    
    //MARK: - Properties
    
    /// The root object providing access to Core Motion functionality
    private let motionManager: CMMotionManager!
    
    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: SensorsGyroConfig!
    
    /// The manager delegate, used to pass back gyroscope data updates as they are gathered based on the update interval
    public var delegate: SensorsGyroDelegate?
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core motion manager and its configuration
     */
    public override init() {
        self.motionManager = CMMotionManager()
        self.configuration = SensorsGyroConfig()
        
        super.init()
        
        self.configure(self.configuration)
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back magnetometer monitoring updates
     */
    public convenience init(delegate: SensorsGyroDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Provide the manager with a specific SensorsGyroConfig object
     The configuration values are used for the core motion manager
     
     - Parameters:
        - configuration: The manager configuration values
     */
    public func configure(_ configuration: SensorsGyroConfig) {
        self.configuration = configuration
    }
    
    /**
     Entry point for monitoring gyroscope updates based on the default or custom configuration
     
     Before starting gyroscope data gathering the availability of core motion functionality is checked.
     If cannot proceed with monitoring the gyroscope sensor, the manager delegate will be informed of the failing error
     
     If gyroscope data can be retrieved the gyroUpdated method of the delegate is called each time a new data is obtained
     The gyroscope data updates are provided using either a background queue or the main queue as configured
     */
    public func startGyroUpdates() {
        let (canUse, error) = SensorsUtils.canMonitorGyro(self.motionManager)
        if (canUse) {
            let operationQueue = (self.configuration.runInBackground ?? true) ? OperationQueue() : OperationQueue.main
            self.motionManager.gyroUpdateInterval = self.configuration.updateInterval ?? 0
            self.motionManager.startGyroUpdates(to: operationQueue) { ( gyroData, error) in
                guard error == nil else {
                    self.delegate?.gyroFailed(error!)
                    return
                }
                
                guard let gyroData = gyroData else {
                    return
                }
                
                self.delegate?.gyroUpdated(SYRFSensorsGyroData(gyroData: gyroData))
            }
        } else if let error = error {
            self.delegate?.gyroFailed(error)
        }
    }
    
    /**
     Entry point for stopping gyroscope data updates
     
     Before stopping gyroscope updates the availability of core motion functionality is checked.
     If cannot proceed with stopping the gyroscope updates the manager delegate will be informed of the failing error
     */
    public func stopGyroUpdates() {
        if (self.motionManager.isGyroActive) {
            self.motionManager.stopGyroUpdates()
        } else {
            self.delegate?.gyroFailed(SYRFSensorsGyroError.notUpdating)
        }
    }
    
    //MARK: - Private Methods
    
}
