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
        case cener, left, right
    }
}

class PoSideMenuController: UIViewController {
    
    // MARK: - Properties [public]
    
    private(set) var leftVC: UIViewController?
    private(set) var centerVC: UIViewController
    private(set) var rightVC: UIViewController?
    private(set) var state: Status = .cener
    var animationDuration: TimeInterval = 0.25
    var scaleEnable: Bool = false
    var scale: CGFloat = 0.85
    var sideMovable: Bool = false
    var recoverCenterClosure: (() -> Void)?
    var backgroundIMG: UIImage? {
        didSet {
            backgroundImgView.image = backgroundIMG
        }
    }
    
    
    // MARK: - Properties [private]
    
    private var snapshot: UIView! // 缩放centerVC的时候，如果centerVC包含了UIScrollView或者navigationItem，可能会出现视觉bug，故用截图代替
    private let backgroundImgView: UIImageView = UIImageView()
    private var touchAtLeft: Bool = false
    private var leftCenter: CGPoint = CGPoint.zero
    private var centerCenter: CGPoint = CGPoint.zero
    private var rightCenter: CGPoint = CGPoint.zero
    private var distanceFromLeft: CGFloat = 0
    private var centerButton: UIButton?
    private var enableEdge: CGFloat = 75
    private var screenW: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    private var miniTriggerDistance: CGFloat {
        return screenW*0.2
    }
    private var maxMoveDistance: CGFloat {
        return scaleEnable ? (screenW - 90) : (screenW - 70)
    }
    private var menuBegin: CGFloat {
        return sideMovable ? 60 : 0
    }
    
    // MARK: - Initialization
    
    init(center: UIViewController, left: UIViewController?, right: UIViewController?) {
        self.centerVC = center
        self.leftVC = left
        self.rightVC = right
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
        if let left = leftVC {
            self.addViewController(left)
            left.view.center = CGPoint(x: self.view.center.x - menuBegin, y: self.view.center.y)
        }
        if let right = rightVC {
            self.addViewController(right)
            right.view.center = CGPoint(x: self.view.center.x + menuBegin, y: self.view.center.y)
        }
        self.addViewController(centerVC)
        
        // panGesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PoSideMenuController.panHandler(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    func showLeft(animated: Bool) -> Void {
        guard let left = leftVC else { return }
        
        view.window?.endEditing(true)
        left.view.isHidden = false
        rightVC?.view.isHidden = true
        let center = view.center
        if snapshot == nil {
            snapshot = centerVC.view.snapshotView(afterScreenUpdates: false)
            view.addSubview(snapshot)
            centerVC.view.isHidden = true
        }
        UIView.animate(withDuration: animated ? animationDuration : 0, animations: {
            left.view.center = center
            self.snapshot.center = CGPoint(x: center.x + self.maxMoveDistance, y: center.y)
            if self.scaleEnable {
                self.snapshot.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            }
        }) { (finished) in
            self.state = .left
            self.rightVC?.view.center = CGPoint(x: center.x + self.menuBegin, y: center.y)
            self.addCenterButton()
            self.distanceFromLeft = self.maxMoveDistance
        }
    }
    
    func showRight(animated: Bool) -> Void {
        guard let right = rightVC else { return }
        
        view.window?.endEditing(true)
        leftVC?.view.isHidden = true
        right.view.isHidden = false
        let center = view.center
        if snapshot == nil {
            snapshot = centerVC.view.snapshotView(afterScreenUpdates: false)
            view.addSubview(snapshot)
            centerVC.view.isHidden = true
        }
        UIView.animate(withDuration: animated ? animationDuration : 0, animations: {
            right.view.center = center
            self.snapshot.center = CGPoint(x: center.x - self.maxMoveDistance, y: center.y)
            if self.scaleEnable {
                self.snapshot.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            }
        }) { (finished) in
            self.state = .right
            self.leftVC?.view.center = CGPoint(x: center.x - self.menuBegin, y: center.y)
            self.addCenterButton()
            self.distanceFromLeft = -self.maxMoveDistance
        }
    }
    
    func showCenter(animated: Bool) -> Void {
        view.window?.endEditing(true)
        let center = view.center
        UIView.animate(withDuration: animated ? animationDuration : 0, animations: {
            self.leftVC?.view.center = CGPoint(x: center.x - self.menuBegin, y: center.y)
            self.rightVC?.view.center = CGPoint(x: center.x + self.menuBegin, y: center.y)
            self.snapshot?.center = center
            self.snapshot?.transform = .identity
        }) { (finished) in
            self.centerButton?.removeFromSuperview()
            self.centerButton = nil
            self.snapshot?.removeFromSuperview()
            self.snapshot = nil
            
            self.state = .cener
            self.distanceFromLeft = 0
            self.centerVC.view.isHidden = false
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
        guard leftVC != nil || rightVC != nil else { return }
        
        let xTranslation = gesture.translation(in: view).x
        distanceFromLeft += xTranslation
        gesture.setTranslation(CGPoint.zero, in: view)
        
        switch gesture.state {
        case .began:
            let startXPoint = gesture.location(in: view).x
            if startXPoint <= enableEdge {
                touchAtLeft = true
            } else {
                touchAtLeft = false
            }
            view.window?.endEditing(true)

            if snapshot == nil {
                snapshot = centerVC.view.snapshotView(afterScreenUpdates: false)
                view.addSubview(snapshot)
                centerVC.view.isHidden = true
            }
        case .changed:
            if let left = leftVC {
                leftCenter = left.view.center
            }
            if let right = rightVC {
                rightCenter = right.view.center
            }
            centerCenter = snapshot.center
            
            switch state {
            case .cener:
                if touchAtLeft && leftVC != nil {
                    movingAroundLeft()
                } else if touchAtLeft == false && rightVC != nil {
                    movingAroundRight()
                }
            case .left:
                movingAroundLeft()
            case .right:
                movingAroundRight()
            }
            if let left = leftVC {
                left.view.center = leftCenter
            }
            if let right = rightVC {
                right.view.center = rightCenter
            }
            snapshot.center = centerCenter
            
            //中间视图的缩放
            if scaleEnable && ((rightVC != nil && touchAtLeft == false) || (leftVC != nil && touchAtLeft == true)) {
                let localScale = (1 - abs(distanceFromLeft)/maxMoveDistance) * (1 - scale) + scale
                snapshot.transform = CGAffineTransform(scaleX: localScale, y: localScale)
            }
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: view)
            switch state {
            case .cener:
                if distanceFromLeft > miniTriggerDistance && velocity.x > 0{
                    showLeft(animated: true)
                } else if distanceFromLeft < -miniTriggerDistance && velocity.x < 0 {
                    showRight(animated: true)
                } else {
                    showCenter(animated: true)
                }
            case .left:
                if distanceFromLeft < maxMoveDistance - miniTriggerDistance && velocity.x < 0 {
                    showCenter(animated: true)
                } else {
                    showLeft(animated: true)
                }
            case .right:
                if distanceFromLeft > -maxMoveDistance + miniTriggerDistance && velocity.x > 0 {
                    showCenter(animated: true)
                } else {
                    showRight(animated: true)
                }
            }
        default:
            return
        }
    }
    
    
    // MARK: Helper
    
    private func movingAroundLeft() {
        guard let left = leftVC else { return }
        
        left.view.isHidden = false
        rightVC?.view.isHidden = true
        if distanceFromLeft >= maxMoveDistance {
            leftCenter = view.center
            centerCenter.x = view.center.x + maxMoveDistance
            distanceFromLeft = maxMoveDistance
        } else if distanceFromLeft <= 0 {
            leftCenter.x = -menuBegin
            centerCenter = view.center
            distanceFromLeft = 0
        } else {
            leftCenter.x = view.center.x - menuBegin + abs(distanceFromLeft/maxMoveDistance) * menuBegin
            centerCenter.x = view.center.x + distanceFromLeft
        }
    }
    
    private func movingAroundRight() {
        guard let right = rightVC else { return }
        
        right.view.isHidden = false
        leftVC?.view.isHidden = true
        if distanceFromLeft <= -maxMoveDistance {
            rightCenter.x = view.center.x
            centerCenter.x = view.center.x - maxMoveDistance
            distanceFromLeft = -maxMoveDistance
        } else if distanceFromLeft >= 0 {
            rightCenter.x = view.center.x + menuBegin
            centerCenter = view.center
            distanceFromLeft = 0
        } else {
            rightCenter.x = view.center.x + menuBegin + abs(distanceFromLeft/maxMoveDistance) * -menuBegin
            centerCenter.x = view.center.x + distanceFromLeft
        }
    }
    
    private func addCenterButton() {
        if centerButton == nil {
            centerButton = UIButton(type: .system)
            centerButton?.backgroundColor = UIColor.clear
            centerButton?.addTarget(self, action: #selector(PoSideMenuController.centerButtonAction), for: .touchUpInside)
            view.addSubview(centerButton!)
        }
        centerButton?.frame = snapshot.frame
    }
    
    @objc
    private func centerButtonAction() {
        showCenter(animated: true)
        recoverCenterClosure?()
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
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if centerVC is UINavigationController {
            let nav = centerVC as! UINavigationController
            if nav.viewControllers.count > 1 { return false }
        }
        
        if gestureRecognizer is UIPanGestureRecognizer {
            let point = touch.location(in: gestureRecognizer.view)
            if state == .left {
                if point.x >= screenW - enableEdge {
                    return true
                } else {
                    return false
                }
            } else if state == .right {
                if point.x <= enableEdge {
                    return true
                } else {
                    return false
                }
            } else {
                if point.x >= enableEdge && point.x <= screenW - enableEdge {
                    return false
                } else {
                    return true
                }
            }
        }
        return true
    }

}


// MARK: - po_sideMenuController
extension UIViewController {
    
    var po_sideMenuController: PoSideMenuController? {
        var iter = self.parent
        while iter != nil {
            if iter is PoSideMenuController {
                return iter as? PoSideMenuController
            } else if iter?.parent != nil && iter?.parent != iter {
                iter = iter?.parent
            } else {
                iter = nil
            }
        }
        return nil
    }
}
