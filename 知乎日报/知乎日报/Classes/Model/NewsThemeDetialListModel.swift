//
//  NewsThemeDetialModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/18.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import YYModel

/// 栏目详细模型
class NewsThemeDetialListModel: NSObject {
    
    /// 栏目相续cell数组
    var stories:[NewsThemeDtilalCellModel]?
    /// 栏目描述
    var desc:String?
    /// 大图背景
    var background:String?
    var color: Int64 = 0
    /// 栏目名字
    var name: String?
    /// 小图背景
    var image: String?
    /// 栏目作者数组
    var editors: [NewsEditorModel]?
    /// 不知道干嘛用的
    var image_source: String?

    
    // 因为description 与yymodel的属性冲突所有单独做映射
    class func modelCustomPropertyMapper()->[String: String] {
        return ["desc": "description"]
    }
    
    
    override var description: String {
        return yy_modelDescription()
    }

}
