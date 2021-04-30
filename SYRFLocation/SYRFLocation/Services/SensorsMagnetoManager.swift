//
//  SensorsMagnetoManager.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/22/21.
//

import Foundation
import CoreMotion

/// SensorsMagnetoManager
public class SensorsMagnetoManager: NSObject {
    
    //MARK: - Properties
    
    private let motionManager: CMMotionManager!
    private var configuration: SensorsMagnetoConfig!
    
    public var delegate: SensorsMagnetoDelegate?
    
    //MARK: - Lifecycle
    
    public override init() {
        self.motionManager = CMMotionManager()
        self.configuration = SensorsMagnetoConfig()
        
        super.init()
        
        self.configure(self.configuration)
    }
    
    public convenience init(delegate: SensorsMagnetoDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    public func configure(_ configuration: SensorsMagnetoConfig) {
        self.configuration = configuration
    }
    
    public func startMagnetoUpdates() {
        let (canUse, error) = SensorsUtils.canMonitorGyro(self.motionManager)
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
    
    public func stopMagnetoUpdates() {
        if (self.motionManager.isMagnetometerActive) {
            self.motionManager.stopMagnetometerUpdates()
        } else {
            self.delegate?.magnetoFailed(SYRFSensorsMagnetoError.notUpdating)
        }
    }
    
    //MARK: - Private Methods
    
}
