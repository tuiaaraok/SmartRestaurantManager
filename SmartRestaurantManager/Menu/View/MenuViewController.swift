//
//  MenuViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var tabButtons: [TabButton]!
    var completion: ((Int) -> ())?
    var selectedTab: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
