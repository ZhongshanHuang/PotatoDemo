//
//  NavigationController.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/6.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    lazy var navigationDelegate: NavigationControllerDelegate = NavigationControllerDelegate.init(navigationController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.delegate = navigationDelegate
    }
}
