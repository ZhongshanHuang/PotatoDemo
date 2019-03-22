//
//  HZSTableViewCell.swift
//  Demo_HZS
//
//  Created by HzS on 16/6/13.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

class PoCartoonViewCell: UIView {
    var reusedIdentifier: String
    private(set) var imageView: UIImageView = UIImageView()
    
    init(reusedIdentifier: String) {
        self.reusedIdentifier = reusedIdentifier
        super.init(frame: CGRect.zero)
        
        self.clipsToBounds = true
        self.imageView.frame = bounds;
        self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
