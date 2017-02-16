//
//  NewsThemeModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

/// 频道的数组model
class NewsThemeListModel: NSObject {

    /// 返回限制
    var limit:Int = 0
    /// 已订阅的频道
    var subscribed:[AnyObject]?
    /// 所以频道的信息
    var others:[NewsThemeModel]?

    
    // 容器方法来对应子模型
    class func modelContainerPropertyGenericClass()->[String: AnyClass]{
        return ["others": NewsThemeModel.self]
    }

    
    override var description: String {
        return yy_modelDescription()
    }
}





