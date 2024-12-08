//
//  ViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [RestaurantMenuViewController(nibName: "RestaurantMenuViewController", bundle: nil)]
    }


}

