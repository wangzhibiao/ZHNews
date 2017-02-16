//
//  NewsDetialViewController.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/16.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class NewsDetialViewController: UIViewController {

    
    /// 托错了 懒得改 就用imageview也一样
    @IBOutlet weak var statusBarImg: UIImageView!
   
    @IBOutlet weak var topBackView: UIView!
    /// 新闻图片
    @IBOutlet weak var newsImage: UIImageView!
    
    /// 新闻标题
    @IBOutlet weak var newsTitle: UILabel!
    
    /// 图片来源
    @IBOutlet weak var imageSource: UILabel!
    
    /// 展示新闻的webview
    @IBOutlet weak var newsWebView: UIWebView!
    
    /// 新闻底部工具栏
    @IBOutlet weak var toolBarView: UIView!
    
    
    /// 请求数据的模型
    lazy var listModel = HomeListViewModel()
    
    /// 新闻集合数组
    var models:[NewsCellModel]?
    /// 当前的新闻ID
    var newsID:Int64 = 0 {
        didSet{
            
            // 设置id 来查询新闻相信
            listModel.loadNewsDetial(id: newsID) { [weak self] (isSuccess) in
                if !isSuccess{
                    SVProgressHUD.dismiss()
                    return
                }
                
                // 图片
                let url = URL(string: self?.listModel.newsDtital.image ?? "")
                self?.newsImage.kf.setImage(with: url)
                // 来源
                if let sourec = self?.listModel.newsDtital.image_source {
                
                    self?.imageSource.text = "图片: \(sourec)"
                }else {
                    self?.imageSource.text = "图片: 未知来源"
                }
                // 标题
                self?.newsTitle.text = self?.listModel.newsDtital.title
                
                self?.newsWebView.loadHTMLString(self?.listModel.newsDtital.bodyHtml ?? "", baseURL: nil)
                // 取消加载提示图标
                SVProgressHUD.dismiss()
            }
       
        }
    }

    
    /// 外部实例方法
    class func instance() -> NewsDetialViewController {
        
        let nib = UINib(nibName: "NewsDetialViewController", bundle: nil)
        let inst = nib.instantiate(withOwner: nil, options: nil)[0] as! NewsDetialViewController
        
        return inst
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置界面
        setupUI()
        // 监听返回按钮点击通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(backButtonClick),
                                               name: NSNotification.Name(rawValue: DetialViewBackButtonClickNotification),
                                               object: nil)
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
}

// MARK: - 负责工具条点击的通知处理
extension NewsDetialViewController {

    func backButtonClick()  {

        let _ = self.navigationController?.popViewController(animated: true)
        
//        UIApplication.shared.statusBarStyle = .lightContent

    }
}


// MARK: - 设置界面属性
extension NewsDetialViewController {

    func setupUI() {
        // 背景颜色
        view.backgroundColor = UIColor.white
        // 加载提示图标
        SVProgressHUD.show()
        // 设置webview的代理
        newsWebView.scrollView.delegate = self
        newsWebView.delegate = self
        
        self.newsWebView.backgroundColor = UIColor.clear
        self.newsWebView.isOpaque = false
        
        
        // 设置webview的偏移
        self.newsWebView.scrollView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        
    }
}



// MARK: - 实现webview的代理方法
extension NewsDetialViewController: UIScrollViewDelegate,UIWebViewDelegate {

    // 当页面加载完毕 对内部的图片做自适应
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //***** 无用  *****
        // 这里循环100次 可以多点 但是不能少了 否则不能讲所有的图片自适应
//        for i in 0..<50{
//            
//            let JSStr = "document.getElementsByTagName('img')[\(i)].style.width ='100%"
//            
//            self.newsWebView.stringByEvaluatingJavaScript(from: JSStr)
//        }
    }
    
    
    
    // 实现webvview滚动代理控制顶部图片等约束
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == newsWebView.scrollView {
            
            let offsetY = scrollView.contentOffset.y
            
            // 状态栏变色 并且字体颜色改变
            if offsetY > -20 {
                statusBarImg.backgroundColor = UIColor.white
                UIApplication.shared.statusBarStyle = .default
                
            }else{
                statusBarImg.backgroundColor = UIColor.clear
                UIApplication.shared.statusBarStyle = .lightContent
            }
            
         
            if offsetY < -200 {
                scrollView.contentOffset.y = -200
            }
            // 更新约束
            let dealt = 200 + offsetY
            
            var frame = topBackView.frame
            frame.origin.y = (-dealt > 0 ? 0 : -dealt)
            topBackView.frame = frame
            
            print("dealt : \(dealt)")
            if dealt > 180 {
                topBackView.isHidden = true
            }else {
                topBackView.isHidden = false
            }
        }
    }
    
}






