//
//  LayerAnimation.swift
//  Demo_HZS
//
//  Created by HzS on 16/6/2.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class LayerAnimationViewController: UIViewController {
    var doorLayer: CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        containerView.backgroundColor = UIColor.white
        containerView.layer.sublayerTransform.m34 = -1/500
        view.addSubview(containerView)
        
        doorLayer = CALayer()
        doorLayer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        doorLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        doorLayer.position = CGPoint(x: 75, y: 300)
        doorLayer.contents = UIImage(named: "Door")?.cgImage
        containerView.layer.addSublayer(doorLayer)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(LayerAnimationViewController.pan(_:)))
        view.addGestureRecognizer(panGesture)
        
        doorLayer.speed = 0
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.toValue = -Double.pi/2
        animation.duration = 1.0
        doorLayer.add(animation, forKey: nil)
    }
    
    
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        var x = Double(gesture.translation(in: view).x)
        x /= 200
        var timeOffset = self.doorLayer.timeOffset
        timeOffset = min(0.999, max(0.0, timeOffset - x))
        self.doorLayer.timeOffset = timeOffset
        gesture.setTranslation(CGPoint.zero, in: view)
    }
    
}
