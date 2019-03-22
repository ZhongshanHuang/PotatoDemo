//
//  MenuViewController.swift
//  PotatoDemo
//
//  Created by 黄山哥 on 2019/3/15.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        
        let titles = ["网易", "腾讯", "淘宝", "google", "apple", "知乎日报", "海贼王", "犬夜叉", "美国队长3", "慢慢", "因为爱所以爱－谢霆锋"]
        let menuControl = PoMenuView(frame: CGRect(x: 0, y: 80, width: self.view.bounds.width, height: 30), direction: .horizontal, titles: titles)
        menuControl.backgroundColor = UIColor.gray
        menuControl.itemMargin = 20
        menuControl.poDelegate = self
        self.view.addSubview(menuControl)
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

extension MenuViewController: PoMenuViewDelegate {
    
    func menuView(_ view: PoMenuView, fromIndex: Int, toIndex: Int) {
        print("from: \(fromIndex) -> to: \(toIndex)")
    }
}
