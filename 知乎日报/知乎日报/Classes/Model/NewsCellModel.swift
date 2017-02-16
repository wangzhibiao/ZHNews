//
//  NewsCellModel.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

/// 新闻cell 模型
/// 注意： 在列表界面和详细界面都要使用 所以要讲所有设计到的属性都写出来
class NewsCellModel: NSObject,XMLParserDelegate {

    // ***** 以下为列表页面用到字段 ****
    /// 新闻标题
    var title:String?
    /// 没有用
    var ga_prefix:String?
    /// 配图的数组 这里获取的图片分辨率低 如果有多张 要显示多图标记
    var images:[String]?
    /// 类型 0 一般  1 就是专题
    var type:Int64 = 0
    /// 新闻等ID
    var id:Int64 = 0
    /// 是否多图 只有多图才有这个属性
    var multipic:Int = 0
    
    // ******** 以下为详情页面用到字段 *********
    /// 供webview使用的body标签
    var body:String? {
        didSet{
            guard let body = body else {
                return
            }
            
            if let css = css {
                bodyHtml += "<html><head><link rel='stylesheet' href='\(css[0])'/></head>"
                //由于它的CSS中已经写死了 顶部图片的高度就是200,因此这个地方设置为0
                bodyHtml += "<style> .headline .img-place-holder { height: 0px;}</style>"
                
            }else {
                bodyHtml += "<style>img{max-width: \(CommonConst.SCREEN_W - 20)px;height: auto;}</style><html>"

            }
            
            
            bodyHtml += "<body>\(body)</body></html>"

            // 解析xml
//            guard let data = body.data(using: .utf8) else {
//                return
//            }
//            let par = XMLParser(data: data)
//            par.delegate = self
//            par.parse()
            
        }
    }
    /// body拼接等html
    var bodyHtml:String = ""
    /// 图片等版权出处
    var image_source:String?
    /// 这个图片等分辨率高
    var image:String?
    /// 供分享等url
    var share_url:String?
    /// js数组
    var js = [AnyObject]()
    /// 文字等推荐者头像地址
    var recommenders:[[String: String]]?
    /// 文字等栏目信息
    var section:NewsSectionModel?
    /// css文件
    var css:[String]?
    
    // ***** 以下是特殊情况准提使用 *****
    /// 专题名字
    var theme_name:String?
    /// 作者
    var editor_name:String?
    /// 专题ID
    var theme_id:Int64 = 0
//    var
    
    /// 这个属性自定义的 只是在轮播图的时候要用 根服务器返回数据无关
    var tag: Int = 0;
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
//    // 实现xml的代理方法 ***** 无用的xml解析 *****
//    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
//        print("解析xml出错！")
//    }
//    
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        print("开始ele \(elementName)")
//    }
//    
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        
//        let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        
//        if str != "" {
//            print("xml的元素 \(str)")
//        }
//    }
    
    
    
}
