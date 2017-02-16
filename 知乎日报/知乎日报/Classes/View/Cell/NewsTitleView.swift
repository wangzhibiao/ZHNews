//
//  NewsBannerView.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/15.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

/// 顶部的轮播是图
class NewsTitleView: UIView {

    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var meunButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var flashIcon: UIActivityIndicatorView!
    
    
   /// 菜单按钮点击
    @IBAction func menuBtnClick(_ sender: Any) {
        
        // 发送打开菜单通知
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: MenuButtonClickNotification)))
    }
    
        
    // 供外接调用的类初始化方法
    class func titleView() -> NewsTitleView {
        
        let nib = UINib(nibName: "NewsTitleView", bundle: nil)
        let tv = nib.instantiate(withOwner: nil, options: nil)[0] as! NewsTitleView
        
        return tv
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
