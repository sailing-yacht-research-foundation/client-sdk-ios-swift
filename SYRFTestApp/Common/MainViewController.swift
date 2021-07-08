//
//  MainViewController.swift
//  SYRFTestAppPods
//
//  Created by Radu Rad on 7/8/21.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Store Properties
    private lazy var vcLocation = LocationViewController(nibName: "LocationViewController", bundle: nil)
    private lazy var vcTime = TimeViewController(nibName: "TimeViewController", bundle: nil)
    private lazy var vcGeospatial = GeospatialViewController(nibName: "GeospatialViewController", bundle: nil)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Test App"
    }
    
    // MARK: - Actions
    
    @IBAction func onLocationPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(vcLocation, animated: true)
    }
    
    @IBAction func onTimePressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(vcTime, animated: true)
    }
    
    @IBAction func onGeospatialPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(vcGeospatial, animated: true)
    }
}

