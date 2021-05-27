//
//  SensorsAccleroManager.swift
//  SYRFLocation
//
//  Created by Radu Rad on 4/22/21.
//

import Foundation
import CoreMotion

/// SensorsAcceleroManager
public class SensorsAcceleroManager: NSObject {
    
    //MARK: - Properties
    
    private let motionManager: CMMotionManager!
    private var configuration: SensorsAcceleroConfig!
    
    public var delegate: SensorsAcceleroDelegate?
    
    //MARK: - Lifecycle
    
    public override init() {
        self.motionManager = CMMotionManager()
        self.configuration = SensorsAcceleroConfig()
        
        super.init()
        
        self.configure(self.configuration)
    }
    
    public convenience init(delegate: SensorsAcceleroDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    public func configure(_ configuration: SensorsAcceleroConfig) {
        self.configuration = configuration
    }
    
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
    
    public func stopAcceleroUpdates() {
        if (self.motionManager.isMagnetometerActive) {
            self.motionManager.stopMagnetometerUpdates()
        } else {
            self.delegate?.acceleroFailed(SYRFSensorsAcceleroError.notUpdating)
        }
    }
    
    //MARK: - Private Methods
    
}
