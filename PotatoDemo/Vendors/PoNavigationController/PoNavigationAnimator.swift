//
//  PoNavigationAnimator.swift
//  PotatoDemo
//
//  Created by iOSer on 2019/9/16.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

//class PoNavigationAnimator: NSObject {
//    
//    // MARK: - Properties - [public]
//    
//    unowned(unsafe) var navigationController: PoNavigationController!
//    var operation: UINavigationController.Operation = .none
//    
//    // MARK: - Properties - [private]
//    
//    private lazy var screenshotArray: [UIImage] = []
//    
//    private lazy var fromImageView: UIImageView = {
//        let imageView = UIImageView(frame: UIScreen.main.bounds)
//        imageView.layer.shadowPath = CGPath(rect: imageView.bounds, transform: nil)
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowOffset = CGSize(width: -0.8, height: 0)
//        imageView.layer.shadowOpacity = 0.6
//        return imageView
//    }()
//    
//    private lazy var toImageView: UIImageView = UIImageView(frame: UIScreen.main.bounds)
//    
//    private lazy var backCoverView: UIView = {
//       let view = UIView(frame: UIScreen.main.bounds)
//        view.backgroundColor = UIColor.black
//        view.alpha = 0
//        return view
//    }()
//    
//    var percentComplete: CGFloat = 0 {
//        didSet {
//            backCoverView.alpha = max(0.25 - 0.4 * percentComplete, 0)
//        }
//    }
//    
//    // MARK: - Helper
//    func screenShot() -> UIImage? {
//        let rect = UIScreen.main.bounds
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
//        defer { UIGraphicsEndImageContext() }
//        if let tabBarController = navigationController.tabBarController {
//            tabBarController.view.drawHierarchy(in: rect, afterScreenUpdates: false)
//        } else {
//            navigationController.view.drawHierarchy(in: rect, afterScreenUpdates: false)
//        }
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//    
//}
//
////MARK: - UIViewControllerAnimatedTransitioning
//
//extension PoNavigationAnimator: UIViewControllerAnimatedTransitioning {
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
////        return TimeInterval(UINavigationController.hideShowBarDuration)
//        return 0.4
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toView = transitionContext.view(forKey: .to) else { return }
//        let containerView = transitionContext.containerView
//        containerView.addSubview(toView)
//        
//        fromImageView.image = screenShot()
//        let screenWidth = UIScreen.main.bounds.width
//        switch operation {
//        case .push:
//            screenshotArray.append(fromImageView.image!)
//            
//            navigationController?.view.window?.insertSubview(fromImageView, at: 0)
//            navigationController?.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
//            
//            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
//                self.navigationController?.view.transform = .identity
//                self.fromImageView.transform = CGAffineTransform(translationX: -screenWidth / 3, y: 0)
//            }) { (_) in
//                self.fromImageView.removeFromSuperview()
//                self.fromImageView.transform = .identity
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            }
//        case .pop:
//            toImageView.image = screenshotArray.last
//            toImageView.addSubview(backCoverView)
//            navigationController?.view?.window?.addSubview(toImageView)
//            navigationController?.view?.window?.addSubview(fromImageView)
//            
//            toImageView.transform = CGAffineTransform(translationX: -screenWidth / 3, y: 0)
//            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
//                self.fromImageView.transform = CGAffineTransform(translationX: screenWidth, y: 0)
//                self.toImageView.transform = .identity
//            }) { (_) in
//                self.backCoverView.removeFromSuperview()
//                self.toImageView.removeFromSuperview()
//                self.fromImageView.removeFromSuperview()
//                self.fromImageView.transform = .identity
//                let complete = !transitionContext.transitionWasCancelled
//                if complete {
//                    self.screenshotArray.removeLast()
//                }
//                transitionContext.completeTransition(complete)
//            }
//        default:
//            fatalError("PoNavigationAnimator can't support \(operation)")
//        }
//    }
//
//    
//}


