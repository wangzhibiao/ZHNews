//
//  CommonURL.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//
// *****************************************************
// ***** 感谢GitHub @ZhihuDailyPurify 提供的帮助 **********
// *****************************************************

import Foundation

/// 定义获取数据的基础url
class CommonURL {
    
    /// 启动图像获取 start-image 后为图像分辨率，接受任意的 number*number 格式， number 为任意非负整数，返回值均相同
    static let lunchURL = "http://news-at.zhihu.com/api/4/start-image/1080*1776"
    /// URL 最后部分的数字代表所安装『知乎日报』的版本
    static let VersionURL = "http://news-at.zhihu.com/api/4/version/ios/2.3.0"
    /// 最新消息获取
    static let lastNewsURL = "http://news-at.zhihu.com/api/4/news/latest"
    /// 由上面获取的数据中对应新闻的id拼接在最后可获取具体详情
    static let detialNewsURL = "http://news-at.zhihu.com/api/4/news/"
    /// 过往消息获取 将日期拼接在最后可获取以前的消息
    static let beforeNewsURL = "http://news-at.zhihu.com/api/4/news/before/"
    /// 新闻额外消息 如 点赞数 长评论数 短评论数 id 拼接最后
    static let storyURL = "http://news-at.zhihu.com/api/4/story-extra/"
    /// 获取主题
    static let themeURL = "http://news-at.zhihu.com/api/4/themes"
    /// 主题详细 + id
    static let themeDetialURL = "http://news-at.zhihu.com/api/4/theme/"

}
