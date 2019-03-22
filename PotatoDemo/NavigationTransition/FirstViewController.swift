//
//  FirstViewController.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/6.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purple
        let pushButton = UIButton.init(type: .custom)
        pushButton.setTitle("pushViewController", for: .normal)
        pushButton.frame = CGRect(x: view.bounds.size.width/2 - 100/2, y: 200, width: 100, height: 30)
        pushButton.addTarget(self, action: #selector(FirstViewController.pushAction), for: .touchUpInside)
        view.addSubview(pushButton)
    }
    
    //button action
    @objc func pushAction() {
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
