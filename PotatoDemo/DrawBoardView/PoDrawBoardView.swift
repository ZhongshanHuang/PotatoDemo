//
//  HZSDrawBoard.swift
//  CALayerPractise
//
//  Created by HzS on 16/5/26.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class PoDrawBoardView: UIView {
    
    private let drawView: PoDrawView = PoDrawView()
    private var toolView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        toolView = tool()
        addSubview(toolView)
    
        addSubview(drawView)
        drawView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        toolView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        drawView.frame = CGRect(x: 0, y: toolView.bounds.maxY, width: bounds.width, height: bounds.height - toolView.bounds.height)
    }
    
    private func tool() -> UIView {
        let tool = UIView()
        tool.backgroundColor = UIColor.yellow
        
        let cleanBtn = UIButton(type: .system)
        cleanBtn.frame = CGRect(x: 20, y: 10, width: 60, height: 30)
        cleanBtn.setTitle("清空", for: .normal)
        cleanBtn.addTarget(self, action: #selector(clearBtnClick(_:)), for: .touchUpInside)
        tool.addSubview(cleanBtn)
        
        let backBtn = UIButton(type: .system)
        backBtn.frame = CGRect(x: cleanBtn.frame.maxX + 20, y: 10, width: 80, height: 30)
        backBtn.setTitle("上一步", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick(_:)), for: .touchUpInside)
        tool.addSubview(backBtn)
        
        let lineColorBtn = UIButton(type: .system)
        lineColorBtn.frame = CGRect(x: backBtn.frame.maxX + 20, y: 10, width: 80, height: 30)
        lineColorBtn.setTitle("随机画笔", for: .normal)
        lineColorBtn.addTarget(self, action: #selector(lineColorBtnClick(_:)), for: .touchUpInside)
        tool.addSubview(lineColorBtn)
        
        return tool
    }
    
    //MARK: touch method
    @objc private func lineColorBtnClick(_ sender: AnyObject) {
        drawView.lineColor = UIColor(red: CGFloat.random(in: 0..<255) / 255, green: CGFloat.random(in: 0..<255) / 255, blue: CGFloat.random(in: 0..<255) / 255, alpha: 1.0)
    }
    
    @objc private func clearBtnClick(_ sender: AnyObject) {
        drawView.cleanAllLines()
    }
    
    @objc private func backBtnClick(_ sender: AnyObject) {
        drawView.cancelLastLine()
    }
    
}
