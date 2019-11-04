//
//  PoNavigationController.swift
//  PotatoDemo
//
//  Created by iOSer on 2019/9/16.
//  Copyright © 2019 黄山哥. All rights reserved.
//

//import UIKit
//
//// 默认的将要变透明的遮罩的初始透明度(全黑)
//private let kDefaultAlpha: CGFloat = 0.6
//// 当拖动的距离,占了屏幕的总宽度的3/4时, 就让imageview完全显示，遮盖完全消失
//private let kTargetTranslateScale: CGFloat = 0.75
//
//class PoNavigationController: UINavigationController {
//
//    // MARK: - Properties - [private]
//    private lazy var screenshotImageView: UIImageView = UIImageView(frame: UIScreen.main.bounds)
//    private lazy var coverView: UIView = {
//        let view = UIView(frame: UIScreen.main.bounds)
//        view.backgroundColor = .black
//        return view
//    }()
//    private lazy var panGesture: UIScreenEdgePanGestureRecognizer = {
//       let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureHandle(_:)))
//        gesture.edges = .left
//        gesture.delegate = self
//        return gesture
//    }()
//
//    private lazy var screenshotImages: [UIImage] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        navigationBar.tintColor = UIColor(red: 111 / 255.0, green: 113 / 255.0, blue: 121 / 255.0, alpha: 1)
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: -0.8, height: 0)
//        view.layer.shadowOpacity = 0.6
//
//        view.addGestureRecognizer(panGesture)
//        self.interactivePopGestureRecognizer?.isEnabled = false
//        self.delegate = self
//    }
//
//    // Override
//
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        if viewControllers.count > 0 {
//            screenshot()
//            viewController.hidesBottomBarWhenPushed = true
//        }
//        super.pushViewController(viewController, animated: animated)
//    }
//
//    override func popViewController(animated: Bool) -> UIViewController? {
//        if screenshotImages.count >= viewControllers.count - 1 {
//            screenshotImages.removeLast()
//        }
//        return super.popViewController(animated: animated)
//    }
//
//    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
//        for vc in viewControllers {
//            if viewController === vc {
//                break
//            }
//            screenshotImages.removeLast()
//        }
//        return super.popToViewController(viewController, animated: animated)
//    }
//
//    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
//        screenshotImages.removeAll()
//        return super.popToRootViewController(animated: animated)
//    }
//
//    // MARK: - Selector
//    @objc
//    private func panGestureHandle(_ gesture: UIScreenEdgePanGestureRecognizer) {
//        // 如果当前显示的控制器已经是根控制器了，不需要做任何切换动画,直接返回
//        if self.visibleViewController == viewControllers[0] { return }
//        switch gesture.state {
//        case .began:
//            dragBegan()
//        case .changed:
//            dragChanged(gesture)
//        default:
//            dragEnded()
//        }
//    }
//
//    private func dragBegan() {
//        screenshotImageView.image = screenshotImages.last
//        view.window?.insertSubview(screenshotImageView, at: 0)
//        view.window?.insertSubview(coverView, aboveSubview: screenshotImageView)
//    }
//
//    private func dragChanged(_ gesture: UIScreenEdgePanGestureRecognizer) {
//        let offsetX = gesture.translation(in: view).x
//
//        if offsetX > 0 {
//            view.transform = CGAffineTransform(translationX: offsetX, y: 0)
//        }
//
//        let width = view.frame.width
//        let currentTranslateScaleX = offsetX / width
//        if offsetX < width {
//            screenshotImageView.transform = CGAffineTransform(translationX: ((offsetX - width) * 0.6), y: 0)
//        }
//        let alpha = kDefaultAlpha - (currentTranslateScaleX / kTargetTranslateScale) * kDefaultAlpha
//        coverView.alpha = alpha
//    }
//
//    private func dragEnded() {
//        let translateX = view.transform.tx
//        let width = view.frame.width
//
//        if translateX < 40 {
//            UIView.animate(withDuration: 0.25, animations: {
//                self.view.transform = .identity
//                self.screenshotImageView.transform = CGAffineTransform(translationX: -width, y: 0)
//                self.coverView.alpha = kDefaultAlpha
//            }) { (_) in
//                self.screenshotImageView.removeFromSuperview()
//                self.coverView.removeFromSuperview()
//            }
//        } else {
//            UIView.animate(withDuration: 0.25, animations: {
//                self.view.transform = CGAffineTransform(translationX: width, y: 0)
//                self.screenshotImageView.transform = .identity
//                self.coverView.alpha = 0
//            }) { (_) in
//                self.view.transform = .identity
//                self.screenshotImageView.removeFromSuperview()
//                self.coverView.removeFromSuperview()
//
//                _ = self.popViewController(animated: false)
//            }
//        }
//    }
//
//    // MARK: - Helper
//
//    private func screenshot() {
//        let beyondVC: UIViewController! = view.window?.rootViewController
//        let size = beyondVC.view.frame.size
//
//        UIGraphicsBeginImageContextWithOptions(size, true, 0)
//        let rect = UIScreen.main.bounds
//        beyondVC.view.drawHierarchy(in: rect, afterScreenUpdates: false)
//        if let snapshot = UIGraphicsGetImageFromCurrentImageContext() {
//            screenshotImages.append(snapshot)
//        }
//        UIGraphicsEndImageContext()
//    }
//
//    private let animator: PoNavigationAnimator = PoNavigationAnimator()
//}
//
//// MARK: - UINavigationControllerDelegate
//
//extension PoNavigationController: UINavigationControllerDelegate {
//
////    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
////        animator.operation = operation
////        animator.navigationController = self
////        return animator
////    }
//
//}
//
//extension PoNavigationController: UIGestureRecognizerDelegate {
//
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if viewControllers.count > 1 {
//            return true;
//        }
//        return false;
//    }
//
//    // 允许同时响应多个手势
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//    // 避免响应边缘侧滑返回手势时，当前控制器中的ScrollView跟着滑动
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self)
//    }
//
//}
