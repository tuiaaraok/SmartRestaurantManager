//
//  InfoPresentationController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//
import UIKit

class InfoPresentationController: UIPresentationController {
    var dimmingView: UIView!

      override var frameOfPresentedViewInContainerView: CGRect {
          guard let containerView = containerView else { return .zero }
          return CGRect(x: 0, y: 0, width: 230, height: containerView.bounds.height)
      }
      
      override func presentationTransitionWillBegin() {
          guard let containerView = containerView, let presentedView = presentedView else { return }
          dimmingView = UIView(frame: containerView.bounds)
          dimmingView.alpha = 0.0
          containerView.addSubview(dimmingView)
          
          containerView.addSubview(presentedView)
          presentedView.frame = frameOfPresentedViewInContainerView.offsetBy(dx: -containerView.bounds.width, dy: 0)
          presentedView.alpha = 1.0
          
          if let coordinator = presentingViewController.transitionCoordinator {
              coordinator.animate(alongsideTransition: { _ in
                  self.dimmingView.alpha = 1.0
                  presentedView.frame = self.frameOfPresentedViewInContainerView
              }, completion: nil)
          } else {
              dimmingView.alpha = 1.0
              presentedView.frame = frameOfPresentedViewInContainerView
          }
      }
      
      override func dismissalTransitionWillBegin() {
          if let coordinator = presentingViewController.transitionCoordinator {
              coordinator.animate(alongsideTransition: { _ in
                  self.dimmingView.alpha = 0.0
                  self.presentedView?.frame = self.frameOfPresentedViewInContainerView.offsetBy(dx: -self.containerView!.bounds.width, dy: 0)
              }, completion: nil)
          } else {
              dimmingView.alpha = 0.0
              presentedView?.frame = frameOfPresentedViewInContainerView.offsetBy(dx: -containerView!.bounds.width, dy: 0)
          }
      }
      
      override func dismissalTransitionDidEnd(_ completed: Bool) {
          if completed {
              dimmingView.removeFromSuperview()
          }
      }
      
      override func presentationTransitionDidEnd(_ completed: Bool) {
          if !completed {
              dimmingView.removeFromSuperview()
          }
      }
    
}

class InfoTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return InfoPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
