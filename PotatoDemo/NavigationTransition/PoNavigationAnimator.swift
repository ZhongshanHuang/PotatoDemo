//
//  PoNavigationAnimator.swift
//  PotatoDemo
//
//  Created by iOSer on 2019/9/16.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

class PoNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationController.Operation = .none
    unowned(unsafe) var navigationController: UINavigationController? {
        didSet {
            if navigationController?.tabBarController != nil {
                isTabbarExist = true
            } else {
                isTabbarExist = false
            }
        }
    }
    
    private lazy var screenshotArray: [UIImage] = []
    private var isTabbarExist: Bool = false
    
    var removeCount: Int = 0
    
    func removelastScreenshot() {
        screenshotArray.removeLast()
    }
    
    func removeAllScreenshot() {
        screenshotArray.removeAll()
    }
    
    func removeLastScreenshotWithCount(_ count: Int) {
        for _ in 0..<count {
            screenshotArray.removeLast()
        }
    }
    
    // MARK: - Helper
    func screenShot() -> UIImage? {
        // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
        guard let beyondVC = navigationController?.view?.window?.rootViewController else { return nil }
        // 背景图片 总的大小
        let size = beyondVC.view.frame.size
        // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        // 要裁剪的矩形范围
        let rect = UIScreen.main.bounds
        //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
        
        //判读是导航栏是否有上层的Tabbar  决定截图的对象
        if (isTabbarExist) {
            beyondVC.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        } else {
            navigationController?.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        }
        // 从上下文中,取出UIImage
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        
        // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
        UIGraphicsEndImageContext()
        
        // 返回截取好的图片
        return snapshot
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let screenImageView = UIImageView(frame: UIScreen.main.bounds)
        screenImageView.image = screenShot()
        
        //取出fromViewController,fromView和toViewController，toView
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let toView = transitionContext.view(forKey: .to)!
        
        let screenSize = UIScreen.main.bounds.size
        
        var fromViewEndFrame = transitionContext.finalFrame(for: fromViewController)
        fromViewEndFrame.origin.x = screenSize.width
        var fromViewStartFrame = fromViewEndFrame;
        let toViewEndFrame = transitionContext.finalFrame(for: toViewController)
        let toViewStartFrame = toViewEndFrame;
        
        
        
        let containerView = transitionContext.containerView
        
        if (operation == .push) {
            
            
            screenshotArray.append(screenImageView.image!)
            
            //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
            containerView.addSubview(toView)
            toView.frame = toViewStartFrame;
            
            let nextVC = UIView(frame: CGRect(x: screenSize.width, y: 0, width: screenSize.width, height: screenSize.height))
            
            //将截图添加到导航栏的View所属的window上
            navigationController?.view.window?.insertSubview(screenImageView, at: 0)
            
            nextVC.layer.shadowColor = UIColor.black.cgColor
            nextVC.layer.shadowOffset = CGSize(width: -0.8, height: 0)
            nextVC.layer.shadowOpacity = 0.6;
            
            self.navigationController?.view.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
            
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                //toView.frame = toViewEndFrame;
                self.navigationController?.view.transform = .identity
                screenImageView.center = CGPoint(x: -screenSize.width / 2, y: screenSize.height / 2)
                //nextVC.center = CGPointMake(ScreenWidth/2, ScreenHeight / 2);
            }) { (_) in
                nextVC.removeFromSuperview()
                screenImageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
        
        if (operation == .pop) {

            fromViewStartFrame.origin.x = 0
            containerView.addSubview(toView)
            
            let lastVcImgView = UIImageView(frame: CGRect(x: -screenSize.width, y: 0, width: screenSize.width, height: screenSize.height))
            //若removeCount大于0  则说明Pop了不止一个控制器
            if (removeCount > 0) {
                for i in 0..<removeCount {
                    if i == removeCount - 1 {
                        lastVcImgView.image = screenshotArray.last
                        removeCount = 0
                        break
                    } else {
                        screenshotArray.removeLast()
                    }
                }
            } else {
                lastVcImgView.image = screenshotArray.last
            }
            screenImageView.layer.shadowColor = UIColor.black.cgColor
            screenImageView.layer.shadowOffset = CGSize(width: -0.8, height: 0)
            screenImageView.layer.shadowOpacity = 0.6
            navigationController?.view?.window?.addSubview(lastVcImgView)
            navigationController?.view.addSubview(screenImageView)
            
            // fromView.frame = fromViewStartFrame;
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                screenImageView.center = CGPoint(x: screenSize.width * 3 / 2 , y: screenSize.height / 2)
                lastVcImgView.center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
            }) { (_) in
                lastVcImgView.removeFromSuperview()
                screenImageView.removeFromSuperview()
                self.screenshotArray.removeLast()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }

        }
    }
}
