//
//  WaterFallHeader.swift
//  PotatoDemo
//
//  Created by 黄山哥 on 2019/3/13.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

class WaterFallHeader: UICollectionReusableView {
    
    let label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellow
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }

}
