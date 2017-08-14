//
//   MainTabViewController.swift
//  ams
//
//  Created by yangyuan on 2017/6/8.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class MainTabViewController:UITabBarController
{
    let viewMain = HomeViewController()
    let viewErrorBin = PersonalViewController()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //一共包含了两个视图
        viewMain.title = "主页"
        viewErrorBin.title = "个人中心"
        
        
        //分别声明两个视图控制器
        let main = UINavigationController(rootViewController:viewMain)
        main.tabBarItem.image = UIImage(named:"m2-1")
        //定义tab按钮添加个badge小红点值
//        main.tabBarItem.badgeValue = "6"
        let errorbin = UINavigationController(rootViewController:viewErrorBin)
        errorbin.tabBarItem.image = UIImage(named:"m4-1")
        
        self.viewControllers = [main,errorbin]
        
        //默认选中的是主界面视图
        self.selectedIndex = 0
    }
}
