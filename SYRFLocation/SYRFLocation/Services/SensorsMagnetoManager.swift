//
//  SensorsMagnetoManager.swift
//  SYRFLocation
//
//  Created by SYRF on 4/22/21.
//

import Foundation
import CoreMotion

/**
 Manager class responsible for providing magnetometer data information.
 
 Magnetometer monitoring is reported based on the SensorsMagnetoConfig.
 Magnetometer monitoring is done on a background queue or the main queue and provides new data at a specified interval
 
 A normal setup for the getting magnetometer data would be:
 - set up the SensorsMagnetoDelegate, as data updates are passed back through the delegate either set up at initialization time or by using the stored property
 - configure the SensorsMagnetoManager through the configure method
 - request magnetometer data updates through the startMagnetoUpdates method
 - magnetoUpdated is called each time new magnetormeter data is obtained
 - when finished request to stop the updates through the stopMagnetoUpdates method
 */
public class SensorsMagnetoManager: NSObject {
    
    //MARK: - Properties
    
    /// The root object providing access to Core Motion functionality
    private let motionManager: CMMotionManager!
    
    /// The manager configuration, set up either at initialization or through the configure method
    private var configuration: SensorsMagnetoConfig!
    
    /// The manager delegate, used to pass back magnetormeter data updates as they are gathered based on the update interval
    public var delegate: SensorsMagnetoDelegate?
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core motion manager and its configuration
     */
    public override init() {
        self.motionManager = CMMotionManager()
        self.configuration = SensorsMagnetoConfig()
        
        super.init()
        
        self.configure(self.configuration)
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back magnetometer monitoring updates
     */
    public convenience init(delegate: SensorsMagnetoDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Provide the manager with a specific SensorsMagnetoConfig object
     The configuration values are used for the core motion manager
     
     - Parameters:
        - configuration: The manager configuration values
     */
    public func configure(_ configuration: SensorsMagnetoConfig) {
        self.configuration = configuration
    }
    
    /**
     Entry point for monitoring magnetometer updates based on the default or custom configuration
     
     Before starting magnetometer data gathering the availability of core motion functionality is checked.
     If cannot proceed with monitoring the magnetometer sensor, the manager delegate will be informed of the failing error
     
     If magnetometer data can be retrieved the magnetoUpdated method of the delegate is called each time a new data is obtained
     The magnetometer data updates are provided using either a background queue or the main queue as configured
     */
    public func startMagnetoUpdates() {
        let (canUse, error) = SensorsUtils.canMonitorMagneto(self.motionManager)
        if (canUse) {
            let operationQueue = (self.configuration.runInBackground ?? true) ? OperationQueue() : OperationQueue.main
            self.motionManager.magnetometerUpdateInterval = self.configuration.updateInterval ?? 0
            self.motionManager.startMagnetometerUpdates(to: operationQueue) { ( magnetoData, error) in
                guard error == nil else {
                    self.delegate?.magnetoFailed(error!)
                    return
                }
                
                guard let magnetoData = magnetoData else {
                    return
                }
                
                self.delegate?.magnetoUpdated(SYRFSensorsMagnetoData(magnetoData: magnetoData))
            }
        } else if let error = error {
            self.delegate?.magnetoFailed(error)
        }
    }
    
    /**
     Entry point for stopping magnetometer data updates
     
     Before stopping magnetometer updates the availability of core motion functionality is checked.
     If cannot proceed with stopping the magnetometer updates the manager delegate will be informed of the failing error
     */
    public func stopMagnetoUpdates() {
        if (self.motionManager.isMagnetometerActive) {
            self.motionManager.stopMagnetometerUpdates()
        } else {
            self.delegate?.magnetoFailed(SYRFSensorsMagnetoError.notUpdating)
        }
    }
    
    //MARK: - Private Methods
    
}
