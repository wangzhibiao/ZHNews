//
//  Date+Extension.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/13.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import Foundation

// MARK: - 获取知乎日报格式的字符串
extension Date {

    /// 知乎日报格式的字符串 "20170102"
    var ZHDateStr:String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        return formatter.string(from: self)
    }
    
    /// 知乎日报格式的字符串 "01月12日 星期四"
    var ZHLocalDateStr:String {
    
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let today = formatter.date(from: self.ZHDateStr)
        
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "MM月d日 cccc"
        
        return formatter.string(from: today!)
    }
}
