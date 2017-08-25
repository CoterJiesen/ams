//
//  HomeViewController.swift
//  ams
//
//  Created by coterjiesen on 2017/4/26.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController ,UINavigationControllerDelegate{

    var sysInfoview :SysInfoView!
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
//        self.navigationItem.title="中国移动资产管理系统";

        self.navigationController?.delegate = self
        self.setup()
        getUsedInfo() 
        //监听程序即将进入前台运行、进入后台休眠 事 件
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    //hidden navigation
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isShowHomePage = viewController.isKind(of: HomeViewController.self)
        navigationController.setNavigationBarHidden(isShowHomePage, animated: true)
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
    func setup(){
        self.sysInfoview = SysInfoView(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height: (SCREEN_HEIGHT - 44 - 49) / 3))
        self.sysInfoview.prog.progress = 40
        self.view.addSubview(sysInfoview)
//        self.view.addSubview(scrollView)
        self.view.addSubview(menuView)
        self.setupLayout()
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = CuColor.colors.v2_backgroundColor
        }
    }
    func setupLayout(){
//        scrollView.snp.makeConstraints { (make) in
//            make.top.equalTo(64)
//            make.height.equalTo((SCREEN_HEIGHT - 64 - 49 - 18) / 3 + 12)
//            make.left.right.equalTo(self.view)
//        }
        sysInfoview.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.height.equalTo((SCREEN_HEIGHT - 44 - 49) / 3)
            make.left.right.equalTo(self.view)
        }
        menuView.snp.makeConstraints { (make) in
            make.top.equalTo(self.sysInfoview.snp.bottom).offset(6)
            make.bottom.equalTo(self.view).offset(-49-5)
            make.left.right.equalTo(self.view)
        }
    }

}


