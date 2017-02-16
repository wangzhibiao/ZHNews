//
//  NewsSectionModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import YYModel

/// 文字所属栏目的model
class NewsSectionModel: NSObject {

    /// 栏目的缩略图
    var thumbnail:String?
    /// 栏目的ID
    var id:String?
    /// 栏目的名称
    var name:String?
    
    
    override var description: String{
        return yy_modelDescription()
    }
}
