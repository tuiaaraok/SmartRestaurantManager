//
//  ViewController.swift
//  Party
//
//  Created by Karen Khachatryan on 15.10.24.
//

import UIKit

extension UIViewController {
    
    func setNavigationTitle(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = .semibold(size: 22)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
    func setNavigationBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(.backIcon, for: .normal)
        backButton.addTarget(self, action: #selector(clickedBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setNavigationMenuButton() {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(.menuIcon, for: .normal)
        menuButton.addTarget(self, action: #selector(clickedMenu), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    @objc func clickedBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func clickedMenu() {
        let transitingDelegate = InfoTransitioningDelegate()
        let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = transitingDelegate
        var tab = 1
        switch self {
        case is RestaurantMenuViewController:
            tab = 0
        case is ProductFormViewController:
            tab = 1
        case is EmployeesViewController:
            tab = 2
        case is EventsViewController:
            tab = 3
        default:
            tab = 1
        }
        menuViewController.selectedTab = tab
        menuViewController.completion = { [weak self] index in
            guard let self = self else { return }
            switch index {
            case 0:
                if !(self is RestaurantMenuViewController) {
                    self.navigationController?.viewControllers = [RestaurantMenuViewController(nibName: "RestaurantMenuViewController", bundle: nil)]
                }
            case 1:
                self.pushViewController(ProductFormViewController.self)
            case 2:
                if !(self is EmployeesViewController) {
                    self.navigationController?.viewControllers = [EmployeesViewController(nibName: "EmployeesViewController", bundle: nil)]
                }
            case 3:
                if !(self is EventsViewController) {
                    self.navigationController?.viewControllers = [EventsViewController(nibName: "EventsViewController", bundle: nil)]
                }
            default:
                break
            }
        }
        present(menuViewController, animated: false)
    }
    
    func pushViewController<T: UIViewController>(_ viewControllerType: T.Type, animated: Bool = true) {
        let nibName = String(describing: viewControllerType)
        let viewController = T(nibName: nibName, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view // Your source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alertController, animated: true, completion: nil)
    }
}

