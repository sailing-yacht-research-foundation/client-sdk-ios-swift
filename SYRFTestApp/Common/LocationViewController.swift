//
//  LocationViewController.swift
//  SYRFTestAppPods
//
//  Created by Radu Rad on 7/8/21.
//

import Foundation
import UIKit
import SYRFLocation

private let maxMessages = 10

class LocationViewController: UIViewController {
    
    // MARK: - Store Properties
    @IBOutlet private weak var textViewDetails: UITextView!
    private lazy var locationManager = LocationManager()
    private lazy var permissionsManager = PermissionsManager()
    private var messages = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location"
        
        let config = LocationManagerConfig()
        config.activityType = .otherNavigation
        config.allowIndicatorInBackground = true
        config.allowUpdatesInBackground = true
        config.desiredAccuracy = 0
        config.distanceFilter = 0
        config.pauseUpdatesAutomatically = false
        
        self.locationManager.configure(config)
        
        self.locationManager.delegate = self
        self.permissionsManager.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func onViewPermissionsPressed(_ sender: UIButton) {
        let permissions = String(describing: self.permissionsManager.checkAuthorization())
        self.showMessage(permissions)
    }
    
    @IBAction func onRequestAlwaysPressed(_ sender: UIButton) {
        self.permissionsManager.requestAuthorization(.always)
    }
    
    @IBAction func onRequestWhenPressed(_ sender: UIButton) {
        self.permissionsManager.requestAuthorization(.whenInUse)
    }
    
    @IBAction func onGetCurrentPressed(_ sender: UIButton) {
        self.locationManager.getCurrentLocation()
    }
    
    @IBAction func onStartPressed(_ sender: UIButton) {
        self.locationManager.startLocationUpdates()
    }
    
    @IBAction func onStopPressed(_ sender: UIButton) {
        self.locationManager.stopLocationUpdates()
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

extension LocationViewController: LocationDelegate {
    
    func currentLocationUpdated(_ location: SYRFLocation) {
        self.showMessage("Current Location: \(location.coordinate.latitude) \(location.coordinate.longitude)")
    }
    
    func locationFailed(_ error: Error) {
        self.showMessage("Error: \(error.localizedDescription)")
    }
    
    func locationUpdated(_ location: SYRFLocation) {
        self.showMessage("Location: \(location.coordinate.latitude) \(location.coordinate.longitude)")
    }
}

extension LocationViewController: PermissionsDelegate {
    
    func authorizationUpdated(_ status: PermissionsAuthorization) {
        let permissions = String(describing: status)
        self.showMessage("Authorization status: \(permissions)")
    }
    
    func accuracyUpdated(_ status: PermissionsAccuracy) {
        let permissions = String(describing: status)
        self.showMessage("Accuracy status: \(permissions)")
    }
}
