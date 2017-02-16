//
//  NewsEditorModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/18.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import YYModel

/// 栏目作者
class NewsEditorModel: NSObject {

    /// 知乎主页
    var url: String?
    /// 博主昵称
    var bio: String?
    /// 博主id
    var id: Int64 = 0
    /// 博主头像
    var avatar: String?
    /// 博主名字
    var name:String?
    
    
    override var description: String {
        return yy_modelDescription()
    }
    
}
