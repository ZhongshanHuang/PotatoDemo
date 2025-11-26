//
//  NavigationController.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/6.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    lazy var navigationDelegate: NavigationTransitionDelegate = NavigationTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.delegate = navigationDelegate
        
        navigationDelegate.addPanGesture(to: self, with: .regular(.fromLeft), delegate: self) { [weak self] in
            guard let self else { return }
            popViewController(animated: true)
        }
        navigationDelegate.set(animatorConfig: NormalNavigationTransitionAnimationConfig(), for: .push)
        navigationDelegate.set(animatorConfig: NormalNavigationTransitionAnimationConfig(), for: .pop)
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count > 1 {
            return true
        }
        return false
    }
}
