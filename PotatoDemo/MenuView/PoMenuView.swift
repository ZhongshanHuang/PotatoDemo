//
//  MenuControl.swift
//  Demo_HZS
//
//  Created by HzS on 16/5/11.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

protocol PoMenuViewDelegate: AnyObject {
    func menuView(_ view: PoMenuView, fromIndex: Int, toIndex: Int)
}

extension PoMenuViewDelegate {
    func menuView(_ view: PoMenuView, fromIndex: Int, toIndex: Int) {}
}

extension PoMenuView {
    enum Direction {
        case horizontal, vertical
    }
}

class PoMenuView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: - Public properties
    weak var poDelegate: PoMenuViewDelegate?
    private(set) var currentSelectedIndex: Int = 0
    private(set) var lastSelectedIndex: Int = 0
    var titles: Array<String> = [] {
        didSet {
            calculateItemRect()
            self.contentSize = calculateContentSize()
            addAllItems()
        }
    }
    var direction: Direction = .horizontal
    var textColor: UIColor = UIColor.black
    var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    var itemInsets: UIEdgeInsets = .zero
    var itemMargin: CGFloat = 10
    
    
    // MARK: - Private properties
    
    private var itemsRect: ContiguousArray<CGRect> = []
    private let scrollLine: UIImageView = UIImageView(image: UIImage(named: "classify_icon_switch"))
    
    
    init(frame: CGRect, direction: Direction, titles: [String]) {
        self.titles = titles
        self.direction = direction
        super.init(frame: frame)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //view在被移除的时候也会调用到这个方法，必须做一次判断
        guard newSuperview != nil else { return }
        calculateItemRect()
        contentSize = calculateContentSize()
        addAllItems()
        setSelectedItem(at: 0, animated: false)
    }
    
    func setSelectedItem(at index: Int, animated: Bool) {
        let itemRect = itemsRect[index]
        adjustScrollViewContentOffset(by: index)
        
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.scrollLine.frame.size.width = itemRect.width
            self.scrollLine.frame.origin = CGPoint(x: itemRect.origin.x, y: itemRect.maxY - 8)
        }
    }
    
    // MARK: - Helper
    
    private func calculateItemRect() {
        itemsRect = []
        let temp = titles as [NSString]
        var last: CGFloat = 0.0
        if direction == .horizontal {
            var x: CGFloat
            for (index, title) in temp.enumerated() {
                let titleRect = title.boundingRect(with: CGSize(width: CGFloat(Int.max), height: bounds.height), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: [.font: textFont], context: nil)
                if index == 0 {
                    x = itemInsets.left
                } else {
                    x = last + itemMargin
                }
                
                last = x + titleRect.width + 16
                itemsRect.append(CGRect(x: x, y: itemInsets.top, width: titleRect.width + 16, height: bounds.height - itemInsets.top - itemInsets.bottom))
            }
        } else {
            var y: CGFloat
            for (index, title) in temp.enumerated() {
                let titleRect = title.boundingRect(with: CGSize(width: bounds.height, height: CGFloat(Int.max)), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: [.font: textFont], context: nil)
                if index == 0 {
                    y = itemInsets.top
                } else {
                    y = last + itemMargin
                }
                last = y + titleRect.height + 16
                itemsRect.append(CGRect(x: itemInsets.left, y: y, width: bounds.width - itemInsets.left - itemInsets.right, height: titleRect.height + 16))
            }
        }
    }
    
    private func calculateContentSize() -> CGSize {
        if itemsRect.isEmpty {
            return CGSize.zero
        } else {
            if direction == .horizontal {
                return CGSize(width: (itemsRect.last)!.maxX + itemInsets.right, height: bounds.height)
            } else {
                return CGSize(width: bounds.width, height: (itemsRect.last)!.maxY + itemInsets.bottom)
            }
        }
    }
    
    private func addAllItems() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        for (index, rect) in itemsRect.enumerated() {
            let item = UIButton(frame: rect)
            item.setTitle(titles[index], for: .normal)
            item.setTitleColor(textColor, for: .normal)
            item.titleLabel?.font = textFont
            item.addTarget(self, action: #selector(PoMenuView.itemSelectClick(_:)), for: .touchUpInside)
            item.tag = index
            self.addSubview(item)
        }
        self.addSubview(scrollLine)
    }
    
    @objc private func itemSelectClick(_ sender: UIButton) {
        lastSelectedIndex = currentSelectedIndex
        currentSelectedIndex = sender.tag
        setSelectedItem(at: currentSelectedIndex, animated: true)
        poDelegate?.menuView(self, fromIndex: lastSelectedIndex, toIndex: currentSelectedIndex)
    }
    
    private func adjustScrollViewContentOffset(by selectedIndex: Int) {
        let itemRect = itemsRect[selectedIndex]
        switch direction {
        case .horizontal:
            if itemRect.midX < bounds.width / 2 {
                setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else if itemRect.midX >= bounds.width / 2 && itemRect.midX <= self.contentSize.width - bounds.width / 2 {
                setContentOffset(CGPoint(x: itemRect.midX - bounds.width / 2, y: 0), animated: true)
            } else {
                setContentOffset(CGPoint(x: self.contentSize.width - bounds.width, y: 0), animated: true)
            }
        case .vertical:
            if itemRect.midY < bounds.height / 2 {
                setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else if itemRect.midY >= bounds.height / 2 && itemRect.midY <= self.contentSize.height - bounds.height / 2 {
                setContentOffset(CGPoint(x: 0, y: itemRect.midY - bounds.height / 2), animated: true)
            } else {
                setContentOffset(CGPoint(x: 0, y: self.contentSize.height - bounds.height), animated: true)
            }
        }
        
    }
}
