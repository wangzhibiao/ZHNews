//
//  ThemeListViewModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/18.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

/// 这个类负责所有根主题相关的请求数据方法
class ThemeListViewModel {

    var themes:[NewsThemeModel]?
    var themeDetials:[NewsThemeDtilalCellModel]?
    
    
    
    /// 加载左侧菜单栏的主题数组
    func loadThemesList(completion:@escaping (_ isSuccess: Bool)->()) {
        
        NetworkManager.shared.loadThemes { (json, isSuccess) in
            
            if isSuccess {
            
                guard let json = json,
                    let model = NewsThemeListModel.yy_model(withJSON: json)
                else {
                    completion(false)
                    return
                }
                
                guard let others = model.others else {
                    completion(false)
                    return
                }
                
                self.themes = others
                completion(true)
                
            }else {
                completion(false)
            }
        }
        
    }
    
    
    
}
