//
//  MenuViewController.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/16.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

/// 侧滑菜单控制器
class MenuViewController: UIViewController {

    
    /// 个人头像
    @IBOutlet weak var profileIcon: UIImageView!
    /// 登录和注册label
    @IBOutlet weak var loginLable: UILabel!
    /// 收藏按钮
    @IBOutlet weak var startButton: UIButton!
    /// 通知按钮
    @IBOutlet weak var notificationButton: UIButton!
    /// 设置按钮
    @IBOutlet weak var settingButton: UIButton!
    /// 主题列表
    @IBOutlet weak var themeTableView: UITableView!
    /// 离线按钮
    @IBOutlet weak var outlineButton: UIButton!
    /// 夜间模式按钮
    @IBOutlet weak var nightAndDayButton: UIButton!
    
    /// 主题数据请求模型
    lazy var listModel = ThemeListViewModel()
    
    /// 主题数组模型
    var models:[NewsThemeModel]? {
        didSet{
            
            guard let _ = models else {
                return
            }
            // 刷新tableview
            self.themeTableView.reloadData()
        }
    }
    
    
    /// 外部实例化方法
    class func instance()->MenuViewController{
    
        let nib = UINib(nibName: "MenuViewController", bundle: nil)
        let inst = nib.instantiate(withOwner: nil, options: nil)[0] as! MenuViewController
        
        return inst
    }
    
    
    /// 价值数据
    func loadData() {
        
        listModel.loadThemesList {[weak self] (isSuccess) in
            if isSuccess {
                
               self?.models = self?.listModel.themes
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 加载数据
        loadData()
        // 设置frame
        view.frame = CGRect(x: -CommonConst.SCREEN_W * 0.6, y: 0, width: CommonConst.SCREEN_W * 0.6, height: CommonConst.SCREEN_H)
        // 头像圆角
        profileIcon.layer.cornerRadius = profileIcon.bounds.width * 0.5
        profileIcon.clipsToBounds = true
        print("列表的 frame ：  \(self.themeTableView.frame)")
        print("视图的 frame : \(self.view.frame)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置代理
        themeTableView.delegate = self
        themeTableView.dataSource = self
        themeTableView.isScrollEnabled = true
        themeTableView.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - tableview的代理方法
extension MenuViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("**********选中了\(indexPath.row)***********")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 第一行显示首页 所以要多显示一行
        guard let models = models else {
            return 1
        }
        return models.count + 1

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 第一行显示 主页图标+主页label+小尖头
        if indexPath.section == 0 && indexPath.row == 0 {
        
            let cell = UITableViewCell(style: .default, reuseIdentifier: "themeCellID")
            cell.accessoryType = .disclosureIndicator
            let img = UIImage(named: "Menu_Icon_Home")
            cell.imageView?.image = img
            
            cell.textLabel?.text = "首页"
            cell.textLabel?.textColor = UIColor.white
            
            // cell 的背景颜色
            cell.backgroundColor = UIColor(colorLiteralRed: 33/255.0,
                                           green: 33/255.0,
                                           blue: 33/255.0,
                                           alpha: 1)
            
            // 设置选择的颜色
            // cell的背景图片
            let cellBG = UIView(frame: cell.frame)
            cellBG.backgroundColor =  UIColor(colorLiteralRed: 22/255.0,
                                                        green: 22/255.0,
                                                        blue: 22/255.0,
                                                        alpha: 1)
            cell.selectedBackgroundView = cellBG


            return cell
            
        }else {
            // 他显示  lable+小加号
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "themeCellID")
            cell.accessoryType = .detailButton
            
            guard let models = models else {
                return cell
            }

            let txt = models[indexPath.row - 1].name
            cell.textLabel?.text = txt
            cell.textLabel?.textColor = UIColor.white
            
            // cell 的背景颜色
            cell.backgroundColor = UIColor(colorLiteralRed: 33/255.0,
                                           green: 33/255.0,
                                           blue: 33/255.0,
                                           alpha: 1)
            // 设置选择的颜色
            // cell的背景图片
            let cellBG = UIView(frame: cell.frame)
            cellBG.backgroundColor =  UIColor(colorLiteralRed: 22/255.0,
                                              green: 22/255.0,
                                              blue: 22/255.0,
                                              alpha: 1)
            cell.selectedBackgroundView = cellBG
            
            return cell
        }
    }
    
}
