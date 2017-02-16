//
//  NewsThemeModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/18.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import YYModel

class NewsThemeModel: NSObject {
    /// 颜色
    var color:String?
    /// 频道缩略图
    var thumbnail:String?
    /// 频道描述
    var desc:String?
    /// 频道ID
    var id:Int64 = 0
    /// 频道名字
    var name:String?
    
    
    
    // 因为description 与yymodel的属性冲突所有单独做映射
    class func modelCustomPropertyMapper()->[String: String] {
        return ["desc": "description"]
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
