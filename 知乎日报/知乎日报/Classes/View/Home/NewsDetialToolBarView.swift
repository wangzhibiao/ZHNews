//
//  NewsDetialToolBarView.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/16.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

/// 新闻详情页面底部工具条
class NewsDetialToolBarView: UIView {

    
    /// 返回啊扭
    @IBOutlet weak var backBtn: UIButton!
    /// 下一个
    @IBOutlet weak var nextBtn: UIButton!
    /// 赞
    @IBOutlet weak var zanBtn: UIButton!
    /// 分享
    @IBOutlet weak var shareBtn: UIButton!
    /// 评论
    @IBOutlet weak var compseBtn: UIButton!
    
    // 返回按钮点击
    @IBAction func backBtnClikc(btn: UIButton){
    
        NotificationCenter.default.post(Notification(name: Notification.Name(DetialViewBackButtonClickNotification)))
    }
    
}
