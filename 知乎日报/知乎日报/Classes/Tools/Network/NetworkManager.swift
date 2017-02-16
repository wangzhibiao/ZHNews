//
//  NetworkManager.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import Foundation
import Alamofire

/// 封装网络请求方法
class NetworkManager {
    
    // 单例
    static let shared  = NetworkManager()
    private init(){}
}

// MARK: - Alamofire基础方法封装
extension NetworkManager {

     func request(url: String, method: HTTPMethod = .get, parameters: [String: AnyObject]?, completion:@escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters).responseJSON { (response) in
                            
                            switch response.result {
                                
                            case .success(let json):
                                completion(json as AnyObject?, true)
                                
                            case .failure(let error):
                                print("请求失败 \(error)")
                                completion(nil, false)
                        }
        }
    }
}


// MARK: - 本应单独写这里简单的就做个扩展 专门负责news的各种请求
extension NetworkManager {
    
    /// 获取最新新闻
    ///
    /// - Parameter completion: 完成回调
     func loadNews(completion:@escaping (_ json:AnyObject?, _ isSuccess: Bool)->()) {
        
        request(url: CommonURL.lastNewsURL,
                parameters: nil,
                completion: completion)
    }
    
    
    /// 获取某个日期之前的新闻
    ///
    /// - Parameters:
    ///   - dataStr: 获取该日期之前的新闻
    ///   - completion: 完成回调
    func loadBefore(dataStr: String, completion:@escaping (_ json:AnyObject?, _ isSuccess: Bool)->()) {
        
        let url = CommonURL.beforeNewsURL + dataStr
        
        request(url: url, parameters: nil, completion: completion)
    }

    
    /// 获取新闻详情
    ///
    /// - Parameters:
    ///   - newsID: 新闻ID
    ///   - completion: 完成回调
    func loadNewsDetial(newsID: Int64, completion:@escaping (_ json:AnyObject?, _ isSuccess: Bool)->()) {
    
        let url = CommonURL.detialNewsURL + "\(newsID)"
        
        request(url: url, parameters: nil, completion: completion)
    }
    
    
    /// 获取新闻的额外信息 评论 点赞数等
    ///
    /// - Parameters:
    ///   - newsID: 新闻ID
    ///   - completion: 完成回调
    func loadStory(newsID: Int64, completion:@escaping (_ json:AnyObject?, _ isSuccess: Bool)->()) {
        
        let url = CommonURL.storyURL + "\(newsID)"
        request(url: url, parameters: nil, completion: completion)
    }
    
    
    /// 获取主题列表
    func loadThemes(completion:@escaping (_ json:AnyObject?, _ isSuccess: Bool)->()) -> () {
        
        request(url: CommonURL.themeURL, parameters: nil, completion: completion)
    }
    
    /// 主题详细
    func loadTheme(withID: Int64, completion:@escaping (_ json:AnyObject?, _ isSuccess: Bool)->()) {
        let url = CommonURL.themeDetialURL + "\(withID)"
        request(url: url, parameters: nil, completion: completion)
    }
}


