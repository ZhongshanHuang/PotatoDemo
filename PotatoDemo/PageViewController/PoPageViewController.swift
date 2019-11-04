//
//  PoPageViewController.swift
//  PotatoDemo
//
//  Created by 黄山哥 on 2019/6/30.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

let kSegementH: CGFloat = 40
let kReuseIdentifier = "cellReuseIdentifier"

class PoPageViewController: UIViewController {

    // MARK: - Properties
    var titles: [String]?
    var viewControllerType: UIViewController.Type!
    
    private var segementView: PoSegementView!
    private var contentView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    private lazy var childrenMap: [Int: UIViewController] = [:]
    private var initSelectedIndex: Int = 0
    
    convenience init(titles: [String], viewControllerType: UIViewController.Type, initSelectedIndex: Int = 0) {
        self.init(nibName: nil, bundle: nil)
        self.titles = titles
        self.viewControllerType = viewControllerType
        self.initSelectedIndex = initSelectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        buildUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flowLayout.itemSize = contentView.frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        contentView.scrollToItem(at: IndexPath(item: initSelectedIndex, section: 0), at: .left, animated: false)
    }
    
    private func buildUI() {
        view.backgroundColor = UIColor.white
        
        segementView = PoSegementView(titles: titles!, selectedIndex: initSelectedIndex)
        segementView.poDelegate = self
        view.addSubview(segementView)
        segementView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            segementView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
            segementView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
            segementView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            segementView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            segementView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            segementView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        }
        
        segementView.heightAnchor.constraint(equalToConstant: kSegementH).isActive = true
        
        flowLayout = UICollectionViewFlowLayout()
        
        contentView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        contentView.backgroundColor = UIColor.white
        contentView.dataSource = self
        contentView.delegate = self
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.isPagingEnabled = true
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            contentView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
            contentView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        }
        contentView.topAnchor.constraint(equalTo: segementView.bottomAnchor).isActive = true
        
        contentView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kReuseIdentifier)
    }
    
    private func displayChild(_ vc: UIViewController, to canvas: UICollectionViewCell) {
        addChild(vc)
        canvas.contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    private func hideChild(_ vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    private func viewController(for key: Int) -> UIViewController {
        if let vc = childrenMap[key] {
            return vc
        } else {
            let vc = viewControllerType.init()
            vc.title = titles?[key]
            childrenMap[key] = vc
            return vc
        }
    }
}


// MARK: - PoSegementViewDelegate
extension PoPageViewController: PoSegementViewDelegate {
    
    func segementView(_ segementView: PoSegementView, fromIndex: Int, toIndex: Int) {
        
        contentView.contentOffset.x = CGFloat(toIndex) * view.bounds.width
        
        print("from: \(fromIndex) ---> to: \(toIndex)")
//        hideChild(viewController(for: fromIndex))
    }
    
}


// MARK: - UICollectionViewDataSource
extension PoPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.purple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        hideChild(viewController(for: indexPath.row))
    }

}


// MARK: - UICollectionViewDelegateFlowLayout
extension PoPageViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        segementView.selecteItem(at: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        displayChild(viewController(for: indexPath.item), to: cell)
    }
}
