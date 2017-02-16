//
//  BaseViewController.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import Masonry
import SnapKit


/// 新闻视图的基础是图 可以设置基础公公属性以及全局的事件通知
class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化界面设置代理
        setupUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - 界面初始化
extension BaseViewController {
    
    func setupUI() {
        // 设置尺寸以及背景颜色
//        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.red
        // 加入tableview
//        setupTableView()
    }
    
    // 设置tableview
    func setupTableView() {
//        tableView = UITableView(frame: view.bounds, style: .plain)
////        tableView?.backgroundColor = UIColor.clear
//        view.addSubview(tableView!)
//        
//        tableView?.dataSource = self
//        tableView?.delegate = self
//        
//        // 设置约束
//        tableView?.snp.makeConstraints({ (make) in
//            
//            make.top.equalToSuperview()
//            make.left.bottom.right.equalToSuperview()
//        })
//        
//        
//        // 设置刷新控
//        let header =  MJRefreshStateHeader(refreshingBlock: {
//            
//            self.loadData()
//        })
//        
//        let footer = MJRefreshAutoStateFooter(refreshingBlock: {
//            
//            self.loadData(isPullUp: true)
//        })
//
//        // 隐藏上次刷新时间
//        header?.lastUpdatedTimeLabel.isHidden = true
//        // 设置显示文字
//        header?.setTitle("松开刷新...", for: MJRefreshState.pulling)
//        header?.setTitle("下拉刷新...", for: MJRefreshState.idle)
//        header?.setTitle("努力刷新中...", for: MJRefreshState.refreshing)
//        
//        // 设置顶部和底部刷新
//        tableView?.mj_header = header
//        tableView?.mj_footer = footer
    }
}

// MARK: - 实现tableview的数据源方法
extension BaseViewController: UITableViewDelegate, UITableViewDataSource {

    // 组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // 每组的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // 每组头部是图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}


// MARK: - 上拉和下拉刷新处理
extension BaseViewController {

    
    /// 根据标记来判断做上拉和下拉刷新
    ///
    /// - Parameter isPullUp: true: 上拉  fals 下拉
    func loadData(isPullUp: Bool = false) {
        print("子类实现： true: 上拉  fals 下拉")
    }
}



