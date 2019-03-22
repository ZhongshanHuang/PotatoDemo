//
//  PushOrPopAnimator.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/6.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class PushOrPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let type: UINavigationController.Operation
    
    init(type: UINavigationController.Operation) {
        self.type = type
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView  = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view,
            let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else {
            return
        }
        let containerView = transitionContext.containerView
    
        var transition = containerView.bounds.size.width
        
        if type == .pop {
            containerView.insertSubview(toView, belowSubview: fromView)
            transition = -transition
        } else if type == .push {
            containerView.addSubview(toView)
        }
        
        let toViewTransform = CGAffineTransform(translationX: transition, y: 0)
        let fromViewTransform = CGAffineTransform(translationX: -transition, y: 0)
        
        toView.transform = toViewTransform
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.transform = fromViewTransform
            toView.transform = .identity
            }, completion: { (finished) in
                fromView.transform = .identity
                toView.transform = .identity
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
