//
//  HZSSliderController.swift
//  Demo_HZS
//
//  Created by HzS on 16/5/21.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

extension PoSideMenuController {
    enum Status {
        case cener
        case left
    }
}

class PoSideMenuController: UIViewController {
    // MARK: - Properties [public]
    
    private(set) var leftVC: UIViewController
    private(set) var centerVC: UIViewController
    private(set) var state: Status = .cener
    var animationDuration: TimeInterval = 0.25
    var backgroundIMG: UIImage? {
        didSet {
            backgroundImgView.image = backgroundIMG
        }
    }
    
    // MARK: - Properties [private]
    
    private lazy var backgroundImgView: UIImageView = UIImageView()
    private lazy var miniTriggerDistance: CGFloat = {
        return view.bounds.width * 0.1
    }()
    
    // MARK: - Initialization
    
    required init(center: UIViewController, left: UIViewController) {
        self.centerVC = center
        self.leftVC = left
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // backgroundIMG
        backgroundImgView.frame = view.bounds
        backgroundImgView.contentMode = .scaleAspectFill
        backgroundImgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundImgView)
        
        // childView
        addViewController(leftVC)
        leftVC.view.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        addViewController(centerVC)
        
        // panGesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PoSideMenuController.panHandler(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func showLeft(animated: Bool) -> Void {
        view.window?.endEditing(true)

        UIView.animate(withDuration: animated ? animationDuration : 0, delay: 0, options: [.curveEaseIn], animations: {
            self.leftVC.view.frame.origin.x = 0
            self.centerVC.view.frame.origin.x = self.view.frame.width
        }) { (_) in
            self.state = .left
        }
    }
    
    func showCenter(animated: Bool) -> Void {
        view.window?.endEditing(true)

        UIView.animate(withDuration: animated ? animationDuration : 0, delay: 0, options: [.curveEaseIn], animations: {
            self.leftVC.view.frame.origin.x = -self.view.frame.width
            self.centerVC.view.frame.origin.x = 0
        }) { (_) in
            self.state = .cener
        }
    }
    
    func setCenter(_ viewController: UIViewController, animated: Bool) -> Void {
        if centerVC === viewController { return }
        
        viewController.view.center = centerVC.view.center
        viewController.view.transform = centerVC.view.transform
        viewController.view.alpha = 0;
        addViewController(viewController)
        hideViewController(centerVC)
        centerVC = viewController
        UIView.animate(withDuration: animated ? animationDuration : 0, animations: {
            viewController.view.alpha = 1.0
        }, completion: nil)
    }
    
    @objc
    private func panHandler(_ gesture: UIPanGestureRecognizer) {
        let xTranslation = gesture.translation(in: view).x
        gesture.setTranslation(CGPoint.zero, in: view)
        
        switch gesture.state {
        case .began:
            view.window?.endEditing(true)
        case .changed:
            var x = centerVC.view.frame.origin.x + xTranslation
            if x < 0 {
                x = 0
            } else if x > view.bounds.width {
                x = view.bounds.width
            }
            centerVC.view.frame.origin.x = x
            leftVC.view.frame.origin.x = x - view.bounds.width
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: view)
            if centerVC.view.frame.origin.x > miniTriggerDistance && velocity.x > 0 {
                showLeft(animated: true)
            } else {
                showCenter(animated: true)
            }
        default:
            return
        }
    }
    
    /// viewController operate
    private func addViewController(_ viewController: UIViewController) {
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func hideViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PoSideMenuController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if centerVC is UINavigationController {
            let nav = centerVC as! UINavigationController
            if nav.viewControllers.count > 1 { return false }
        }
        
        let point = gestureRecognizer.location(in: gestureRecognizer.view)
        switch state {
        case .cener:
            if point.x <= miniTriggerDistance {
                return true
            }
        case .left:
            return true
        }
        return false
    }

}


// MARK: - po_sideMenuController
extension UIViewController {
    
    var po_sideMenuController: PoSideMenuController? {
        var iter = self.parent
        while iter != nil {
            if iter is PoSideMenuController {
                return iter as? PoSideMenuController
            } else {
                iter = iter?.parent
            }
        }
        return nil
    }
}
