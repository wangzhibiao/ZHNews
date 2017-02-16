//
//  String+Extension.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/13.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import Foundation

// MARK: - 知乎字符串转日期
extension String {

    var ZHDate:Date? {
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        return formatter.date(from: self)
    }
}
