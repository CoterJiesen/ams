//
//  HomeViewController.swift
//  ams
//
//  Created by coterjiesen on 2017/4/26.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController {

    var sysInfoview = SysInfoView()
//    var scrollView = ScrollView()
    var menuView = MenuView()

    override func viewWillAppear(_ animated: Bool) {
        CuClient.sharedInstance.drawerController?.openDrawerGestureModeMask = .panningCenterView
    }
    override func viewDidAppear(_ animated: Bool) {

    }

    override func viewWillDisappear(_ animated: Bool) {
        CuClient.sharedInstance.drawerController?.openDrawerGestureModeMask = []
        getUsedInfo()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="中国移动资产管理系统";
        self.navigationController?.navigationBar.barTintColor = CuColor.colors.v2_ButtonBackgroundColor
        // 设置导航栏为透明的白色
//        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.hideBottomHairLine()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                                                                        NSForegroundColorAttributeName: UIColor.white]
   
        self.setup()
        getUsedInfo() 
        //监听程序即将进入前台运行、进入后台休眠 事 件
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }



    static var lastLeaveTime = Date()
    func applicationWillEnterForeground(){
        //计算上次离开的时间与当前时间差
        //如果超过2分钟，则自动刷新本页面。
        let interval = -1 * HomeViewController.lastLeaveTime.timeIntervalSinceNow
        if interval > 120 {
          //  self.tableView.mj_header.beginRefreshing()
        }
    }
    func applicationDidEnterBackground(){
        HomeViewController.lastLeaveTime = Date()
    }
    
    func getUsedInfo(){

        DataModel.findAllandUsed(username: CuUser.sharedInstance.username!){
            (response: CuValueResponse<useinfo>) -> Void in
            if response.success {
               if let value = response.value{
                     self.sysInfoview.valueTotalLabel.text = String(value.all!)
                     self.sysInfoview.valueAlocaledLabel.text = String(value.used!)
                     let pro = Int((100*value.used!/value.all!))
                     self.sysInfoview.countAlocolLabel.text = String(pro)
                     self.sysInfoview.prog.setProgress(pro , animated: true)
                }

            }
        }
    }
}

extension HomeViewController{
    func checkLogin(){
        print("home页登录检测")
        self.kvoController.observe(CuUser.sharedInstance, keyPath: "isCheckLogin", options: [.initial , .new]){
            (observe, observer, change) -> Void in
            print("home login检测")
            if false == CuUser.sharedInstance.isLogin{
                    let loginViewController = LoginViewController()
                    CuClient.sharedInstance.centerViewController!.navigationController?.present(loginViewController, animated: true, completion: nil);
            }
        }
    }
    func loadingData(){
 
    }

}
extension HomeViewController{
    //颜色渐变

    func setup(){

        self.sysInfoview.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        self.sysInfoview.prog.progress = 40
//        self.sysInfoview.ac_shadeView(withColorList: [UIColor.red,.blue])
        self.view.addSubview(sysInfoview)
//        self.view.addSubview(scrollView)
        self.view.addSubview(menuView)
        self.setupLayout()
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = CuColor.colors.v2_backgroundColor
        }
//        self.sysInfoview.ac_shadeView(withColorList: [UIColor.red,.blue])
    }
    func setupLayout(){
//        scrollView.snp.makeConstraints { (make) in
//            make.top.equalTo(64)
//            make.height.equalTo((SCREEN_HEIGHT - 64 - 49 - 18) / 3 + 12)
//            make.left.right.equalTo(self.view)
//        }
        sysInfoview.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.height.equalTo((SCREEN_HEIGHT - 64 - 49 - 18) / 3 + 12)
            make.left.right.equalTo(self.view)
        }
        menuView.snp.makeConstraints { (make) in
            make.top.equalTo(self.sysInfoview.snp.bottom).offset(6)
            make.bottom.equalTo(self.view).offset(-49-5)
            make.left.right.equalTo(self.view)
        }
    }

}


