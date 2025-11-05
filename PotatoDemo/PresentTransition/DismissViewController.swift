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
        
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
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

extension DismissViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}
