//
//  StatsViewController.swift
//  captchup
//
//  Created by Celia Casagrande on 09/07/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var solvedLevelsLabel: UILabel!
    @IBOutlet weak var goodAnswersLabel: UILabel!
    @IBOutlet weak var sentAnswersLabel: UILabel!
    @IBOutlet weak var createdLevelsLabel: UILabel!
    
    var userStat: Stat?
    var globalStat: Stat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SegmentedControl_OnValueChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: displayUserStats()
        case 1: displayGlobalStats()
        default: break;
        }
    }
    
    func displayUserStats() {
        
    }
    
    func displayGlobalStats() {
        
    }

}
