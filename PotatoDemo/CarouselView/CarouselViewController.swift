//
//  CarouselViewController.swift
//  PotatoDemo
//
//  Created by 黄山哥 on 2019/3/15.
//  Copyright © 2019 黄山哥. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        let urls = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552628747830&di=6c9ce52bf8904f3707448a3fcf719518&imgtype=0&src=http%3A%2F%2Fpic1.iqiyipic.com%2Fimage%2F20151230%2Ffc%2F81%2Fv_109897341_m_601_480_360.jpg",
        "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1552618704&di=7264288cb1d020b264e53bdb825b3a01&src=http://img.zcool.cn/community/0315cc0572accbe000001741c530e09.jpg",
        "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1552618704&di=d1b23660db7dbc20207040faebede326&src=http://imgtu.5011.net/uploads/content/20170210/6477851486719189.jpg",
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552628854731&di=79f74e6fec3f9f21c2be1ed2fe51dbd1&imgtype=jpg&src=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D1110506834%2C168621849%26fm%3D214%26gp%3D0.jpg",
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552628854107&di=58fc7ce4a60a4f99f42dd5640013cb4a&imgtype=0&src=http%3A%2F%2Fvpic.video.qq.com%2F3388556%2Fs0349afhd22_ori_3.jpg",
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552628854107&di=ffcfc1c77441ce7dc25d1939ca23a7e9&imgtype=0&src=http%3A%2F%2Fvpic.video.qq.com%2F53554578%2Ff03685z8j8r_ori_3.jpg"]
        
        let carousel = PoCarouselView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), urlStrings: urls, placeholder: nil)
        carousel.poDelegate = self
        view.addSubview(carousel)
        
    }
}

extension CarouselViewController: PoCarouselViewDelegate {
    
    func carouselView(_ view: PoCarouselView, tapAt index: Int) {
        print("tap at \(index)")
    }
}
