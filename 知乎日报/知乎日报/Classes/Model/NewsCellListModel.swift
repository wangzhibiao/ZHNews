//
//  NewsCellListModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/13.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import YYModel

class NewsCellListModel: NSObject {
    
    /// 日期 "20160102"
    var date:String?
    /// 最新的新闻数组
    var stories:[NewsCellModel]?
    var top_stories:[NewsCellModel]?
    
    
    // 容器方法来对应子模型
    class func modelContainerPropertyGenericClass()->[String: AnyClass]{
        return ["stories": NewsCellModel.self,
                "top_stories": NewsCellModel.self]
    }
    
    
    override var description: String {
        return yy_modelDescription()
    }
}
