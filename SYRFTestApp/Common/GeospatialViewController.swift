//
//  GeospatialViewController.swift
//  SYRFTestAppPods
//
//  Created by Radu Rad on 7/8/21.
//

import Foundation
import UIKit
import SYRFGeospatial

private let maxMessages = 20

class GeospatialViewController: UIViewController {
    
    // MARK: - Store Properties
    @IBOutlet private weak var textViewDetails: UITextView!
    private lazy var geospatialManager = GeosEngineOneManager()
    private var messages = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Geospatial"
        
        self.geospatialManager.delegate = self
        self.geospatialManager.initEngine()
    }
    
    // MARK: - Actions
    
    @IBAction func onRunCalculationsPressed(_ sender: UIButton) {
        let line1 = self.geospatialManager.getLine(points: [(1.1, 1.2), (3.4, 4.5)], options: nil)
        let point1 = self.geospatialManager.getPoint(latitude: 3.4, longitude: 4.5)
        let distance1 = self.geospatialManager.getDistance(pointFirst: (1.1, 1.2), pointSecond: (10.5, 11.4), options: nil)
        let mid1 = self.geospatialManager.getMidPoint(pointFirst: (1.1, 1.2), pointSecond: (10.5, 11.4))
        let simple1 = self.geospatialManager.getSimplify(json: ["test": 2], options: nil)
        let intersect1 = self.geospatialManager.getIntersect(lineFirst: [(1.1, 1.2), (2.2, 2.2)], lineSecond: [(3.3, 4.4), (5.5, 6.6)])
        let distance2 = self.geospatialManager.getPointToLineDistance(point: (1.1, 2.2), line: [(3.3, 4.4), (5.5, 6.6)])
        let dis3 = self.geospatialManager.getGreatCircle(pointFirst: (1.1, 2.2), pointSecond: (3.3, 4.4), options: nil)
        
        self.showMessage("Line: \(String(describing: line1))")
        self.showMessage("Point: \(String(describing: point1))")
        self.showMessage("Distance: \(String(describing: distance1))")
        self.showMessage("Middle Point: \(String(describing: mid1))")
        self.showMessage("Simplify: \(String(describing: simple1))")
        self.showMessage("Intersection: \(String(describing: intersect1))")
        self.showMessage("Point To Line Distance: \(String(describing: distance2))")
        self.showMessage("Great Circle: \(String(describing: dis3))")
    }
    
    // MARK: - Private Methods
    
    private func addMessage(_ message: String) {
        if self.messages.count == maxMessages {
            self.messages.removeFirst()
        }
        self.messages.append(message)
    }
    
    private func updateDescription() {
        DispatchQueue.main.async {
            var description = String()
            for i in 0..<self.messages.count {
                description.append("\n\r")
                description.append(self.messages[i])
            }
            self.textViewDetails.text = description
        }
    }
    
    private func showMessage(_ message: String) {
        self.addMessage(message)
        self.updateDescription()
    }
    
}

extension GeospatialViewController: GeosEngineOneDelegate {
    
    func engineFailed(_ error: Error) {
        self.showMessage("Error: \(error.localizedDescription)")
    }
}
