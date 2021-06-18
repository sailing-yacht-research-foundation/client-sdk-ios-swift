//
//  CallbackData.swift
//  SYRFGeospatial
//
//  Created by SYRF on 5/28/21.
//

import Foundation

/**
 Geospecial Engine One protocol
 GeosEngineOneManager class delegate
*/
public protocol GeosEngineOneDelegate {
    
    /**
     Delegate method for geospacial errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during GeosEngineOneManager lifecycle
        Erros can be internal errors, incorrect usage or JS errors
     */
    func engineFailed(_ error: Error)
}

/**
 Geospecial Engine Two protocol
 GeosEngineTwoManager class delegate
*/
public protocol GeosEngineTwoDelegate {
    
    /**
     Delegate method for geospacial errors
     
     - Parameters:
        - error:  The error object.
     - Note:
        Called when an error occurs during GeosEngineTwoManager lifecycle
        Erros can be internal errors or incorrect usage
     */
    func engineFailed(_ error: Error)
}
