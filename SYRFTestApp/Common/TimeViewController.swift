//
//  TimeViewController.swift
//  SYRFTestAppPods
//
//  Created by Radu Rad on 7/8/21.
//

import Foundation
import UIKit
import SYRFTime

private let maxMessages = 10

class TimeViewController: UIViewController {
    
    // MARK: - Store Properties
    @IBOutlet private weak var textViewDetails: UITextView!
    private lazy var timeManager = TimeManager()
    private var messages = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Time"
        
        let config = TimeConfig(ntpHost: "time.apple.com", samples: 4)
        self.timeManager.configure(config)
        self.timeManager.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func onStartPressed(_ sender: UIButton) {
        self.timeManager.startTimeUpdates()
    }
    
    @IBAction func onStopPressed(_ sender: UIButton) {
        self.timeManager.stopTimeUpdates()
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

extension TimeViewController: TimeDelegate {
    
    func timeUpdated(time: Date) {
        self.showMessage("Time: \(time)")
    }
}
