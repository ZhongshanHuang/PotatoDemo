//
//  ADCircleScrollView.swift
//  OnePiece
//
//  Created by HzS on 16/4/21.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

protocol PoCarouselViewDelegate: class {
    func carouselView(_ view: PoCarouselView, tapAt index: Int)
}

extension PoCarouselViewDelegate {
    func carouselView(_ view: PoCarouselView, tapAt index: Int) {}
}

class PoCarouselView: UIView, UIScrollViewDelegate {
    
    // MARK: - Public Properties
    
    weak var poDelegate: PoCarouselViewDelegate?
    var urlStrings: [String]  = [] {
        didSet {
            if oldValue == urlStrings { return }

            timer?.invalidate()
            if (urlStrings.count == 1) {
                urlStrings = Array<String>(repeating: urlStrings[0], count: 3)
                realCount = 1
            } else if urlStrings.count == 2 {
                urlStrings += urlStrings
                realCount = 2
            } else {
                realCount = urlStrings.count
            }
            pageControl.numberOfPages = realCount
            reloadData()
            addTimer()
        }
    }
    var placeholder: UIImage?
    
    // MARK: - Private Properties
    
    private let scrollView: UIScrollView = UIScrollView()
    private let pageControl: UIPageControl = UIPageControl()
    private let leftImageView: UIImageView = UIImageView()
    private let middleImageView: UIImageView = UIImageView()
    private let rightImageView: UIImageView = UIImageView()
    private var timer: Timer?
    private var currentIndex = 0
    private var realCount: Int = 0
    private var itemCount: Int {
        return urlStrings.count
    }
    
    
    init(frame: CGRect, urlStrings: [String], placeholder: UIImage?) {
        self.placeholder = placeholder
        super.init(frame: frame)
        setupSubviews(urlStrings)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews(_ param: [String]) {
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: bounds.width * 3, height: bounds.height)
        scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        addSubview(scrollView)
        
        pageControl.frame = CGRect(x: 0, y: bounds.height - 18 - 8, width: bounds.width, height: 18)
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = 0
        addSubview(pageControl)
        
        leftImageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        middleImageView.frame = CGRect(x: bounds.width, y: 0, width: bounds.width, height: bounds.height)
        rightImageView.frame = CGRect(x: bounds.width * CGFloat(2), y: 0, width: bounds.width, height: bounds.height)
        
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.clipsToBounds = true
        scrollView.addSubview(leftImageView)
        
        middleImageView.contentMode = .scaleAspectFill
        middleImageView.clipsToBounds = true
        scrollView.addSubview(middleImageView)
        
        rightImageView.contentMode = .scaleAspectFill
        rightImageView.clipsToBounds = true
        scrollView.addSubview(rightImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PoCarouselView.tapHandler))
        addGestureRecognizer(tap)
        urlStrings = param
    }
    
    
    func stopAutoScroll() {
        timer?.invalidate()
    }
    
    func reloadData() {
        let contentOffset = scrollView.contentOffset.x
        if contentOffset > bounds.width {
            currentIndex = (currentIndex + 1) % itemCount
        } else if contentOffset < bounds.width {
            currentIndex = (currentIndex - 1 + itemCount) % itemCount
        }
        updateImages(by: currentIndex)
    }
    
    func updateImages(by index: Int) {
        middleImageView.kf.setImage(with: URL(string: urlStrings[index]), placeholder: placeholder)
        leftImageView.kf.setImage(with: URL(string: urlStrings[(index - 1 + itemCount) % itemCount]), placeholder: placeholder)
        rightImageView.kf.setImage(with: URL(string: urlStrings[(index + 1) % itemCount]), placeholder: placeholder)
        
        if realCount == 1 {
            pageControl.currentPage = 0
        } else if realCount == 2 {
            pageControl.currentPage = (realCount <= 2 && index >= 2) ? ((index - 2) % itemCount) : (index)
        } else {
            pageControl.currentPage = index;
        }
    }
    
    
    // MARK: Private convenience methods
    @objc func addTimer() {
        guard realCount > 1 else { return }
        timer?.invalidate()
        
        timer = scheduledTimerWith(3,
                                   target: self,
                                   selector: #selector(PoCarouselView.scrollToNext),
                                   userInfo: nil,
                                   repeats: true)
    }
    
    private func scheduledTimerWith(_ interval: TimeInterval,
                            target: AnyObject,
                            selector: Selector,
                            userInfo: AnyObject?,
                            repeats: Bool) -> Timer {
        let timerTarget = PoWeakTimerTarget()
        timerTarget.target = target
        timerTarget.selector = selector
        // 这儿target的timer是weak修饰，之所以这儿初始化后没有立马释放是因为通过类方法创建的，返回的时候放入了autoreleasepool中
        timerTarget.timer = Timer.scheduledTimer(timeInterval: interval,
                                                 target: timerTarget,
                                                 selector: #selector(PoWeakTimerTarget.fire(_:)),
                                                 userInfo: userInfo,
                                                 repeats: repeats)
        return timerTarget.timer!
    }
    
    @objc
    private func scrollToNext() {
        scrollView.setContentOffset(CGPoint(x: bounds.width * 2, y: 0), animated: true)
        perform(#selector(PoCarouselView.delayWork), with: nil, afterDelay: 0.3)
    }
    
    @objc
    private func delayWork() {
        self.reloadData()
        self.scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
    }
    
    @objc
    private func tapHandler() {
        var realIndex = currentIndex
        if realCount == 1 {
            realIndex = 0
        } else if realCount == 2 {
            realIndex = (realCount <= 2 && realIndex >= 2) ? ((realIndex - 2) % itemCount) : (realIndex)
        } else {
            realIndex = currentIndex
        }
        poDelegate?.carouselView(self, tapAt: realIndex)
    }
    
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reloadData()
        scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        perform(#selector(PoCarouselView.addTimer), with: nil, afterDelay: 2)
    }
    
    deinit {
        print("PoCaroucel Deinit")
    }
}

//这个是为了不被强引造成内存泄露
class PoWeakTimerTarget: NSObject {
    weak var timer: Timer?
    weak var target: AnyObject?
    var selector: Selector?
    
    @objc func fire(_ timer: Timer) {
        if let tg = target {
            tg.perform(selector!, with: nil, afterDelay: 0)
        } else {
            self.timer?.invalidate()
        }
    }
}
