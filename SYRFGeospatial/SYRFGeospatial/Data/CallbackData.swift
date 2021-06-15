//
//  CallbackData.swift
//  SYRFGeospatial
//
//  Created by Radu Rad on 5/28/21.
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
