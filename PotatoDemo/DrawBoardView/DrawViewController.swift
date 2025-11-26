//
//  DrawViewController.swift
//  PotatoDemo
//
//  Created by 黄山哥 on 2019/3/14.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        let drawBoard = PoDrawBoardView()
        view.addSubview(drawBoard)
        drawBoard.translatesAutoresizingMaskIntoConstraints = false
        drawBoard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        drawBoard.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        drawBoard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        drawBoard.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let nav = navigationController as? NavigationController {
//            nav.navigationDelegate.panGesture.isEnabled = false
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if let nav = navigationController as? NavigationController {
//            nav.navigationDelegate.panGesture.isEnabled = true
//        }
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
