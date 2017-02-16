//
//  RootViewController.swift
//  左右侧滑菜单测试
//
//  Created by 王小帅 on 2017/1/17.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

/// 左右侧滑菜单控制器
class RootViewController: UIViewController {
    
    
    /// 主视图控制器
    var mainVC:UIViewController?
    
    /// 左边是图控制器
    var leftVC:UIViewController?
    
    /// 右边是图控制器 暂时没有做 先不开放
    var rightVC:UIViewController?
    
    /// 互动手势
    var panGest:UIPanGestureRecognizer?
    /// 主页的这招button 用来监听点击返回的手势
    var maskButton:UIButton?
    
    
    static let shared = RootViewController()
    class func instance(m:UIViewController, l:UIViewController)-> RootViewController{
    
        // 获取单例 赋值属性
        let root = RootViewController.shared
        root.mainVC = m
        root.leftVC = l

        // 加入视图同时将视图的控制器添加进来 否则在子视图调用push方法等时候 不能正确执行
        root.view.addSubview(l.view)
        root.addChildViewController(l)
        root.view.addSubview(m.view)
        root.addChildViewController(m)
        
        // 设置滑动手势
        let panGest = UIPanGestureRecognizer(target: root, action: #selector(reconizerHandle(recognizer:)))
        panGest.minimumNumberOfTouches = 1
        panGest.maximumNumberOfTouches = 1
        root.mainVC?.view.addGestureRecognizer(panGest)
        
        return root
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册通知 监听主页左上角菜单栏点击
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openMeun),
                                               name: NSNotification.Name(rawValue: MenuButtonClickNotification),
                                                object: nil)
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 初始位置
    var startX:CGFloat = 0.0
    var startY:CGFloat = 0.0
    // 左边是图中心点
    var leftCenter:CGPoint = CGPoint.zero
    // 主页中心点
    var mainCenter:CGPoint = CGPoint.zero
    
    
    /// 打开菜单
    func openMeun() {
        // 左侧视图的中心点
        leftCenter = self.leftVC?.view.center ?? CGPoint.zero
        // 主页中心点
        mainCenter = self.mainVC?.view.center ?? CGPoint.zero
        
        // 偏移量
        let delatX:CGFloat = view.bounds.width * 0.6
        
        // 动画设置
        UIView.animate(withDuration: 0.2,
                       animations: {
                        
            // 分别对主页和菜单页做位移
            self.mainVC?.view.center = CGPoint(x: (self.mainCenter.x + delatX),
                                               y: self.mainCenter.y)
            self.leftVC?.view.center = CGPoint(x: (self.leftCenter.x + delatX),
                                               y: self.leftCenter.y)
                        
        }) { (bool) in
            // 动画完成 添加遮罩
            self.addMainMask()
        }
    }
    
    
    /// 关闭菜单
    func closeMenu() {
        // 左侧视图的中心点
        leftCenter = self.leftVC?.view.center ?? CGPoint.zero
        // 主页中心点
        mainCenter = self.mainVC?.view.center ?? CGPoint.zero
        // 原始中心点
        let orgCenter = CGPoint(x: CGFloat(CommonConst.SCREEN_W * 0.5),
                                y: CGFloat(CommonConst.SCREEN_H * 0.5))
        
        // 偏移量
        let delatX:CGFloat = mainCenter.x - orgCenter.x
        
        // 动画设置
        UIView.animate(withDuration: 0.2,
                       animations: {
                        
                        // 分别对主页和菜单页做位移
                        self.mainVC?.view.center = CGPoint(x: orgCenter.x,
                                                           y: orgCenter.y)
                        self.leftVC?.view.center = CGPoint(x: (self.leftCenter.x - delatX),
                                                           y: self.leftCenter.y)
                        
        }) { (bool) in
            // 动画完成 移除遮罩
            self.removeMainMask()
        }

    }
    
    
    /// 加入主页对这招
    func addMainMask() {
        
        let frame = CGRect(x: 0, y: 0, width: CommonConst.SCREEN_W, height: CommonConst.SCREEN_H)
        maskButton = UIButton(frame: frame)
        maskButton?.addTarget(self, action: #selector(maskBtnClick(btn:)), for: .touchUpInside)
        self.mainVC?.view.addSubview(maskButton!)
            
    }
    
    /// 移除主页遮罩
    func removeMainMask() {
        guard let _ = maskButton else {
            return
        }
        
        maskButton?.removeFromSuperview()
        maskButton = nil
    }
    
    
    /// 遮罩按钮点击
    func maskBtnClick(btn: UIButton) {
        closeMenu()
    }
    
    
    /// 拖动监听
    func reconizerHandle(recognizer: UIPanGestureRecognizer) {
        // 主视图和左侧视图 拖动监听
        let targatView = self.mainVC?.view
        let leftView = self.leftVC?.view
        
        // 获取被拖动的view在当前view中的坐标点
        let transPoint = recognizer.translation(in: recognizer.view)
        
        // 对当前状态进行判断对不同状态做处理比如判断拖动位置并加入动画处理
        if recognizer.state == UIGestureRecognizerState.began {
            // 如果事件刚刚开始 那么记录下起始点
            startX = targatView?.center.x ?? 0
            startY = targatView?.center.y ?? 0
            
            leftCenter = (leftView?.center)!
        }
        
        // 事件进行时
        if recognizer.state == UIGestureRecognizerState.changed {
            
            var delatX:CGFloat = startX + transPoint.x
            // 因为不能在Y轴拖动 所以y 永远是0
            let delatY:CGFloat = startY
            // 左侧是图的中心偏移
            var leftX:CGFloat = delatX - startX
            
            // 判断位置 加入动画
            if delatX < view.bounds.width / 2 {
                delatX = view.bounds.width / 2.0

            }else if delatX >= view.bounds.width * 1.1 {
                delatX = view.bounds.width * 1.1
                // 当到达限制的时候 偏移也要限制
                leftX = delatX - startX
            }
            
            // 偏移是图
            targatView?.center = CGPoint(x: delatX, y: delatY)
            leftView?.center = CGPoint(x: leftCenter.x + leftX, y: leftCenter.y)
            
        }
        
        
        // 如果用户取消或者停止拖拽 要做判断 确认视图的位置
        if recognizer.state == UIGestureRecognizerState.ended || recognizer.state == UIGestureRecognizerState.cancelled {
            
            var endX:CGFloat = (targatView?.center.x)!
            
            // 判断位置 做动画悬停
            if (endX - startX) <= view.bounds.width / 3.0 {
                // 拖动小于屏幕宽度的三分之一 就回到原位
                endX = view.bounds.width / 2.0
                // 移除遮罩
                removeMainMask()
            }else {
                // 大于的话  就停在屏幕宽度的三分之二处
                endX = view.bounds.width * 1.1
                // 加入遮罩
                addMainMask()
            }
            
            // 动画停留
            UIView.animate(withDuration: 0.2, animations: {
                
                targatView?.center = CGPoint(x: endX, y: self.startY)
                
                leftView?.center = CGPoint(x: self.leftCenter.x + endX - self.startX, y: self.leftCenter.y)

            })
        }
    }
}
