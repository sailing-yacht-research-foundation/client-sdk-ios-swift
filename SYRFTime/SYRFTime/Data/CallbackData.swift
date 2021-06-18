//
//  CallbackData.swift
//  SYRFTime
//
//  Created by SYRF on 5/10/21.
//

import Foundation

/**
 Time updates protocol
 TimeManager class delegate
*/
public protocol TimeDelegate {
    
    /**
     Delegate method for time updates
     
     - Parameters:
        - time:  The current time obtained.
     - Note:
        Called each time the time updates
     */
    func timeUpdated(time: Date)
    
}
