//
//  PresentViewController.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/8.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    deinit {
        print("present deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        let presentButton = UIButton(type: .system)
        presentButton.setTitle("present", for: .normal)
        presentButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        presentButton.center = view.center
        presentButton.addTarget(self, action: #selector(PresentViewController.presentAction(_:)), for: .touchUpInside)
        view.addSubview(presentButton)
    }
    
    @objc func presentAction(_ sender: AnyObject) {
        let vc = DismissViewController()
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PresentViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PoPresentOrDismissAnimator(type: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PoPresentOrDismissAnimator(type: .dismiss)
    }
}
