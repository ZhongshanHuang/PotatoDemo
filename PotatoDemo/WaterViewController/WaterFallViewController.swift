//
//  WaterViewController.swift
//  PotatoDemo
//
//  Created by 黄山哥 on 2019/3/13.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

class WaterFallViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout = PoCollectionViewMasonryLayout()
        layout.headerHeight = 40
        layout.footerHeight = 30
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.register(WaterFallCell.self, forCellWithReuseIdentifier: WaterFallCell.description())
        collectionView.register(WaterFallHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WaterFallHeader.description())
        collectionView.register(WaterFallFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: WaterFallFooter.description())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:_ UICollectionViewDataSource
extension WaterFallViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterFallCell.description(), for: indexPath as IndexPath)
        
        let red = CGFloat(arc4random_uniform(255)) / 255.0
        let green = CGFloat(arc4random_uniform(255)) / 255.0
        let blue = CGFloat(arc4random_uniform(255)) / 255.0
        cell.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        (cell as! WaterFallCell).label.text = "\(indexPath.row)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WaterFallHeader.description(), for: indexPath)
            (view as! WaterFallHeader).label.text = "Header: \(indexPath.section)"
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WaterFallFooter.description(), for: indexPath)
            (view as! WaterFallFooter).label.text = "Footer: \(indexPath.section)"
            return view
        }
    }
}

// MARK: - PoCollectionViewMasonryLayout
extension WaterFallViewController: PoCollectionViewMasonryLayoutDelegate {
    
    func collectionViewMasonryLayout(_ collectionView: UICollectionView, layout: PoCollectionViewMasonryLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(40)) + 30
    }
    
    func collectionViewMasonryLayout(_ collectionView: UICollectionView, layout: PoCollectionViewMasonryLayout, insetsForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 20)
        } else if section == 1 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 80)
        } else if section == 2 {
            return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        } else if section == 3 {
            return UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        } else if section == 4 {
            return UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets.zero
        }
    }

}
