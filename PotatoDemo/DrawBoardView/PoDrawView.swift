//
//  HZSDrawView.swift
//  CALayerPractise
//
//  Created by HzS on 16/5/26.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class PoDrawView: UIView {
    
    // MARK: - Public properties
    
    var lineColor: UIColor = UIColor.black
    var lineWidth: CGFloat = 3
    
    // MARK: - Private properties
    
    private var shapeLayer: CAShapeLayer?
    private var path: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isOpaque = true
        self.backgroundColor = UIColor.white
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let eve = event?.allTouches, eve.count == 1 {
            path = UIBezierPath()
            path?.move(to: touches.first!.location(in: self))
            
            shapeLayer = CAShapeLayer()
            shapeLayer?.lineCap = .round
            shapeLayer?.lineJoin = .round
            shapeLayer?.lineWidth = lineWidth
            shapeLayer?.fillColor = UIColor.clear.cgColor
            shapeLayer?.strokeColor = lineColor.cgColor
            
            self.layer.addSublayer(shapeLayer!)
        }
//        self.next?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let eve = event?.allTouches, eve.count == 1 {
            path?.addLine(to: touches.first!.location(in: self))
            shapeLayer?.path = path?.cgPath
            print("\(touches.first!.location(in: self))")
        }
//        self.next?.touchesBegan(touches, with: event)
    }
    
    //MARK:_ Public method
    func cleanAllLines() -> Void {
        self.layer.sublayers?.forEach { (layer) in
            layer.removeFromSuperlayer()
        }
    }
    
    func cancelLastLine() -> Void {
        self.layer.sublayers?.last?.removeFromSuperlayer()
    }
    
}
