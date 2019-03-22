//
//  HZSCollectionViewMasonryLayout2.swift
//  MasonryCollectionView
//
//  Created by HzS on 16/4/12.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit


@objc protocol PoCollectionViewMasonryLayoutDelegate: UICollectionViewDelegate {
    
    // MARK: height methods
    func collectionViewMasonryLayout(_ collectionView: UICollectionView, layout: PoCollectionViewMasonryLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
    
    @objc optional func collectionViewMasonryLayout(_ collectionView: UICollectionView, layout: PoCollectionViewMasonryLayout, heightForHeaderAt section: Int) -> CGFloat
    
    @objc optional func collectionViewMasonryLayout(_ collectionView: UICollectionView, layout: PoCollectionViewMasonryLayout, heightForFooterAt section: Int) -> CGFloat
    
    // MARK: insets methods
    @objc optional func collectionViewMasonryLayout(_ collectionView: UICollectionView, layout: PoCollectionViewMasonryLayout, insetsForSectionAt section: Int) -> UIEdgeInsets
    
    @objc optional func collectionViewMasonryLayout(_ collectionView: UICollectionView, layout: PoCollectionViewMasonryLayout, insetsForHeaderAt section: Int) -> UIEdgeInsets
    
    @objc optional func collectionViewMasonryLayout(_ collectionView: UICollectionView, layout: PoCollectionViewMasonryLayout, insetsForFooterAt section: Int) -> UIEdgeInsets
}

extension PoCollectionViewMasonryLayout {
    
    private struct DelegateHas {
        var hasHeightForHeaderAtIndexPath = false
        var hasHeightForFooterAtIndexPath = false
        var hasInsetsForSection = false
        var hasInsetsForHeader = false
        var hasInsetsForFooter = false
    }

}

class PoCollectionViewMasonryLayout: UICollectionViewLayout {
    
    // MARK: Public property
    
    var columnCount: Int = 3
    var minColumnSpacing: CGFloat = 10
    var minInterItemSpacing: CGFloat = 10
    
    var headerHeight: CGFloat = 0.0
    var footerHeight: CGFloat = 0.0
    
    var sectionInsets: UIEdgeInsets = .zero
    var headerInsets: UIEdgeInsets = .zero
    var footerInsets: UIEdgeInsets = .zero
    
    // MARK: Private property
    
    var masonryDelegate: PoCollectionViewMasonryLayoutDelegate {
        return collectionView!.delegate as! PoCollectionViewMasonryLayoutDelegate
    }
    
    private lazy var columnHeights = ContiguousArray<CGFloat>()
    private lazy var sectionItemAttributes = Array<Array<UICollectionViewLayoutAttributes>>()
    private lazy var allItemAttributes = Array<UICollectionViewLayoutAttributes>()
    private lazy var headerAttributes = Dictionary<Int, UICollectionViewLayoutAttributes>()
    private lazy var footerAttributes = Dictionary<Int, UICollectionViewLayoutAttributes>()
    private var delegateHas: DelegateHas = DelegateHas()
    
    // MARK: Override
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if collectionView!.bounds.size.width == newBounds.size.width {
            return false
        }
        return true
    }
    
    override func prepare() {
        let sectionCount = collectionView!.numberOfSections
        if sectionCount == 0 { return }
        
        // 检查协议实现情况
        delegateHas.hasHeightForHeaderAtIndexPath = masonryDelegate.responds(to: #selector(PoCollectionViewMasonryLayoutDelegate.collectionViewMasonryLayout(_:layout:heightForHeaderAt:)))
        delegateHas.hasHeightForFooterAtIndexPath = masonryDelegate.responds(to: #selector(PoCollectionViewMasonryLayoutDelegate.collectionViewMasonryLayout(_:layout:heightForFooterAt:)))
        delegateHas.hasInsetsForHeader = masonryDelegate.responds(to: #selector(PoCollectionViewMasonryLayoutDelegate.collectionViewMasonryLayout(_:layout:insetsForHeaderAt:)))
        delegateHas.hasInsetsForFooter = masonryDelegate.responds(to: #selector(PoCollectionViewMasonryLayoutDelegate.collectionViewMasonryLayout(_:layout:insetsForFooterAt:)))
        delegateHas.hasInsetsForSection = masonryDelegate.responds(to: #selector(PoCollectionViewMasonryLayoutDelegate.collectionViewMasonryLayout(_:layout:insetsForSectionAt:)))
        
        //信息重置
        columnHeights.removeAll()
        sectionItemAttributes.removeAll()
        allItemAttributes.removeAll()
        headerAttributes.removeAll()
        footerAttributes.removeAll()
        
        for _ in 0..<columnCount {
            columnHeights.append(0)
        }
        
        let width = collectionView!.bounds.size.width
        var top: CGFloat = 0
        var attributes: UICollectionViewLayoutAttributes
        
        for section in 0..<sectionCount {
            var sectionInset = sectionInsets
            
            if delegateHas.hasInsetsForSection {
                sectionInset = masonryDelegate.collectionViewMasonryLayout!(collectionView!, layout: self, insetsForSectionAt: section)
            }
            var headerInset = headerInsets
            if delegateHas.hasInsetsForHeader {
                headerInset = masonryDelegate.collectionViewMasonryLayout!(collectionView!, layout: self, insetsForHeaderAt: section)
            }
            var footerInset = footerInsets
            if delegateHas.hasInsetsForFooter {
                footerInset = masonryDelegate.collectionViewMasonryLayout!(collectionView!, layout: self, insetsForFooterAt: section)
            }
            
            // header
            top += headerInset.top
            
            var headerH: CGFloat
            if delegateHas.hasHeightForHeaderAtIndexPath {
                headerH = masonryDelegate.collectionViewMasonryLayout!(collectionView!, layout: self, heightForHeaderAt: section)
            } else {
                headerH = headerHeight
            }
            
            if headerH > 0 {
                let headerWidth = width - (headerInsets.left + headerInsets.right)
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: headerInset.left, y: top, width: headerWidth, height: headerH)
                
                headerAttributes[section] = attributes
                allItemAttributes.append(attributes)
                top = attributes.frame.maxY + headerInset.bottom
            }
            top += sectionInset.top
            for idx in 0..<columnCount {
                columnHeights[idx] = top
            }
            
            // item
            let itemWidth = (width - (sectionInset.left + sectionInset.right) - CGFloat(columnCount - 1) * minColumnSpacing ) / CGFloat(columnCount)
            top += sectionInset.bottom
            var itemAttributesArray = Array<UICollectionViewLayoutAttributes>()
            
            let itemCount = collectionView!.numberOfItems(inSection: section)
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let currentColumn = findShortestColumn()
                let itemX = sectionInset.left + (itemWidth + minColumnSpacing) * CGFloat(currentColumn.column)
                let itemY = currentColumn.height
                let itemH = masonryDelegate.collectionViewMasonryLayout(collectionView!, layout: self, heightForItemAt: indexPath)
                
                attributes.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemH)
                
                itemAttributesArray.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[currentColumn.column] = attributes.frame.maxY + minInterItemSpacing
            }
            sectionItemAttributes.append(itemAttributesArray)
            
            // footer
            top = findTallestColumn() - minInterItemSpacing + sectionInsets.bottom
            top += footerInset.top
            
            var footerH: CGFloat
            if delegateHas.hasHeightForFooterAtIndexPath {
                footerH = masonryDelegate.collectionViewMasonryLayout!(collectionView!, layout: self, heightForFooterAt: section)
            } else {
                footerH = headerHeight
            }
            if footerH > 0 {
                let footerWidth = width - (footerInsets.left + footerInsets.right)
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: footerInset.left, y: top, width: footerWidth, height: footerHeight)
                footerAttributes[section] = attributes
                allItemAttributes.append(attributes)
                top = attributes.frame.maxY + footerInset.bottom
            }
            
            for idx in 0..<columnCount {
                columnHeights[idx] = top
            }
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let firstMatchIndex = _binarySearchForIntersectsAttributes(array: allItemAttributes, in: rect)
        if firstMatchIndex < 0 {
            return nil
        } else {
            var result = [UICollectionViewLayoutAttributes]()
            
            // 从后向前反向遍历
            for attributes in allItemAttributes[..<firstMatchIndex].reversed() {
                guard attributes.frame.maxY >= rect.minY else { break }
                result.append(attributes)
            }
            
            // 从前往后正向遍历
            for attributes in allItemAttributes[firstMatchIndex...] {
                guard attributes.frame.minY <= rect.maxY else { break }
                result.append(attributes)
            }
            
            return  result
        }
    }
    
    private func _binarySearchForIntersectsAttributes(array: [UICollectionViewLayoutAttributes], in rect: CGRect) -> Int {
        var low = 0
        var hight = array.count - 1
        while low <= hight {
            let mid = low + (hight - low) / 2
            if array[mid].frame.intersects(rect) {
                return mid
            } else if array[mid].frame.maxY < rect.minY {
                low = mid + 1
            } else {
                hight = mid - 1
            }
        }
        return -1
    }
    
    // contentSize
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: columnHeights[0])
    }
    
    // item
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < collectionView!.numberOfSections && indexPath.item < collectionView!.numberOfItems(inSection: indexPath.section) else {
            return nil
        }
        return sectionItemAttributes[indexPath.section][indexPath.item]
    }
    
    // header
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < collectionView!.numberOfSections else { return nil }
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            return headerAttributes[indexPath.section]
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            return footerAttributes[indexPath.section]
        } else {
            return nil
        }
    }
    
    // MARK: - Helper
    
    func findShortestColumn() -> (column: Int, height: CGFloat) {
        var shortest: CGFloat = columnHeights[0]
        var index: Int = 0
        for (column, height) in columnHeights.enumerated() {
            if shortest > height {
                shortest = height
                index = column
            }
        }
        return (index, shortest)
    }
    
    func findTallestColumn() -> CGFloat {
        var tallest: CGFloat = -1
        for height in columnHeights {
            if tallest < height {
                tallest = height
            }
        }
        return tallest
    }
    
}
