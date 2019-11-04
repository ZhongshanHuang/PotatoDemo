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
        
        
//        let view1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        view1.center = view.center
//        view1.backgroundColor = UIColor.red
////        view1.layer.shadowPath = CGPath(rect: CGRect(x: 0, y: 0, width: 200, height: 200), transform: nil)
////        view1.layer.shadowColor = UIColor.black.cgColor
////        view1.layer.shadowOffset = CGSize(width: -1, height: 0)
////        view1.layer.shadowOpacity = 0.6
//        view.addSubview(view1)
//        
//        
////        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
////            view1.center.y += 100
////        }
//        
//        let view2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        view2.backgroundColor = UIColor.yellow
//        view2.layer.shadowPath = CGPath(rect: CGRect(x: 0, y: 0, width: 200, height: 200), transform: nil)
//        view2.layer.shadowColor = UIColor.black.cgColor
//        view2.layer.shadowOffset = CGSize(width: -4, height: 0)
//        view2.layer.shadowOpacity = 1
//        view1.addSubview(view2)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            view2.transform = CGAffineTransform(translationX: 100, y: 0)
//        }
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
