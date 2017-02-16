//
//  ListViewModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/13.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import Foundation

/// 这个模型就负责主页面的数据请求处理
class HomeListViewModel {
    
    // 顶部轮播数据
    lazy var topNews = [NewsCellModel]()
    // 当天的新闻
    lazy var todayNews = [NewsCellListModel]()
    // 往期的新闻 往期要显示日期 所有数list模型数组
    lazy var otherNews = [NewsCellListModel]()
    
    // 当前选中的新闻详情
    lazy var newsDtital = NewsCellModel()
    
    
    /// 根据id查询新闻详情
    func loadNewsDetial(id:Int64, completion:@escaping (_ isSuccess: Bool)->()){
    
        NetworkManager.shared.loadNewsDetial(newsID: id) { (json, isSuccess) in
            
            if isSuccess {
            
                // 解析json获取模型
                guard let json = json,
                    let model = NewsCellModel.yy_model(withJSON: json)
                else {
                    completion(false)
                    return
                }
                
                // 赋值属性
                self.newsDtital = model
                // 回调
                completion(true)
                
            }else {
                // 返回false
                completion(false)
            }
        }
    }
    
    
    
    // 定义查询列表的方法
    func loadNews(completion:@escaping (_ isSuccess: Bool)->()) {
        
        // 使用封装的方法来做
        NetworkManager.shared.loadNews { (list, isSuccess) in
            
            if isSuccess {
                
                // 请求成功 数据为nil
                guard let json = list as? [String: AnyObject],
                    let model = NewsCellListModel.yy_model(with: json)
                    else {
                        completion(false)
                        return
                }
                
                // 整理数据
                if self.checkNews(model: model) == true {
                    completion(true)
//                    print("获取其他新闻======\(model.date!)")
                }else {
                    completion(false)
                }
                
                
            }else {
                completion(isSuccess)
            }
        }
    }
    
    
    /// 获取某个日期之前的新闻
    ///
    /// - Parameters:
    ///   - dataStr: 日期
    ///   - completion: 完成回调
    func loadBefore(dataStr: String, completion:@escaping (_ isSuccess: Bool)->()) {
        
        NetworkManager.shared.loadBefore(dataStr: dataStr) { (list, isSuccess) in
            
            if isSuccess {
                // 请求成功 数据为nil
                guard let json = list as? [String: AnyObject],
                        let model = NewsCellListModel.yy_model(with: json)
                    else {
                        completion(false)
                        return
                }
                // 追加到其他日期新闻数组
                if self.otherNews.count > 0{
                
                    for m in self.otherNews {
                        
                        if m.date! == model.date!{
                            completion(false)
                            return
                        }
                    }
                }
                
                self.otherNews.append(model)
                print("获取其他新闻======\(model.date!)")
                
                completion(true)
                
            }else {
                completion(isSuccess)
            }
            
        }
    }
    
    
    
    /// 整理数据做更新
    ///
    /// - Parameter model: listmodel
    func checkNews(model: NewsCellListModel)->Bool {
        // 数据不为nil 转换为模型存储
        guard let modelDateStr = model.date,
            let tops = model.top_stories,
            let todays = model.stories
            else {
                // 整理失败
                return false
        }
        
        // 判断日期是否为同一天的即 今天的
        let todayStr = Date().ZHDateStr
        if (todayStr == modelDateStr){
            // 同一天的
            // 如果新闻条数改变了就替换
            if ( topNews.count != tops.count || todayNews.count != todays.count) {
                
                topNews = tops
                todayNews.insert(model, at: 0)
            }
            
        }else {
            // 不是当前天的 要把三个数组都替换
            topNews = tops
            todayNews = [model]
            // 其他天的新闻要清空
            otherNews.removeAll()
        }
        
        // 整理完毕
        return true
    }
    
}











