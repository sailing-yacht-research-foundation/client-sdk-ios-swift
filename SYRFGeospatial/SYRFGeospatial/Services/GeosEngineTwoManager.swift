//
//  GeosEngineTwoManager.swift
//  SYRFGeospatial
//
//  Created by SYRF on 5/29/21.
//

import Foundation
import JavaScriptCore
import GEOSwift

/**
 Manager class responsible for providing geospacial calculations.
 
 Using GEOSwift geospacial library as the underlaying library for geospacial calculations
 
 Must call initEngine after creation
 
 Exposed methods are:
 - getDistance between two points
 
 */
public class GeosEngineTwoManager: NSObject {
    
    //MARK: - Properties
    
    /// The manager delegate, used to pass back geospacial information as they are obtained
    public var delegate: GeosEngineTwoDelegate?
    
    //MARK: - Lifecycle
    
    /**
     Default initializer
     */
    public override init() {
        super.init()
    }
    
    /**
     Initializer to set up the manager delegate
     Uses the default initializer
        
     - Parameters:
        - delegate: The manager delegate value, used for passing back geospacial information
     */
    public convenience init(delegate: GeosEngineTwoDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Creation method
     */
    public func initEngine() {
        
    }
    
    /**
     Geospacial helper method for obtaining the distance between two points
        
     - Parameters:
        - pointFirst: The coordinates of the first point
        - pointSecond: The coordinates of the second point
     */
    public func getDistance(pointFirst: (Double, Double), pointSecond: (Double, Double)) -> Double? {
        do {
            let first = Point(x: pointFirst.0, y: pointFirst.1)
            let second = Point(x: pointSecond.0, y: pointSecond.1)
            
            return try first.distance(to: second)
        }
        catch {
            self.delegate?.engineFailed(SYRFGeospecialEngineTwo.notAvailable)
            return nil
        }
    }
    
    // MARK: - Private Methods
    
}
