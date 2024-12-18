//
//  MenuViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit
import MessageUI

class MenuViewController: UIViewController {

    @IBOutlet var tabButtons: [TabButton]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var settingsButtons: [TabButton]!
    var completion: ((Int) -> ())?
    var selectedTab: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = .medium(size: 18)
        tabButtons[selectedTab].isSelected = true
    }

    @IBAction func clickedRestaurantMenu(_ sender: TabButton) {
        self.completion?(0)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedAddDish(_ sender: TabButton) {
        self.completion?(1)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedSchedule(_ sender: TabButton) {
        self.completion?(2)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedEvents(_ sender: TabButton) {
        self.completion?(3)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            if let self = self {
                self.completion?(4)
            }
        }
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            if let self = self {
                self.completion?(5)
            }
        }
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            if let self = self {
                self.completion?(6)
            }
        }
    }
}
