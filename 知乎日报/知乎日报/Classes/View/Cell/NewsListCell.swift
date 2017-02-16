//
//  NewsListCell.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit
import Kingfisher

class NewsListCell: UITableViewCell {

    
    @IBOutlet weak var duotuIcon: UILabel!
    /// 新闻缩略图
    @IBOutlet weak var imgView: UIImageView!
    /// 新闻标题
    @IBOutlet weak var newsTile: UILabel!
    
    
    // 列表model
    var Model: NewsCellModel? {
        // 获取模型设置显示
        didSet{
            guard let Model = Model,
                  let images = Model.images
             else {
                
                return
            }
            
            // 多图图表展示
            duotuIcon.isHidden = (Model.multipic == 0)
            
            // 设置图片等缩放格式
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            
            // 有图
            if images.count > 0 {
            
                let url = URL(string: images[0])
                imgView.kf.setImage(with: url,
                                    placeholder: #imageLiteral(resourceName: "Management_Placeholder"),
                                    options: nil,
                                    progressBlock: nil,
                                    completionHandler: nil)

            }
                        
            // 设置title
            newsTile.text = Model.title
            if #available(iOS 8.2, *) {
                newsTile.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
            } else {
                // 更早版本
                newsTile.font = UIFont.boldSystemFont(ofSize: 15)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置UI
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NewsListCell {

    func setupUI() {
        
    }
}
