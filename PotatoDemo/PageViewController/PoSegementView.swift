//
//  MenuControl.swift
//  Demo_HZS
//
//  Created by HzS on 16/5/11.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

// MARK: - PoSegementViewDelegate
protocol PoSegementViewDelegate: class {
    func segementView(_ segementView: PoSegementView, fromIndex: Int, toIndex: Int)
}

extension PoSegementViewDelegate {
    func segementView(_ segementView: PoSegementView, fromIndex: Int, toIndex: Int) {}
}

extension PoSegementView {
    enum Direction {
        case horizontal, vertical
    }
}

// MARK: - PoSegementView
class PoSegementView: UIView, UIScrollViewDelegate {
    
    // MARK: - Properties - [public]
    weak var poDelegate: PoSegementViewDelegate?
    private(set) var selectedIndex: Int = 0
    var titles: Array<String>! {
        didSet {
            if titles == nil { titles = [] }
            selectedIndex = 0
            setNeedsLayout()
        }
    }
    var direction: Direction = .horizontal
    var textColor: UIColor = UIColor.black
    var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    var selectedTextColor: UIColor = UIColor.red
    var selectedTextFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    var itemInsets: UIEdgeInsets = .zero
    var itemMargin: CGFloat = 10
    
    
    // MARK: - Properties - [private]
    private lazy var contentView: UIScrollView = UIScrollView()
    private lazy var itemsRect: ContiguousArray<CGRect> = []
    
    init(frame: CGRect = .zero, direction: Direction = .horizontal, titles: [String], selectedIndex: Int = 0) {
        self.titles = titles
        self.direction = direction
        self.selectedIndex = selectedIndex
        super.init(frame: frame)
        
        contentView.delegate = self
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        addSubview(contentView)
    }
    
    convenience init() {
        self.init(frame: .zero, direction: .horizontal, titles: [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        calculateItemRect()
        addAllItems()
    }
    
    func selecteItem(at index: Int) {
        if index == selectedIndex { return }
        
        if let lastItem = contentView.viewWithTag(selectedIndex + 66) as? UIButton {
            lastItem.isSelected = false
            lastItem.titleLabel?.font = textFont
        }
        
        if let currentItem = contentView.viewWithTag(index + 66) as? UIButton {
            currentItem.isSelected = true
            currentItem.titleLabel?.font = selectedTextFont
        }
        
        poDelegate?.segementView(self, fromIndex: selectedIndex, toIndex: index)
        
        adjustScrollViewContentOffset(by: index)
        selectedIndex = index
    }
    
    // MARK: - Helper
    
    private func calculateItemRect() {
        itemsRect = []
        var last: CGFloat = 0.0
        if direction == .horizontal {
            var x: CGFloat
            for (index, title) in titles.enumerated() {
                let titleRect = title.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height),
                                                   options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine],
                                                   attributes: [.font: textFont],
                                                   context: nil)
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
            for (index, title) in titles.enumerated() {
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
        
        contentView.contentSize = calculateContentSize()
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
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        
        for (index, rect) in itemsRect.enumerated() {
            let item = UIButton(frame: rect)
            item.setTitle(titles[index], for: .normal)
            item.setTitleColor(textColor, for: .normal)
            item.setTitleColor(selectedTextColor, for: .selected)
            item.titleLabel?.font = textFont
            item.addTarget(self, action: #selector(PoSegementView.itemSelectClick(_:)), for: .touchUpInside)
            item.tag = index + 66
            if index == selectedIndex {
                item.isSelected = true
                item.titleLabel?.font = selectedTextFont
            }
            contentView.addSubview(item)
        }
    }
    
    @objc
    private func itemSelectClick(_ sender: UIButton) {
        selecteItem(at: sender.tag - 66)
    }
    
    private func adjustScrollViewContentOffset(by selectedIndex: Int) {
        let itemRect = itemsRect[selectedIndex]
        switch direction {
        case .horizontal:
            if itemRect.midX < bounds.width / 2 {
                contentView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else if itemRect.midX >= bounds.width / 2 && itemRect.midX <= contentView.contentSize.width - contentView.bounds.width / 2 {
                contentView.setContentOffset(CGPoint(x: itemRect.midX - contentView.bounds.width / 2, y: 0), animated: true)
            } else {
                contentView.setContentOffset(CGPoint(x: contentView.contentSize.width - contentView.bounds.width, y: 0), animated: true)
            }
        case .vertical:
            if itemRect.midY < bounds.height / 2 {
                contentView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else if itemRect.midY >= contentView.bounds.height / 2 && itemRect.midY <= contentView.contentSize.height - bounds.height / 2 {
                contentView.setContentOffset(CGPoint(x: 0, y: itemRect.midY - contentView.bounds.height / 2), animated: true)
            } else {
                contentView.setContentOffset(CGPoint(x: 0, y: contentView.contentSize.height - contentView.bounds.height), animated: true)
            }
        }
        
    }
}

