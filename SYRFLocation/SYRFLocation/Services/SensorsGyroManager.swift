//
//  SensorsGyroManager.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/22/21.
//

import Foundation
import CoreMotion

/// SensorsGyroManager
public class SensorsGyroManager: NSObject {
    
    //MARK: - Properties
    
    private let motionManager: CMMotionManager!
    private var configuration: SensorsGyroConfig!
    
    public var delegate: SensorsGyroDelegate?
    
    //MARK: - Lifecycle
    
    public override init() {
        self.motionManager = CMMotionManager()
        self.configuration = SensorsGyroConfig()
        
        super.init()
        
        self.configure(self.configuration)
    }
    
    public convenience init(delegate: SensorsGyroDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    public func configure(_ configuration: SensorsGyroConfig) {
        self.configuration = configuration
    }
    
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
    
    public func stopGyroUpdates() {
        if (self.motionManager.isGyroActive) {
            self.motionManager.stopGyroUpdates()
        } else {
            self.delegate?.gyroFailed(SYRFSensorsGyroError.notUpdating)
        }
    }
    
    //MARK: - Private Methods
    
}
