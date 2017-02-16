//
//  NewsRanaerView.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/15.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import Foundation

/// 轮播图
class NewsRanaerView: UIView {

    /// 滚动视图
    @IBOutlet weak var scrollerView: UIScrollView!
    /// 新闻标题
    @IBOutlet weak var newsTitleLabel: UILabel!
    /// 分页控件
    @IBOutlet weak var pageControl: UIPageControl!
    
    // 轮播标题
    lazy var descLable = UILabel()
    
    // 定时器
    var timer: Timer?
    
    // 当前的角标
    var currentIndex: Int = 0;
    
    // 存储轮播图的照片数组
    var imageArray: Array<NewsCellModel>?
    
   
    
    // 数据源
    var model:[NewsCellModel]? {
        
        didSet{
            guard let model = model else {
                return
            }
            
            // 设置轮播 标题 分页
            setupView(model: model)
        }
    }
    
    
    
    /// 外部调用的实例方法
    class func ranaderView() -> NewsRanaerView {
        
        let nib = UINib(nibName: "NewsRanaerView", bundle: nil)
        let av = nib.instantiate(withOwner: nil, options: nil)[0] as! NewsRanaerView
        
        return av
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    deinit {
        // 注销时间定时器
        timer?.invalidate()
    }
}

// MARK: - 设置视图
extension NewsRanaerView: UIScrollViewDelegate {

    func setupView(model: [NewsCellModel]) {
        
        // 轮播图
        setupScrollerView(model: model)
        // 标题
        setupTitle(model: model)
        // 分页
        setupPageControl(model: model)
        
        // 开启定时
        startTimer()
    }
    
    /// 设置轮播视图
    private func setupScrollerView(model: [NewsCellModel]) {
        
        // 先清空轮播图
        for item in scrollerView.subviews{
            item.removeFromSuperview()
        }
        
        // 设置轮播控制器的属性
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.isUserInteractionEnabled = true
        scrollerView.bounces = false
        scrollerView.isPagingEnabled = true
        scrollerView.isScrollEnabled = true
        // 设置代理
        scrollerView.delegate = self
        
        // 设置滚动视图的contentsize
        self.scrollerView.contentSize = CGSize(width: CommonConst.SCREEN_W * 3, height: CommonConst.RENDER_H)
        
        // 设置显示中间
        self.scrollerView.contentOffset = CGPoint(x: CommonConst.SCREEN_W, y: 0);
        
        // 初始化属性数组
        self.imageArray = []
        
        // 创建三个图片来展示轮播图
        for i in 0..<3 {
            // 创建图片来显示第一个轮播图
            let frame = CGRect(x: CommonConst.SCREEN_W * CGFloat(i),
                               y: 0,
                               width: CommonConst.SCREEN_W,
                               height: CommonConst.RENDER_H)
            
            let currentImageView = UIImageView(frame: frame)
            currentImageView.isUserInteractionEnabled = true
            currentImageView.contentMode = UIViewContentMode.scaleAspectFill
            self.scrollerView.addSubview(currentImageView)
            
            // 设置tag 来确认获取的图片信息
            currentImageView.tag = (model.count - 1 + i) % model.count
            model[currentImageView.tag].tag = currentImageView.tag
            
            // 增加点击手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageClick(tap:)))
            currentImageView.addGestureRecognizer(tap)
            
            // 加入属性数组 以后都从这里取数据
            self.imageArray?.append(model[currentImageView.tag])
            // 加入标题
            self.descLable.sizeToFit()
            self.descLable.isUserInteractionEnabled = true
            self.descLable.textColor = UIColor.white
            self.descLable.font = UIFont.boldSystemFont(ofSize: 18)
            self.descLable.numberOfLines = 0
            
            self.addSubview(self.descLable)
            // 约束
            self.descLable.snp.makeConstraints({ (make) in
                make.leftMargin.equalTo(10)
                make.rightMargin.equalTo(10)
                make.bottomMargin.greaterThanOrEqualTo(-30)
            })


            // 设置图片和标题
            setupImageAndTitle(tagImage: currentImageView)
        }
    }
    
    
    // 设置图片和标题
    func setupImageAndTitle(tagImage: UIImageView) {
        // 设置图
        let url = URL(string: model![tagImage.tag].image!)
        tagImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Management_Placeholder"))

        // 设置标题
        self.descLable.text = model![tagImage.tag].title
//        print("title: \(model![tagImage.tag].title)  currentindex: \(self.currentIndex)")
//        print("label : \(self.descLable)")
        
    }
    
    
    /// 设置标题
    private func setupTitle(model: [NewsCellModel]){
    
        // *** 将标题添加到轮播的图片中 ***
        newsTitleLabel.isHidden = true
    }
    
    // 分页控件
    private func setupPageControl(model: [NewsCellModel]){
    
        pageControl.numberOfPages = model.count
        pageControl.currentPage = 0
    }
    
    
    // 停止拖动后 开启自动轮播
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 复位
        resetScrollerView()
    }
    
    // 设置的contentoffset后或屌用这个方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 复位
        resetScrollerView()
    }
    
    
    // 结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 自动轮播
        startTimer()
    }
    
    // 手动拖动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 停止定时器
        stopTimer()
    }
    
    
    // scrollerview的复位方法
    func resetScrollerView() {
        
        var flag = 0
        // 判断左右滑动
        if scrollerView.contentOffset.x > CommonConst.SCREEN_W {
            flag = 1
        }else if scrollerView.contentOffset.x == 0 {
        
            flag = -1
        }else {
            
            return
        }
        
        // 设置图片
        // 判断当前滚动的角标
        for (i,cellModel) in self.imageArray!.enumerated() {
            
            self.currentIndex = cellModel.tag + flag
            
            // 如果小于0 就显示最后一个
            if self.currentIndex < 0 {
                self.currentIndex = (self.model?.count)! - 1
            }else if self.currentIndex >= (self.model?.count)! {
                self.currentIndex = 0
            }
            
            // 赋值属性
            cellModel.tag = self.currentIndex
            let imgView = self.scrollerView.subviews[i] as! UIImageView
            imgView.tag = self.currentIndex
            
            // 设置照片
            setupImageAndTitle(tagImage: imgView)
            
        }
        
        // 设置分页
        self.pageControl.currentPage = (self.imageArray?[1].tag)!
        
        // 复位位置
        self.scrollerView.contentOffset = CGPoint(x: CommonConst.SCREEN_W, y: 0)
    }
    
    
    // 图片点击方法
    func imageClick(tap: UITapGestureRecognizer) {
        
        let dealID = self.imageArray?[self.currentIndex].id
        
        // 发通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RanderViewDidClickNotification), object: nil, userInfo: ["newsID":dealID])
    }
    
    
    // 开启定时器
    func startTimer() {
        
        // 判断是否需要开启
        if (self.model?.count)! <= 1 {
            return
        }
        
        if (timer != nil) {
            timer?.invalidate()
        }
        
        // 开启timer
        timer = Timer(timeInterval: 3, target: self, selector: #selector(changeView), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    // 关闭定时器
    func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    // 定时器轮播方法
    func changeView() {
    
        let offset = CGPoint(x: CommonConst.SCREEN_W * 2.0, y: 0)
        self.scrollerView.setContentOffset(offset, animated: true)
        
        
        
        // 移动contenoffset
//        var currentOffset = scrollerView.contentOffset
//        currentOffset.x += CommonConst.SCREEN_W
//        
//        // 如果是最后一张 分页控件显示第一个
//        if currentOffset.x == CommonConst.SCREEN_W * CGFloat(model!.count) {
//            // 设置滚动视图的offset和分页
//            pageControl.currentPage = 0
//            scrollerView.contentOffset = CGPoint.zero
//
//        }else {
//            // 设置分页
//            let page = Int(currentOffset.x / CommonConst.SCREEN_W + 0.5)
//            pageControl.currentPage = page
//            
//        }
//        
//        // 如果已经是备用的图片了 那么手动更改分页空间
//        if currentOffset.x > CommonConst.SCREEN_W * CGFloat(model!.count) {
//            // 现在就应该显示分页的第二页了
//            pageControl.currentPage = 1
//            // 跳过第一页链接第二页
//            let point = CGPoint(x: CommonConst.SCREEN_W, y: 0)
//            scrollerView.setContentOffset(point, animated: true)
//        }else {
//            scrollerView.setContentOffset(currentOffset, animated: true)
//
//        }
    }
}






