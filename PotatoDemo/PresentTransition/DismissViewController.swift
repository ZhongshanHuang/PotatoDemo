//
//  DismissViewController.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/8.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class DismissViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purple
        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        dismissButton.center = view.center
        dismissButton.addTarget(self, action: #selector(DismissViewController.dismissAction(_:)), for: .touchUpInside)
        view.addSubview(dismissButton)
        
    }
    
    @objc func dismissAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("dismiss deinit")
    }
}
