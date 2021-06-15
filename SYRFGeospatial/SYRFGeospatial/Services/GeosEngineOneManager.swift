//
//  GeosEngineOneManager.swift
//  SYRFGeospatial
//
//  Created by SYRF on 5/28/21.
//

import Foundation
import JavaScriptCore

/**
 Manager class responsible for providing geospacial calculations.
 
 Using Turf.JS geospacial library as the underlaying library for geospacial calculations
 
 Must call initEngine after creation
 
 Exposed methods are:
 - getPoint from coordinates
 - getDistance between two points
 - getLine from multiple coordinates
 - getIntersect between two lines
 - getPointToLineDistance minimal distance between a line an a point
 - getCircle calculates circle between two points
 - getMidPoint calculates midle points between two points
 - getSimplify simplify json object
 */
public class GeosEngineOneManager: NSObject {
    
    //MARK: - Properties
    
    /// The root object providing access to Javascript environment functionality
    private var jsContext: JSContext!
    
    /// The root object of Javascript methods
    private var jsGeometry: JSValue?
    
    /// The manager delegate, used to pass back geospacial information as they are obtained
    public var delegate: GeosEngineOneDelegate?
    
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
    public convenience init(delegate: GeosEngineOneDelegate) {
        self.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public Methods
    
    /**
     Creation method
     Loads up and initialized turf library
     */
    public func initEngine() {
        self.initJSCore()
    }
    
    /**
     Geospacial helper method for obtaining a point object from a coordinate
        
     - Parameters:
        - latitude: The latitude coordinate of the point
        - longitude: The longitude coordinate of the point
     */
    public func getPoint(latitude: Double, longitude: Double) -> [AnyHashable: Any]? {
        let pointDefined = [latitude, longitude]
        
        if let jsGeometry = self.jsGeometry {
            if let result = jsGeometry.objectForKeyedSubscript("point").call(withArguments: [pointDefined]) {
                return result.toDictionary()
            } else {
                return nil
            }
        } else {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
            return nil
        }
    }
    
    /**
     Geospacial helper method for obtaining a great line between two points
        
     - Parameters:
        - pointFirst: The coordinates of the first point
        - pointSecond: The coordinates of the second point
        - options: The great circle additional configuration
     */
    public func getGreatCircle(pointFirst: (Double, Double), pointSecond: (Double, Double), options: [String: Any]?) -> [AnyHashable: Any]? {
        let first = [pointFirst.0, pointFirst.1]
        let second = [pointSecond.0, pointSecond.1]
        
        if let jsGeometry = self.jsGeometry {
            if let result = jsGeometry.objectForKeyedSubscript("greatCircle").call(withArguments: [first, second, options ?? {}]) {
                return result.toDictionary()
            } else {
                return nil
            }
        } else {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
            return nil
        }
    }
    
    /**
     Geospacial helper method for obtaining a the middle geodesically point between two points
        
     - Parameters:
        - pointFirst: The coordinates of the first point
        - pointSecond: The coordinates of the second point
     */
    public func getMidPoint(pointFirst: (Double, Double), pointSecond: (Double, Double)) -> [AnyHashable: Any]? {
        let first = [pointFirst.0, pointFirst.1]
        let second = [pointSecond.0, pointSecond.1]
        
        if let jsGeometry = self.jsGeometry {
            if let result = jsGeometry.objectForKeyedSubscript("midpoint").call(withArguments: [first, second]) {
                return result.toDictionary()
            } else {
                return nil
            }
        } else {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
            return nil
        }
    }
    
    /**
     Geospacial helper method for obtaining a line constructed from an array of points
        
     - Parameters:
        - points: The array of points
        - options: The additional options for generating the line
     */
    public func getLine(points: [(Double, Double)], options: [String: Any]?) -> [AnyHashable: Any]? {
        var pointsDefined = [Any]()
        
        for point in points {
            let pointDefined = [point.0, point.1]
            pointsDefined.append(pointDefined)
        }
        
        
        if let jsGeometry = self.jsGeometry {
            if let result = jsGeometry.objectForKeyedSubscript("lineString").call(withArguments: [pointsDefined, options ?? {}]) {
                return result.toDictionary()
            } else {
                return nil
            }
        } else {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
            return nil
        }
    }
    
    /**
     Geospacial helper method for obtaining the distance between two points
        
     - Parameters:
        - pointFirst: The coordinates of the first point
        - pointSecond: The coordinates of the second point
        - options: The additional options for distance calculation
     */
    public func getDistance(pointFirst: (Double, Double), pointSecond: (Double, Double), options: [String: Any]?) -> Double? {
        let first = [pointFirst.0, pointFirst.1]
        let second = [pointSecond.0, pointSecond.1]
        
        if let jsGeometry = self.jsGeometry {
            if let result = jsGeometry.objectForKeyedSubscript("distance").call(withArguments: [first, second]) {
                return result.toDouble()
            } else {
                return nil
            }
        } else {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
            return nil
        }
    }
    
    /**
     Geospacial helper method for obtaining the intersecting points of two lines
        
     - Parameters:
        - lineFirst: The array of points of the first line
        - lineSecond: The array of points of the second line
     */
    public func getIntersect(lineFirst: [(Double, Double)], lineSecond: [(Double, Double)]) -> [AnyHashable: Any]? {
        var lineFirstDefined = [Any]()
        var lineSecondDefined = [Any]()
        
        for line in lineFirst {
            let lineDefined = [line.0, line.1]
            lineFirstDefined.append(lineDefined)
        }
        
        for line in lineSecond {
            let lineDefined = [line.0, line.1]
            lineSecondDefined.append(lineDefined)
        }
        
        if let jsGeometry = self.jsGeometry {
            if let result = jsGeometry.objectForKeyedSubscript("lineIntersect").call(withArguments: [lineFirstDefined, lineSecondDefined]) {
                return result.toDictionary()
            } else {
                return nil
            }
        } else {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
            return nil
        }
    }
    
    /**
     Geospacial helper method for obtaining the simplified json object
        
     - Parameters:
        - json: The dictionary of the json object to simplify
        - options: The additional options for the simplify operation
     */
    public func getSimplify(json: [AnyHashable: Any], options: [String: Any]?) -> [AnyHashable: Any]? {
        if let jsGeometry = self.jsGeometry {
            if let result = jsGeometry.objectForKeyedSubscript("simplify").call(withArguments: [json, options ?? {}]) {
                return result.toDictionary()
            } else {
                return nil
            }
        } else {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
            return nil
        }
    }
    
    /**
     Geospacial helper method for obtaining the minimal distance between a point and a line
        
     - Parameters:
        - point: The coordinates of the point of the first line
        - line: The array of points of the second line
     */
    public func getPointToLineDistance(point: (Double, Double), line: [(Double, Double)]) -> Double? {
        let pointDefined = [point.0, point.1]
        var lineDefined = [Any]()
        
        for line in line {
            lineDefined.append([line.0, line.1])
        }
        
        if let jsGeometry = self.jsGeometry {
            if let result = jsGeometry.objectForKeyedSubscript("pointToLineDistance").call(withArguments: [pointDefined, lineDefined]) {
                return result.toDouble()
            } else {
                return nil
            }
        } else {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    /**
     Initializer for JavaScript environment
     Loads turf from bundle
     Loads main object and exported methods into jsGeometry
     */
    private func initJSCore() {
        self.jsContext = JSContext()
        let bundle = Bundle(for: type(of: self))
        var isInitialized = false
        
        // load JS source file
        if let filePath = bundle.path(forResource: "Turf.bundle", ofType: "js") {
            do {
                let script = try String(contentsOfFile: filePath, encoding: .utf8)
                jsContext.evaluateScript(script)
                if let jsModule = self.jsContext.objectForKeyedSubscript("Turf") {
                    if let jsGeometry = jsModule.objectForKeyedSubscript("Geometry") {
                        self.jsGeometry = jsGeometry
                        isInitialized = true
                    }
                }
            } catch {
                self.delegate?.engineFailed(error)
                return
            }
        }
        if (!isInitialized) {
            self.delegate?.engineFailed(SYRFGeospecialEngineOne.notInitialized)
        }
    }
    
}
