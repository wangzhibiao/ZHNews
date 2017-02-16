//
//  UINavigationController+Extention.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/2/8.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController?
        {
            return self.visibleViewController
    }
    
    open override var childViewControllerForStatusBarHidden: UIViewController?
        {
            return self.visibleViewController
    }
}
