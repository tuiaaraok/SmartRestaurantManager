//
//  MenuViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit

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
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeVC = MFMailComposeViewController()
//            mailComposeVC.mailComposeDelegate = self
//            mailComposeVC.setToRecipients(["surbekbabun@outlook.com"])
//            present(mailComposeVC, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(
//                title: "Mail Not Available",
//                message: "Please configure a Mail account in your settings.",
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        }
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
//        let privacyVC = PrivacyViewController()
//        self.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(privacyVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
//        let appID = "6738995312"
//        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                print("Unable to open App Store URL")
//            }
//        }
    }
}
