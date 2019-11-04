//
//  PageViewController.swift
//  PotatoDemo
//
//  Created by 黄山哥 on 2019/6/30.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let red = CGFloat.random(in: 0...255) / 255
        let green = CGFloat.random(in: 0...255) / 255
        let blue = CGFloat.random(in: 0...255) / 255
        view.backgroundColor = UIColor(displayP3Red: red, green: green, blue: blue, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        label.backgroundColor = UIColor.yellow
        label.text = "labellabellabellabellabel"
        view.addSubview(label)
        print("\(title ?? "空白") did load")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(title ?? "空白") did disappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(title ?? "空白") did appear")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
