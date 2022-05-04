//
//  DeviceManager.swift
//  SYRFDeviceInfo
//
//  Created by James on 23/04/2022.
//

import Foundation
import UIKit

public class DeviceInfoManager: NSObject {

    public func getPhoneModel() -> String {
        return UIDevice.modelName
    }
    
    public func getOsVersion() -> String {
        return UIDevice.current.systemVersion
    }
}
