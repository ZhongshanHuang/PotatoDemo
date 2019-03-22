//
//  ViewController.swift
//  PotatoDemo
//
//  Created by 黄山哥 on 2019/3/13.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataItems: [String] {
        return ["PresentTransition", "NavigationTransition", "WaterFallLayout", "CartoonView", "layerAnimation(手指左右滑动)", "DrawBoard", "CarouselView", "MenuView"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "MainView"
        
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            let vc = PresentViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = FirstViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = WaterFallViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = CartoonViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = LayerAnimationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = DrawViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = CarouselViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = MenuViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("nothing")
        }
    }

}


// MARK: _ UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: UITableViewCell.description())
        }
        cell!.textLabel?.text = dataItems[indexPath.row]
        return cell!
    }
}
