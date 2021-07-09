//
//  DeviceManager.swift
//  SYRFLocation
//
//  Created by SYRF on 7/7/21.
//

import Foundation
import UIKit

// KeyChain service name
private let keyChainService = "com.syrflocation.core"
// KeyChain/UserDefault key name
private let keyUDID = "device.UDID"

/**
 Manager class responsible for providing device information
 
 Used mainly for the unique device id
 
 The manager uses in turn persitent storage to save device information (KeyChain and UserDefaults)
 */
public class DeviceManager: NSObject {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     Default initialization of the core location manager and its configuration
     */
    public override init() {
        super.init()
    }
    
    //MARK: - Public Methods
    
    /**
     Entry point for obtaining an unique ID for the device
     If will first try to retrieve the UDID from storage
     If it fails will retrieve the UDID using vendorIdentifier
     If it fails still will generate a random UDID
     
     - Returns:
        A unique value assosicated with the device
        The unique value should not change when reinstalling the application on the device
     */
    public func getDeviceUniqueID() -> String {
        if let storageUDID = self.retrieve(key: keyUDID) {
            return storageUDID
        } else if let vendorUDID = self.retrieveDeviceUniqueID() {
            return vendorUDID
        } else {
            return self.generateDeviceUniqueID()
        }
    }
    
    /**
     Entry point for stoping the heading information updates monitoring
     
     Before stopping heading updates the current permissions access and availability of core location functionality is checked.
     If cannot proceed with stopping heading updates monitoring the manager delegate will be informed of the failing error
     */
    public func stopHeadingUpdates() {
        
    }
 
    //MARK: - Private Methods
    /**
     Fallback method for retrieving a device unique ID
     When all other methods fail, generate a random unique ID
     */
    private func generateDeviceUniqueID() -> String {
        return UUID().uuidString
    }
    
    private func retrieveDeviceUniqueID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}

/**
 Storage extension providing save/retrive functionality for keychaina and userdefaults
 */
extension DeviceManager {
    
    /**
     Entry point for saving a key, value pair to persistent storage
     Saving is done first on KeyChain, if unable will default to UserDefaults
     
     - Parameters:
        - key: The string under which to save the value in the storage
        - value: The string value to be saved
     */
    private func save(key: String, value: String) {
        if (!self.saveInKeyChain(key, value)) {
            self.saveInUserDefaults(key, value)
        }
    }
    
    /**
     Entry point for retrieving a value saved on the persistent storage based on it's saving key
     Retrieval is done first using KeyChain, if unable will default o UserDefaults
     
     - Parameters:
        - key: The string under which to look for the value in the storage
     */
    private func retrieve(key: String) -> String? {
        guard let item = self.retrieveFromUserDefaults(key) else {
            return self.retrieveFromUserDefaults(key)
        }
        
        return item
    }
    
    /**
     Saves a key, value pair to the Keychain
     Will first attempt to add a new value, if it fails will attempt to update an existing value in the Keychain
     
     - Parameters:
        - key: The string under which to save the value in the storage
        - value: The string value to be saved
     */
    private func saveInKeyChain(_ key: String, _ value: String) -> Bool {
        let query: [String: AnyObject] = [
            kSecAttrService as String: keyChainService as AnyObject,
            kSecAttrAccount as String: key as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            kSecValueData as String: value as AnyObject
        ]
        
        // SecItemAdd attempts to add the item identified by
        // the query to keychain
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
        // Any status other than errSecSuccess indicates the
        // save operation failed.
        if (status != errSecSuccess) {
            return updateInKeyChain(key, value)
        }
        return true
    }
    
    /**
     Updates a key, value pair to the Keychain
     
     - Parameters:
        - key: The string under which to save the value in the storage
        - value: The string value to be saved
     */
    private func updateInKeyChain(_ key: String, _ value: String) -> Bool {
        let query: [String: AnyObject] = [
            kSecAttrService as String: keyChainService as AnyObject,
            kSecAttrAccount as String: key as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        // attributes is passed to SecItemUpdate with
        // kSecValueData as the updated item value
        let attributes: [String: AnyObject] = [
            kSecValueData as String: value as AnyObject
        ]
        
        // SecItemUpdate attempts to update the item identified
        // by query, overriding the previous value
        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )
        
        // Any status other than errSecSuccess indicates the
        // update operation failed.
        return status == errSecSuccess
    }
    
    /**
     Saves a key, value pair to the UserDefaults
     
     - Parameters:
        - key: The string under which to save the value in the storage
        - value: The string value to be saved
     */
    private func saveInUserDefaults(_ key: String, _ value: String) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(value, forKey: key)
    }
    
    /**
     Retrieves a value based on its key from the Keychain
     
     - Parameters:
        - key: The string under which to look for the value in the storage
     */
    private func retriveFromKeyChain(_ key: String) -> String? {
        let query: [String: AnyObject] = [
            kSecAttrService as String: keyChainService as AnyObject,
            kSecAttrAccount as String: key as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            // kSecMatchLimitOne indicates keychain should read
            // only the most recent item matching this query
            kSecMatchLimit as String: kSecMatchLimitOne,
            
            // kSecReturnData is set to kCFBooleanTrue in order
            // to retrieve the data for the item
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        // SecItemCopyMatching will attempt to copy the item
        // identified by query to the reference itemCopy
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )
        
        // This implementation of KeychainInterface requires all
        // items to be saved and read as Data. Otherwise,
        // invalidItemFormat is thrown
        if status == errSecSuccess, let item = itemCopy as? Data {
            return String(data: item, encoding: .utf8)
        }
        
        return nil
    }
    
    /**
     Retrieves a value based on its key from the UserDefaults
     
     - Parameters:
        - key: The string under which to look for the value in the storage
     */
    private func retrieveFromUserDefaults(_ key: String) -> String? {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.value(forKey: key) as? String
    }
}
