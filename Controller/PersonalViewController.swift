//
//  PersonalViewController.swift
//  ams
//
//  Created by coterjiesen on 2017/8/5.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
            regClass(_tableView, cell: PersonalInfoHeadViewCell.self);
            regClass(_tableView, cell: PersonalInfoViewCell.self);
            regClass(_tableView, cell: ExitLoginViewCell.self);
            
            _tableView.delegate = self
            _tableView.dataSource = self
            return _tableView!;
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        self.navigationController?.navigationBar.barTintColor = CuColor.colors.v2_ButtonBackgroundColor
        // 设置导航栏为透明的白色
//        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.hideBottomHairLine()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16),                                                                        NSForegroundColorAttributeName: UIColor.white]
    }
    override func viewWillAppear(_ animated: Bool) {
//        getVersion() 
    }
    
    func getVersion(){
        DataModel.getVersionFromServer(){
           (response: CuValueResponse<String>) -> Void in
            if response.success{
            let infoDic = Bundle.main.infoDictionary
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"] as! String
//            // 获取App的build版本
//            let appBuildVersion = infoDic?["CFBundleVersion"]
//            // 获取App的名称
//            let appName = infoDic?["CFBundleDisplayName"]
                if response.value!.isNewer(than: appVersion){
                    showMsg(self, title: "提示", message: "有新版本，请前往官网下载更新！")
                }else{
                    showMsg(self, title: "提示", message: "已经是最新版本了！")
                }
            }
        }
    }
    func setup(){
        tableView.backgroundColor = CuColor.colors.v2_backgroundColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-49)
        }
    }
    func alert(){
        let alertController = UIAlertController(title: "提示", message:"确定要注销吗？", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title:  "确定", style: UIAlertActionStyle.destructive) { [weak self] (alertAction) in
            if let strongSelf = self
            {
                CuUser.sharedInstance.loginOut()
                let loginViewController = LoginViewController()
                CuClient.sharedInstance.centerViewController!.navigationController?.present(loginViewController, animated: true, completion: nil);
            }
        }
        let alertActionCancel = UIAlertAction(title:  "取消", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(alertAction)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
    }
}
//重载tableview相关函数
extension PersonalViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1,2,1][section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return [SCREEN_HEIGHT/3 - 64,55+SEPARATOR_HEIGHT,65][indexPath.section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.section  {
            if  indexPath.row == 0 {
                let cell = getCell(tableView, cell: PersonalInfoHeadViewCell.self, indexPath: indexPath);
                cell.headView.userNameLabel.text = CuUser.sharedInstance.user?.username
                cell.headView.identityLable.text = CuUser.sharedInstance.user?.group?.components(separatedBy: "/").last
                return cell ;
            }
            else {
                return UITableViewCell()
            }
        }else if 1 == indexPath.section{
            let cell = getCell(tableView, cell: PersonalInfoViewCell.self, indexPath: indexPath);
            if 0 == indexPath.row {
                cell.avatarImageView.image = UIImage(named: "area")
                cell.avatarImageView.backgroundColor = .red
                cell.nameLabel.text = "管理域"
                let path = NSString(string: CuUser.sharedInstance.user!.group!)
                cell.identityLable.text = path.deletingLastPathComponent
            }else if 1 == indexPath.row {
                cell.avatarImageView.image = UIImage(named: "update")
                cell.avatarImageView.backgroundColor = .orange
                cell.nameLabel.text = "版本更新"
                cell.identityLable.text = ">"
            }
            return cell;
        }else{
            let cell = getCell(tableView, cell: ExitLoginViewCell.self, indexPath: indexPath);
            cell.button.tintColor = CuColor.colors.v2_ButtonBackgroundColor
            cell.button.addTarget(self, action: #selector(alert), for: UIControlEvents.touchUpInside)
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = getCell(tableView, cell: PersonalInfoViewCell.self, indexPath: indexPath);
        if indexPath.section == 1 && indexPath.row == 1{
            getVersion()
        }
    }
}
