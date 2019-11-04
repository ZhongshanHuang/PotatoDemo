//
//  PoNavigationAnimator1.swift
//  PotatoDemo
//
//  Created by iOSer on 2019/9/17.
//  Copyright © 2019 黄山哥. All rights reserved.
//

//import UIKit
//
//class PoNavigationAnimator1: NSObject {
//    
//    // MARK: - Properties - [public]
//    
//    unowned(unsafe) var navigationController: PoNavigationController1!
//    var operation: UINavigationController.Operation = .none
//    
//    // MARK: - Properties - [private]
//    
//    private lazy var screenshotArray: [UIImage] = []
//    private lazy var fromImageView: UIImageView = {
//        let imageView = UIImageView(frame: UIScreen.main.bounds)
//        imageView.layer.shadowPath = CGPath(rect: UIScreen.main.bounds, transform: nil)
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowOffset = CGSize(width: -1, height: 0)
//        imageView.layer.shadowOpacity = 0.6
//        return imageView
//    }()
//    
//    // MARK: - Helper
//    func screenShot() -> UIImage? {
//        let rect = UIScreen.main.bounds
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
//        defer { UIGraphicsEndImageContext() }
//        // 要裁剪的矩形范围
//        //判读是导航栏是否有上层的Tabbar  决定截图的对象
//        if let tabBarController = navigationController.tabBarController {
//            tabBarController.view.drawHierarchy(in: rect, afterScreenUpdates: false)
//        } else {
//            navigationController.view.drawHierarchy(in: rect, afterScreenUpdates: false)
//        }
//        // 从上下文中,取出UIImage
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//    
//}
//
////MARK: - UIViewControllerAnimatedTransitioning
//
//extension PoNavigationAnimator1: UIViewControllerAnimatedTransitioning {
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return TimeInterval(UINavigationController.hideShowBarDuration)
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromVC = transitionContext.viewController(forKey: .from),
//            let toVC = transitionContext.viewController(forKey: .to) else { return }
//        let containerView = transitionContext.containerView
//        
//        fromVC.view.transform = .identity;
//        
//        containerView.addSubview(toVC.view)
//        
//        toVC.view.transform = CGAffineTransform(translationX: containerView.frame.width, y: 0)
//        
//        let options: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseIn
//        UIView.transition(with: containerView, duration: transitionDuration(using: transitionContext), options: options, animations: {
//            fromVC.view.transform = CGAffineTransform(translationX: -containerView.bounds.width * 112 / 375, y: 0)
//            toVC.view.transform = .identity
//        }) { (finished) in
//            fromVC.view.transform = .identity
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//        
//    }
//    
//    //        [UIView transitionWithView:containerView
//    //            duration:[self transitionDuration:transitionContext]
//    //            options:[transitionContext isInteractive] ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseIn
//    //            animations:^{
//    //            fromVC.view.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(containerView.bounds) * 112 / 375, 0);
//    //            wrapperView.transform = CGAffineTransformIdentity;
//    //            shadowView.alpha      = 1.f;
//    //            }
//    //            completion:^(BOOL finished) {
//    //            if (finished) {
//    //            fromVC.view.transform                         = CGAffineTransformIdentity;
//    //
//    //            void (*setDelegate)(id, SEL, id<UINavigationControllerDelegate>) = (void(*)(id, SEL, id<UINavigationControllerDelegate>))[UINavigationController instanceMethodForSelector:@selector(setDelegate:)];
//    //            if (setDelegate) {
//    //            setDelegate(fromVC.navigationController, @selector(setDelegate:), fromVC.navigationController.rt_originDelegate);
//    //            }
//    //
//    //            fromVC.navigationController.rt_originDelegate = nil;
//    //
//    //            [containerView addSubview:toVC.view];
//    //            [wrapperView removeFromSuperview];
//    //            }
//    //            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    //            }];
//    //    }
//    
//    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
//    //    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//    //        guard let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else { return }
//    //        let containerView = transitionContext.containerView
//    //        containerView.addSubview(toView)
//    //
//    //        let screenSize = UIScreen.main.bounds.size
//    //        fromImageView.image = screenShot()
//    //
//    //        switch operation {
//    //        case .push:
//    //            screenshotArray.append(fromImageView.image!)
//    //            containerView.insertSubview(fromImageView, belowSubview: toView)
//    //            toView.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
//    //            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn, animations: {
//    //                toView.transform = .identity
//    //                self.fromImageView.transform = CGAffineTransform(translationX: -screenSize.width / 3, y: 0)
//    //            }) { (_) in
//    //                self.fromImageView.removeFromSuperview()
//    //                self.fromImageView.transform = .identity
//    //                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//    //            }
//    //        case .pop:
//    //            let toImageView = UIImageView(frame: UIScreen.main.bounds)
//    //            toImageView.image = screenshotArray.last
//    //            if let tabbarController = navigationController.tabBarController {
//    //                tabbarController.view.addSubview(toImageView)
//    //                tabbarController.view.addSubview(fromImageView)
//    //            } else {
//    //                navigationController.view.addSubview(toImageView)
//    //                navigationController.view.addSubview(fromImageView)
//    //            }
//    //
//    //            toImageView.transform = CGAffineTransform(translationX: -screenSize.width / 3, y: 0)
//    //            let options: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseIn
//    //            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options, animations: {
//    //                self.fromImageView.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
//    //                toImageView.transform = .identity
//    //            }) { (_) in
//    //                toImageView.removeFromSuperview()
//    //                self.fromImageView.removeFromSuperview()
//    //                self.fromImageView.transform = .identity
//    //                let complete = !transitionContext.transitionWasCancelled
//    //                if complete {
//    //                    self.screenshotArray.removeLast()
//    //                }
//    //                transitionContext.completeTransition(complete)
//    //            }
//    //        default:
//    //            fatalError("PoNavigationAnimator can't support \(operation)")
//    //        }
//    //    }
//    
//}
//
//
////    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
////        let screenImageView = UIImageView(frame: UIScreen.main.bounds)
////        screenImageView.image = screenShot()
////
////        let fromViewController = transitionContext.viewController(forKey: .from)!
////        let toViewController = transitionContext.viewController(forKey: .to)!
////        let toView = transitionContext.view(forKey: .to)!
////
////        let screenSize = UIScreen.main.bounds.size
////
////        var fromViewEndFrame = transitionContext.finalFrame(for: fromViewController)
////        fromViewEndFrame.origin.x = screenSize.width
////        let toViewEndFrame = transitionContext.finalFrame(for: toViewController)
////
////        let containerView = transitionContext.containerView
////
////        switch operation {
////        case .push:
////            screenshotArray.append(screenImageView.image!)
////
////            //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
////            containerView.addSubview(toView)
////            toView.frame = toViewEndFrame
////
////            //将截图添加到导航栏的View所属的window上
////            navigationController?.view.window?.insertSubview(screenImageView, at: 0)
////
////            self.navigationController?.view.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
////
////            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
////                //toView.frame = toViewEndFrame;
////                self.navigationController?.view.transform = .identity
////                screenImageView.center = CGPoint(x: -screenSize.width / 2, y: screenSize.height / 2)
////            }) { (_) in
////                screenImageView.removeFromSuperview()
////                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////            }
////        case .pop:
////            fromViewEndFrame.origin.x = 0
////            containerView.addSubview(toView)
////
////            let lastVcImgView = UIImageView(frame: CGRect(x: -screenSize.width, y: 0, width: screenSize.width, height: screenSize.height))
////            lastVcImgView.image = screenshotArray.last
////            screenImageView.layer.shadowColor = UIColor.black.cgColor
////            screenImageView.layer.shadowOffset = CGSize(width: -0.8, height: 0)
////            screenImageView.layer.shadowOpacity = 0.6
////            navigationController?.view?.window?.addSubview(lastVcImgView)
////            navigationController?.view.addSubview(screenImageView)
////
////            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
////                screenImageView.center = CGPoint(x: screenSize.width * 3 / 2 , y: screenSize.height / 2)
////                lastVcImgView.center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
////            }) { (_) in
////                lastVcImgView.removeFromSuperview()
////                screenImageView.removeFromSuperview()
////                let complete = !transitionContext.transitionWasCancelled
////                if complete {
////                    self.screenshotArray.removeLast()
////                }
////                transitionContext.completeTransition(complete)
////            }
////        default:
////            fatalError("PoNavigationAnimator can't support \(operation)")
////        }
////    }
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
//            //将截图添加到导航栏的View所属的window上
//            navigationController?.view.window?.insertSubview(fromImageView, at: 0)
//            navigationController?.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
//
//            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//                self.navigationController?.view.transform = .identity
//                self.fromImageView.transform = CGAffineTransform(translationX: -screenWidth / 2, y: 0)
//            }) { (_) in
//                self.fromImageView.removeFromSuperview()
//                self.fromImageView.transform = .identity
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            }
//        case .pop:
//            toImageView.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
//            toImageView.image = screenshotArray.last
//            navigationController?.view?.window?.addSubview(toImageView)
//            navigationController?.view.addSubview(fromImageView)
//
//            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
//                self.fromImageView.transform = CGAffineTransform(translationX: screenWidth, y: 0)
//                self.toImageView.transform = .identity
//            }) { (_) in
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
