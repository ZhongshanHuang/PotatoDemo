//
//  HZSTableViewController.swift
//  Demo_HZS
//
//  Created by HzS on 16/6/13.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class CartoonViewController: UIViewController {
    
    var tableView: PoCartoonView!
    var dataList: Array<String>  = {
        var imageNames = Array<String>()
        for index in 1...44 {
            var imageName = String(format: "%03d", index)
            imageName = Bundle.main.path(forResource: imageName, ofType: "jpg")!
            imageNames.append(imageName)
        }
        return imageNames
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = PoCartoonView(frame: view.bounds);
        tableView.poDelegate = self
        tableView.poDataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CartoonViewController: PoCartoonViewDelegate, PoCartoonViewDataSource {
    
    // MARK :dataSource
    func numberOfCellsInCartoonView(_ tableView: PoCartoonView) -> Int {
        return dataList.count
    }
    
    func cartoonView(_ tableview: PoCartoonView, cellForRowAtIndex index: Int) -> PoCartoonViewCell {
        var cell = tableView?.dequeueReusableCellWithIdentifier(PoCartoonViewCell.description())
        if cell == nil {
            cell = PoCartoonViewCell(reusedIdentifier: PoCartoonViewCell.description())
        }
        cell?.imageView.image = UIImage(contentsOfFile: dataList[index])
        
        return cell!
    }
    
    // MARK :delegate
    func cartoonView(_ tableView: PoCartoonView, heightForCellAtIndex: Int) -> CGFloat {
//        return CGFloat(arc4random() % 100) + 200
        return 250
    }
    
    func cartoonView(_ tableView: PoCartoonView, clickWithGrsture: UITapGestureRecognizer) {
        print("tableView.offset = ", tableView.contentOffset)
        print("tableView.contentSize = ", tableView.contentSize)
    }
}
