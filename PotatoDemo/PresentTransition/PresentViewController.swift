//
//  PresentViewController.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/8.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {
    
    let transitionDelegate = ModalTransitionDelegate()
    
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
        presentButton.addTarget(self, action: #selector(PresentViewController.presentAction), for: .touchUpInside)
        view.addSubview(presentButton)
        presentAction()
    }
    
//    func prepareInteractivePresentation() {
//        let modalTransitionDelegate = ModalTransitionDelegate()
//        let controller = PresentationViewController()
//        let presentationController = P(presentedViewController: controller, presenting: self)
//        modalTransitionDelegate.set(presentationController: presentationController)
//        
//        let presentAnimator = PresentationControllerAnimator(finalFrame: presentationController.frameOfPresentedViewInContainerView)
//        presentAnimator.auxAnimation = { controller.animations(presenting: $0) }
//        modalTransitionDelegate.set(animator: presentAnimator, for: .present)
//        modalTransitionDelegate.set(animator: presentAnimator, for: .dismiss)
//        
//        modalTransitionDelegate.wire(
//            viewController: self,
//            with: .regular(.fromBottom),
//            navigationAction: { self.present(controller, animated: true, completion: nil) }
//        )
//        
//        presentAnimator.onDismissed = prepareInteractivePresentation
//        presentAnimator.onPresented = {
//            modalTransitionDelegate.wire(
//                viewController: controller,
//                with: .regular(.fromTop),
//                navigationAction: {
//                    controller.dismiss(animated: true, completion: nil)
//            })
//        }
//        controller.transitioningDelegate = modalTransitionDelegate
//        controller.modalPresentationStyle = .custom
//    }
    
    @objc func presentAction() {
        let vc = DismissViewController()
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        
        let presentConfig = NormalModalTransitionAnimationConfig()
        presentConfig.onCompletion = { [unowned self] _ in
            transitionDelegate.addPanGesture(to: vc.view, with: .regular(.fromTop)) {
                vc.dismiss(animated: true)
            }
        }
        transitionDelegate.set(animatorConfig: presentConfig, for: .present)
        
        let dismissConfig = NormalModalTransitionAnimationConfig()
        dismissConfig.onCompletion = { [unowned self] _ in
            transitionDelegate.addPanGesture(to: view, with: .regular(.fromBottom)) {
                self.present(vc, animated: true, completion: nil)
            }
        }
        transitionDelegate.set(animatorConfig: dismissConfig, for: .dismiss)
        transitionDelegate.addPanGesture(to: view, with: .regular(.fromBottom)) { [unowned self] in
            self.present(vc, animated: true, completion: nil)
        }
        
        transitionDelegate.presentationController = ModalPresentationController(presentedViewController: vc, presenting: self)
//        present(vc, animated: true, completion: nil)
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
