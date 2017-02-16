//
//  NewsThemeDtilalCellModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/18.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import YYModel

/// 栏目详细数组cell的model
class NewsThemeDtilalCellModel: NSObject {

    /// 类型
    var type:Int64 = 0
    /// id
    var id:String?
    /// 标题
    var title:String?
    
    
    override var description: String {
    
        return yy_modelDescription()
    }
}
