//
//  PresentOrDismissAnimator.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/8.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class PoPresentOrDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum AnimatorType {
        case present
        case dismiss
    }
    
    private let type: AnimatorType
    
    init(type: AnimatorType) {
        self.type = type
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
            let toView = transitionContext.viewController(forKey: .to)?.view else {
            return
        }
        let containerView = transitionContext.containerView
        
        let height = containerView.bounds.height
        
        if type == .present {
            containerView.addSubview(toView)
            toView.transform = CGAffineTransform(translationX: 0, y: height)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if self.type == .dismiss {
                fromView.transform = CGAffineTransform(translationX: 0, y: height)
            } else {
                toView.transform = CGAffineTransform.identity
            }
            }) { (finish) in
                fromView.transform = CGAffineTransform.identity
                toView.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
