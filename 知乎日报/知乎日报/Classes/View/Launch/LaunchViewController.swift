//
//  LaunchViewController.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    // 启动图片
    var image: UIImage? {
        didSet{
            // 当设置了图片等时候 对启动图view去做设置
            launchImage.image = image
        }
    }
    
    /// 懒加载启动图
    lazy var launchImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化界面
        setupUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}


// MARK: - 初始化界面
private extension LaunchViewController {

    func setupUI() {
        // 设置背景颜色和大小
        view.backgroundColor = UIColor.white
        view.frame = UIScreen.main.bounds
        
        // 加入启动图片等view
        launchImage.frame = view.frame
        view.addSubview(launchImage)
    }
}

