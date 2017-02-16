//
//  HomeViewController.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

/// 主页
class HomeViewController: BaseViewController {

    // 新闻cell 的ID
    fileprivate let cellID = "listCellID"
    // 轮播图等cell 
    fileprivate let renderCellID = "renderCellID"
    // 顶部标题视图
    lazy var navTitleView = NewsTitleView.titleView()
    // 顶部轮播是图
    lazy var scrView = NewsRanaerView.ranaderView()
    /// 数据展示的tableview
    lazy var tableView = UITableView()
    // 新闻celllist 的数据模型
    lazy var listModel = HomeListViewModel()
    
    
    lazy var btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 获取最新数据
        loadData()
        // 自定义UI
        setupUI()
        
        // 测试毛玻璃效果
        //let effect = UIBlurEffect(style: .extraLight)
        //let vv = UIVisualEffectView(effect: effect)
        //vv.frame = view.frame
        //view.addSubview(vv)
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(randerViewDidClickNotification(notification:)), name: NSNotification.Name(rawValue: RanderViewDidClickNotification), object: nil);
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 给导航控制重新写了扩展 还是i 不好使  妈蛋！
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: -轮播是图通知点击
    func randerViewDidClickNotification(notification: NSNotification){
        
        let newID = notification.userInfo?["newsID"];
        
        let dealVC = NewsDetialViewController.instance()
        dealVC.newsID = newID as! Int64
        
        navigationController?.pushViewController(dealVC, animated: true)
        
    }
}

// MARK: - 初始化UI
extension HomeViewController {

    override func setupUI() {
        
        super.setupUI()
        
        // 设置表格视图
        setupTableView()
        // 设置顶部滚动是图
        setupScrollerView()
        // 设置导航栏
        setupNavigationBar()
    }
    
    
    
    // 设置tableview
    override func setupTableView() {

        tableView = UITableView(frame: view.frame, style: .plain)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // 设置约束
        tableView.snp.makeConstraints({ (make) in
            
            make.top.equalTo(0)
            make.left.bottom.right.equalToSuperview()
        })
        
        
        // 设置刷新控
        let header =  MJRefreshStateHeader(refreshingBlock: {
            
            self.loadData()
        })
        
        let footer = MJRefreshAutoFooter(refreshingBlock: {
            
            self.loadData(isPullUp: true)
        })
        
        // 隐藏上次刷新时间
        header?.lastUpdatedTimeLabel.isHidden = true
        // 设置显示文字
        header?.setTitle("松开刷新...", for: MJRefreshState.pulling)
        header?.setTitle("下拉刷新...", for: MJRefreshState.idle)
        header?.setTitle("努力刷新中...", for: MJRefreshState.refreshing)
        
        // 设置顶部和底部刷新
        tableView.mj_header = header
        tableView.mj_footer = footer
        
        
        
        // cell 的xib
        let listCellNib = UINib(nibName: "NewsListCell", bundle: nil)
        // 注册cell
        tableView.register(listCellNib, forCellReuseIdentifier: cellID)
        
        // 分割线
        tableView.separatorStyle = .none
        // 滚动条
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        // 设置tableview的偏移
        tableView.contentInset = UIEdgeInsets(top: CommonConst.RENDER_H,
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
        let offsetPoint = CGPoint(x: 0, y: -(CommonConst.RENDER_H))
        tableView.setContentOffset(offsetPoint, animated: true)

    }

    
    
    // 设置导航栏出事状态
    func  setupNavigationBar() {
        
        // 因此系统导航栏
        self.navigationController?.navigationBar.isHidden = true
        // 导航栏系统颜色
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // 初始化导航栏的frame
        navTitleView.frame = CGRect(x: 0, y: 0,
                                    width: CommonConst.SCREEN_W,
                                    height: CommonConst.NAVIGATION_H)
        // 设置显示内容
        navTitleView.titleLabel.text = "今日新闻"
        navTitleView.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        navTitleView.titleLabel.textColor = UIColor.white
        navTitleView.backgroundColor = UIColor.clear
        
        // 隐藏刷新控件
        navTitleView.flashIcon.isHidden = true
        
        view.addSubview(navTitleView)
    }
    
    /// 设置滚动视图
    func setupScrollerView(){
        
        // 加入轮播图
        view.addSubview(scrView)
        
        // 设置约束
        scrView.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(CommonConst.RENDER_H)
//            make.bottom.equalTo(tableView.snp_top)
            
        }
    }
    
    
    // 实现父类方法做上拉下拉刷新
    override func loadData(isPullUp: Bool = false) {
        if isPullUp { // 上拉
            print("********上拉刷新**********")
            var dataStr = ""
            // 获取日期
            if listModel.otherNews.count > 0 {
                // 获取之前的消息
                dataStr = (listModel.otherNews.last?.date)!
            
            }else {
                // 获取昨天的消息
                dataStr = (listModel.todayNews.last?.date)!
            }
            // 开始请求该日期之前的数据
            listModel.loadBefore(dataStr: dataStr, completion: {  [weak self] (flag) in
                if flag {
                    // 刷新列表
                    self?.tableView.reloadData()
                    // 更高刷新标记
                    self?.tableView.mj_footer.endRefreshing()
                }
            })
            
        }else {// 下拉
            print("********下拉刷新**********")
            // 获取数据
            listModel.loadNews { [weak self] (flag) in
                if flag {
                    // 刷新列表
                    self?.tableView.reloadData()
                    // 更高刷新标记
                    self?.tableView.mj_header.endRefreshing()
                }
            }
        }
    }
}


// MARK: - 设置顶部轮播图
extension HomeViewController{

    func setupRenderView() {
        
        
    }
}






// MARK: - 监听表格滚动 控制状态栏颜色 以及轮播图的高度
extension HomeViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let offsetY  = scrollView.contentOffset.y
        let offsetH  = CommonConst.RENDER_H + offsetY - 20
        
        print("*****TableView滚动**** offserY: \(offsetY) ---- offsetH: \(offsetH)")

        
        if offsetH <= 0 {
            
            navTitleView.statusBarView.backgroundColor = UIColor.clear
        } else {
            
            let min = offsetH/(CommonConst.RENDER_H-64) < 1 ? offsetH / (CommonConst.RENDER_H-64) : 1
            
            navTitleView.statusBarView.backgroundColor = UIColor(colorLiteralRed: 121/255.0,
                                                                 green: 213/255.0,
                                                                 blue: 248/255.0,
                                                                 alpha: Float(min))
            navTitleView.backgroundColor = UIColor(colorLiteralRed: 121/255.0,
                                                  green: 213/255.0,
                                                  blue: 248/255.0,
                                                  alpha: Float(min))
        }

        
        var height = (CommonConst.RENDER_H - offsetH) < 0 ? 0 : (CommonConst.RENDER_H - offsetH)
        
//        scrView.translatesAutoresizingMaskIntoConstraints = false
//        scrView.snp.updateConstraints { (make) in
//            print("轮播高度: \(height)")
//
//            make.height.equalTo(height)
//            view.layoutIfNeeded()
//        }
        
        
        
        
        
        // 动态设置tableview的contentInset
        if height > 200 {
            height = 200

        }else if height <= 20 {
            height = 20
            self.scrView.isHidden = true
        }else {
            self.scrView.isHidden = false
        }
        
        tableView.contentInset = UIEdgeInsets(top: height,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
    
        print("height  \(height)")
        var frame = scrView.frame
        frame.origin.y = (-offsetH > 0 ? 0 : -offsetH)
//        frame.origin.y = -offsetH
//        frame.size.height = height;
        scrView.frame = frame
        

        // 根据标题栏的透明度来确认表格的offset
        if navTitleView.backgroundColor?.cgColor.alpha == 1.0 {
        
            // 当地一个section即将滚出屏幕的时候 设置标题栏的颜色
            guard let stories = listModel.todayNews.last?.stories else {
                return
            }
            let roewh:CGFloat = 80
            let count = CGFloat(stories.count)
            
            if offsetY >= (roewh * count - 20) {
            
                navTitleView.statusBarView.alpha = 1
                navTitleView.backgroundColor = UIColor.clear
                navTitleView.titleLabel.text = ""
                
            }else {
                navTitleView.titleLabel.text = "今日热闻"
            }
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: CommonConst.RENDER_H,
                                                  left: 0,
                                                  bottom: 0,
                                                  right: 0)
            navTitleView.statusBarView.alpha = 0
            navTitleView.titleLabel.text = "今日热闻"

        }
    }
}

// MARK: - 一些公共方法
extension HomeViewController {

    /// 根据id 来返回包含这个id的新闻模型数组
    ///
    /// - Parameter withID: 新闻id
    /// - Returns: id的数组
    func getModelList(withID: Int64) -> [NewsCellModel]? {
        
        // 从今天的新闻中查找
        if let model = listModel.todayNews.last?.stories {
        
            // 便利数组
            for m in model {
                
                if m.id == withID {
                    
                    // 查询到直接返回该数组
                    return model
                }
            }
        }
        
        // 从其他天的新闻中找
        if listModel.otherNews.count < 1 {
            // 没有其他的新闻返回nil
            return nil
        }
        // 便利其他新闻
        for m in listModel.otherNews {
        
            if let model = m.stories {
                // 便利数组
                for m in model {
                    
                    if m.id == withID {
                        
                        return model
                    }
                }
            }
        }
        // 没有查询到返回nil
        return nil
    }
}


// MARK: - 重写父类的tableview数据源方法
extension HomeViewController {
    
    // 监听视图滚动到顶部方法 设置inset
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        
        // 设置inset
        tableView.contentInset = UIEdgeInsets(top: CommonConst.RENDER_H,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        
        return true
    }
    
    // 新闻详情点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 新闻详情控制器
        let detialView = NewsDetialViewController.instance()
        
        // 当前新闻的ID
        var id:Int64 = 0
        
        if indexPath.section == 0 {
            // 从今天新闻的数组中找
            guard let models = listModel.todayNews[0].stories else {
                return
            }
            
            id = models[indexPath.row].id
            
        }else {
        
            // 从其他天的新闻找
            guard let models = listModel.otherNews[indexPath.section - 1].stories else {
                return
            }
            
            id = models[indexPath.row].id
        }

        // 获取数组
        let models = getModelList(withID: id)
        
        // 赋值属性
        detialView.newsID = id
        detialView.models = models
        
        // 跳转
        navigationController?.pushViewController(detialView, animated: true)
    }
    
    
    
    // 分组数
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 返回值+1 如果没有过网信息 那么就只显示当天的信息
        return listModel.otherNews.count + 1
    }
    
    // 每组cell数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 第1组 显示当天的信息
        if  section == 0 {
            
            // 返回今天的数据条数
            guard let model = listModel.todayNews.last?.stories else {
                return 0
            }
            return model.count
            
        }else {
            
            // 其他天的数据
            let list = listModel.otherNews[section - 1]
            return (list.stories?.count)!
        }
    }
    
    
    // cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 轮播图
        if indexPath.section == 0 && indexPath.row == 0 {
        
            // 设置数据
            scrView.model = listModel.topNews
        }
        
        // 展示普通新闻
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsListCell
        
        // 判断section  第一个section的cell 是今天的新闻 其他的是以前的新闻
        if indexPath.section == 0 {
            // 设置属性
            cell.Model = listModel.todayNews[indexPath.section].stories?[indexPath.row]
        }else {
            // 显示其他天的新闻
            guard let model = listModel.otherNews[indexPath.section - 1].stories else {
                return cell
            }
            
            // 设置数据源
            cell.Model = model[indexPath.row]
        }
        
        // cell 的选中状态
        cell.selectionStyle = .none
        return cell
    }
    
    
    // 每组的头部视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        // 判断是否有其他提起的新闻
        if listModel.otherNews.count <= 0{
            return nil
        }
        
        // 返回的视图
        let v = UIView(frame: CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: CGFloat(44)))
        let lable = UILabel()
        // 获取日期
        let dateStr = listModel.otherNews[section - 1].date
        let date = dateStr?.ZHDate ?? Date()
        lable.text = date.ZHLocalDateStr
        lable.sizeToFit()
        lable.frame = v.frame
        
        // 设置属性和背景颜色
        lable.textAlignment = .center
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor = UIColor.white
        v.backgroundColor = UIColor(colorLiteralRed: 121/255.0, green: 213/255.0, blue: 249/255.0, alpha: 1)
        
        v.addSubview(lable)
        return v
    }
    
    // 给第一行的轮播图设置高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    // 第一组头部放轮播图要改尺寸
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        // 第一组不现实头部视图
        if section == 0 {
            return 0
        }else {
            return 44
        }
    }
}









