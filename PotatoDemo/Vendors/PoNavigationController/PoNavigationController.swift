//
//  PoNavigationController1.swift
//  PotatoDemo
//
//  Created by iOSer on 2019/9/17.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit


class PoNavigationController: UINavigationController {
    
    // MARK: - Property - [public]
    lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: - Property - [private]
    
    fileprivate var interactiveTransition: UIPercentDrivenInteractiveTransition?
    private let animator: PoNavigationAnimator = PoNavigationAnimator()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.delegate = self
        
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Override
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // GestureMethod
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).x
        let width = view?.bounds.size.width
        let percent = max(translation / width!, 0.0)
        switch gesture.state {
        case .began:
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        case .changed:
            interactiveTransition?.update(percent)
            animator.percentComplete = percent
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
}

// MARK: - UINavigationControllerDelegate

extension PoNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.operation = operation
        animator.navigationController = self
        return animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension PoNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count > 1 {
            let location = gestureRecognizer.location(in: view)
            if location.x < 80 {
                return true
            }
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        } else {
            return true
        }
    }
    
}



// MARK: - PoNavigationAnimator

class PoNavigationAnimator: NSObject {
    
    // MARK: - Properties - [public]
    
    unowned(unsafe) var navigationController: PoNavigationController!
    var operation: UINavigationController.Operation = .none
    
    // MARK: - Properties - [private]
    
    private lazy var screenshotArray: [UIImage] = []
    
    private lazy var fromImageView: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.layer.shadowPath = CGPath(rect: imageView.bounds, transform: nil)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: -0.8, height: 0)
        imageView.layer.shadowOpacity = 0.6
        return imageView
    }()
    
    private lazy var toImageView: UIImageView = UIImageView(frame: UIScreen.main.bounds)
    
    private lazy var backCoverView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
    }()
    
    fileprivate var percentComplete: CGFloat = 0 {
        didSet {
            backCoverView.alpha = max(0.25 - 0.4 * percentComplete, 0)
        }
    }
    
    // MARK: - Helper
    func screenShot() -> UIImage? {
        let rect = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let tabBarController = navigationController.tabBarController {
            tabBarController.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        } else {
            navigationController.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

//MARK: - UIViewControllerAnimatedTransitioning

extension PoNavigationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        //        return TimeInterval(UINavigationController.hideShowBarDuration)
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        fromImageView.image = screenShot()
        let screenWidth = UIScreen.main.bounds.width
        switch operation {
        case .push:
            screenshotArray.append(fromImageView.image!)
            
            navigationController?.view.window?.insertSubview(fromImageView, at: 0)
            navigationController?.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
            
            let options: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseIn
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options, animations: {
                self.navigationController?.view.transform = .identity
                self.fromImageView.transform = CGAffineTransform(translationX: -screenWidth / 3, y: 0)
            }) { (_) in
                self.fromImageView.removeFromSuperview()
                self.fromImageView.transform = .identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        case .pop:
            toImageView.image = screenshotArray.last
            toImageView.addSubview(backCoverView)
            navigationController?.view?.window?.addSubview(toImageView)
            navigationController?.view?.window?.addSubview(fromImageView)
            
            toImageView.transform = CGAffineTransform(translationX: -screenWidth / 3, y: 0)
            let options: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseIn
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options, animations: {
                self.fromImageView.transform = CGAffineTransform(translationX: screenWidth, y: 0)
                self.toImageView.transform = .identity
            }) { (_) in
                self.backCoverView.removeFromSuperview()
                self.toImageView.removeFromSuperview()
                self.fromImageView.removeFromSuperview()
                self.fromImageView.transform = .identity
                let complete = !transitionContext.transitionWasCancelled
                if complete {
                    self.screenshotArray.removeLast()
                }
                transitionContext.completeTransition(complete)
            }
        default:
            fatalError("PoNavigationAnimator can't support \(operation)")
        }
    }
    
}
