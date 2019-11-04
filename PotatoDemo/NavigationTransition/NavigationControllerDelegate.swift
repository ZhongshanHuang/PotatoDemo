//
//  NavigationDelegate.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/6.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    // MARK: - Property
    private var interactiveTransition: UIPercentDrivenInteractiveTransition?
    unowned let navigationController: UINavigationController
    let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        navigationController.view.addGestureRecognizer(panGesture)
    }
    
    // GestureMethod
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let view = navigationController.view
        let translation = gesture.translation(in: view).x
        let width = view?.bounds.size.width
        let percent = max(translation / width!, 0.0)
        switch gesture.state {
        case .began:
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            navigationController.popViewController(animated: true)
        case .changed:
            interactiveTransition?.update(percent)
        case .cancelled, .ended:
            if percent > 0.3 && gesture.velocity(in: view).x > 0 {
                interactiveTransition?.finish()
            } else {
                interactiveTransition?.cancel()
            }
            interactiveTransition = nil
        default:
            interactiveTransition = nil
        }
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushOrPopAnimator(type: operation)
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if navigationController.viewControllers.count > 1 {
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


