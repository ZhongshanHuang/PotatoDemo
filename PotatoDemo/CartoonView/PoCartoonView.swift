//
//  HZSTableView.swift
//  Demo_HZS
//
//  Created by HzS on 16/6/13.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

protocol PoCartoonViewDataSource: NSObjectProtocol {
    func numberOfCellsInCartoonView(_ cartoonView: PoCartoonView) -> Int
    func cartoonView(_ cartoonView: PoCartoonView, cellForRowAtIndex index: Int) -> PoCartoonViewCell
}

@objc protocol PoCartoonViewDelegate: NSObjectProtocol {
    @objc optional func cartoonView(_ cartoonView: PoCartoonView, heightForCellAtIndex: Int) -> CGFloat
    @objc optional func cartoonView(_ cartoonView: PoCartoonView, clickWithGrsture: UITapGestureRecognizer)
}

extension PoCartoonView {
    
    struct LayoutAttributes {
        var frame: CGRect
        var index: Int
    }
}

class PoCartoonView: UIScrollView {
    
    // MARK: - Properties
    weak var poDataSource: PoCartoonViewDataSource!
    weak var poDelegate: PoCartoonViewDelegate?
    var maxZoomScale: CGFloat = 2 {
        willSet {
            maximumZoomScale = newValue
        }
    }
    var zoomEnable: Bool = true
    var rowHeight: CGFloat = 44
    
    private var reusableCells: Set<PoCartoonViewCell> = []
    private(set) var visibleCells: Dictionary<Int, PoCartoonViewCell> = [:]
    private var allItemAttributes: Array<LayoutAttributes> = []
    private let baseView: UIView = UIView()
    private var oldBounds: CGRect = CGRect.zero
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.white
        maximumZoomScale = maxZoomScale
        minimumZoomScale = 1.0
        bouncesZoom = false
        delegate = self
        //双击放大
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(PoCartoonView.doubleClicked(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        // add baseView
        addSubview(baseView)
    }
    
    // MARK: - public methods
    
    func reloadData() {
        prepareLayout()
        contentSize = cartoonViewContentSize()
        baseView.frame = CGRect(origin: .zero, size: contentSize)
        oldBounds = self.bounds
    }
    
    func dequeueReusableCellWithIdentifier(_ reusedIdentifier: String) -> PoCartoonViewCell? {
        for (_, cell) in reusableCells.enumerated() where cell.reusedIdentifier == reusedIdentifier {
            reusableCells.remove(cell)
            return cell
        }
        return nil
    }
    
    //将要显示的时候才进行布局
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil { return }
        reloadData()
    }
    
    // 手指滑动的时候都会调用这个方法
    override func layoutSubviews() {
        super.layoutSubviews()

        if shouldInvalidLayout(bounds) {
            reloadData()
        }

        let visibleRect = CGRect(x: contentOffset.x,
                                 y: contentOffset.y,
                                 width: bounds.width,
                                 height: bounds.height)
        if let layoutElements = layoutAttributesForElements(in: visibleRect) {
            for (index, cell) in visibleCells {
                if !layoutElements.contains(where: { $0.index == index }) {
                    cell.removeFromSuperview()
                    visibleCells.removeValue(forKey: index)
                    reusableCells.insert(cell)
                }
            }

            for attributes in layoutElements {
                if let _ = visibleCells[attributes.index] {

                } else {
                    let cell = poDataSource.cartoonView(self, cellForRowAtIndex: attributes.index)
                    cell.frame = attributes.frame
                    baseView.addSubview(cell)
                    visibleCells[attributes.index] = cell
                }
            }
        }
    }
    
    // MARK :helper methods
    private func prepareLayout() {
        //清空所有布局信息，重新计算
        baseView.subviews.forEach({ $0.removeFromSuperview() })
        visibleCells.removeAll()
        reusableCells.removeAll()
        allItemAttributes.removeAll()
        
        let itemCounts = self.poDataSource.numberOfCellsInCartoonView(self)
        if itemCounts < 1 { return }
        
        var top: CGFloat = 0
        //计算所有cell的frame
        for item in 0..<itemCounts {
            var height = rowHeight
            if let tempHeight = self.poDelegate?.cartoonView?(self, heightForCellAtIndex: item) {
                height = tempHeight
            }
            let frame = CGRect(x: 0, y: top, width: bounds.width, height: height)
            allItemAttributes.append(LayoutAttributes(frame: frame, index: item))
            top += height
        }
    }
    
    /// 是否应该重新布局
    func shouldInvalidLayout(_ newBounds: CGRect) -> Bool {
        if newBounds.width == oldBounds.width {
            return false
        }
        return true
    }
    
    /// 当前可见的布局属性有哪些
    func layoutAttributesForElements(in rect: CGRect) -> [LayoutAttributes]? {
        if let firstMatchIndex = _binarySearchForIntersectsAttributes(array: allItemAttributes, in: rect) {
            var result = [LayoutAttributes]()
            // 从后向前反向遍历
            for attributes in allItemAttributes[..<firstMatchIndex].reversed() {
                let zoomRect = CGRect(x: attributes.frame.origin.x * zoomScale,
                                  y: attributes.frame.origin.y * zoomScale,
                                  width: attributes.frame.size.width * zoomScale,
                                  height: attributes.frame.size.height * zoomScale)
                if zoomRect.maxY < rect.minY { break }
                result.append(attributes)
            }
            // 从前往后正向遍历
            for attributes in allItemAttributes[firstMatchIndex...] {
                let zoomRect = CGRect(x: attributes.frame.origin.x * zoomScale,
                                      y: attributes.frame.origin.y * zoomScale,
                                      width: attributes.frame.size.width * zoomScale,
                                      height: attributes.frame.size.height * zoomScale)
                if zoomRect.minY > rect.maxY { break }
                result.append(attributes)
            }
            return  result
        }
        return nil
    }
    
    /// contentSize
    func cartoonViewContentSize() -> CGSize {
        guard allItemAttributes.isEmpty == false else { return CGSize.zero }
        return CGSize(width: bounds.size.width, height: allItemAttributes.last!.frame.maxY)
    }
    
    private func _binarySearchForIntersectsAttributes(array: [LayoutAttributes], in rect: CGRect) -> Int? {
        var low = 0
        var hight = array.count - 1
        while low <= hight {
            let mid = low + (hight - low) / 2
            var zoomRect = array[mid].frame
            zoomRect = CGRect(x: zoomRect.origin.x * zoomScale,
                           y: zoomRect.origin.y * zoomScale,
                           width: zoomRect.size.width * zoomScale,
                           height: zoomRect.size.height * zoomScale)
            if rect.intersects(zoomRect) {
                return mid
            } else if zoomRect.maxY < rect.minY {
                low = mid + 1
            } else {
                hight = mid - 1
            }
        }
        return nil
    }
    
    // MARK :tap methods
    @objc
    private func doubleClicked(_ gesture: UITapGestureRecognizer) -> Void {
        guard self.zoomEnable else { return }
        gesture.isEnabled = false
        if self.zoomScale == 1 {
            self.setZoomScale(maxZoomScale, animated: true)
        } else {
            self.setZoomScale(1.0, animated: true)
        }
        gesture.isEnabled = true
    }
    
}

extension PoCartoonView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if zoomEnable {
            return baseView
        }
        return nil
    }
}
