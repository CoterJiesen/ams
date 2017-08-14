//
//  LeftViewController.swift
//  ams
//
//  Created by coterjiesen on 2017/4/26.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//


import UIKit
import FXBlurView

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var backgroundImageView:UIImageView?
    var frostedView = FXBlurView()
    
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            _tableView.backgroundColor = UIColor.clear
            _tableView.estimatedRowHeight=100;
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
            
            regClass(self.tableView, cell: LeftUserHeadCell.self)
//            regClass(self.tableView, cell: LeftNodeTableViewCell.self)
//            regClass(self.tableView, cell: LeftNotifictionCell.self)
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
            return _tableView!;
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CuColor.colors.v2_backgroundColor;
        
        self.backgroundImageView = UIImageView()
        self.backgroundImageView!.frame = self.view.frame
        self.backgroundImageView!.contentMode = .scaleToFill
        view.addSubview(self.backgroundImageView!)
        
        frostedView.underlyingView = self.backgroundImageView!
        frostedView.isDynamic = false
        frostedView.tintColor = UIColor.black
        frostedView.frame = self.view.frame
        self.view.addSubview(frostedView)
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view);
        }
        
        if CuUser.sharedInstance.isLogin {
            self.getUserInfo(CuUser.sharedInstance.username!)
        }
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            if CuColor.sharedInstance.style == CuColor.CuColorStyleDefault {
                self?.backgroundImageView?.image = UIImage(named: "32.jpg")
            }
            else{
                self?.backgroundImageView?.image = UIImage(named: "12.jpg")
            }
            self?.frostedView.updateAsynchronously(true, completion: nil)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1,1,1][section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1 && indexPath.row == 2)
        {
            return 55+10
        }
        return [180,55+SEPARATOR_HEIGHT,55+SEPARATOR_HEIGHT][indexPath.section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  //      if indexPath.section == 0 {
            if  indexPath.row == 0 {
                let cell = getCell(tableView, cell: LeftUserHeadCell.self, indexPath: indexPath);
                return cell ;
            }
            else {
                return UITableViewCell()
            }
//        }
//        else if (indexPath.section == 1) {
//            if indexPath.row == 1 {
//                let cell = getCell(tableView, cell: LeftNotifictionCell.self, indexPath: indexPath)
//                cell.nodeImageView.image = UIImage.imageUsedTemplateMode("ic_notifications_none")
//                return cell
//            }
//            else {
//                let cell = getCell(tableView, cell: LeftNodeTableViewCell.self, indexPath: indexPath)
//                cell.nodeNameLabel.text = [NSLocalizedString("me"),"",NSLocalizedString("favorites")][indexPath.row]
//                let names = ["ic_face","","ic_turned_in_not"]
//                cell.nodeImageView.image = UIImage.imageUsedTemplateMode(names[indexPath.row])
//                return cell
//            }
//        }
//        else {
//            let cell = getCell(tableView, cell: LeftNodeTableViewCell.self, indexPath: indexPath)
//            cell.nodeNameLabel.text = [NSLocalizedString("nodes"),NSLocalizedString("more")][indexPath.row]
//            let names = ["ic_navigation","ic_settings_input_svideo"]
//            cell.nodeImageView.image = UIImage.imageUsedTemplateMode(names[indexPath.row])
//            return cell
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if !CuUser.sharedInstance.isLogin {
                    let loginViewController = LoginViewController()
                    CuClient.sharedInstance.centerViewController!.navigationController?.present(loginViewController, animated: true, completion: nil);
                }else{
                    print("已经登录,user:\(String(describing: CuUser.sharedInstance.username))")
//                    let memberViewController = MyCenterViewController()
//                    memberViewController.username = CuUser.sharedInstance.username
//                    CuClient.sharedInstance.centerNavigation?.pushViewController(memberViewController, animated: true)
//                    CuClient.sharedInstance.drawerController?.closeDrawer(animated: true, completion: nil)
                }

  

            }
        }
//        else if indexPath.section == 1 {
//            if !CuUser.sharedInstance.isLogin {
//                let loginViewController = LoginViewController()
//                CuClient.sharedInstance.centerNavigation?.present(loginViewController, animated: true, completion: nil);
//                return
//            }
//            if indexPath.row == 0 {
//                let memberViewController = MyCenterViewController()
//                memberViewController.username = CuUser.sharedInstance.username
//                CuClient.sharedInstance.centerNavigation?.pushViewController(memberViewController, animated: true)
//            }
//            else if indexPath.row == 1 {
//                let notificationsViewController = NotificationsViewController()
//                CuClient.sharedInstance.centerNavigation?.pushViewController(notificationsViewController, animated: true)
//            }
//            else if indexPath.row == 2 {
//                let favoritesViewController = FavoritesViewController()
//                CuClient.sharedInstance.centerNavigation?.pushViewController(favoritesViewController, animated: true)
//            }
//            CuClient.sharedInstance.drawerController?.closeDrawer(animated: true, completion: nil)
//            
//        }
//        else if indexPath.section == 2 {
//            if indexPath.row == 0 {
//                let nodesViewController = NodesViewController()
//                CuClient.sharedInstance.centerViewController!.navigationController?.pushViewController(nodesViewController, animated: true)
//            }
//            else if indexPath.row == 1 {
//                let moreViewController = MoreViewController()
//                CuClient.sharedInstance.centerViewController!.navigationController?.pushViewController(moreViewController, animated: true)
//            }
//            CuClient.sharedInstance.drawerController?.closeDrawer(animated: true, completion: nil)
//        }
    }
    
    
    
    // MARK: 获取用户信息
    func getUserInfo(_ userName:String){
        UserModel.getUserInfoByUsername(userName) {(response:CuValueResponse<UserModel>) -> Void in
            if response.success {
                //                self?.tableView.reloadData()
                NSLog("获取用户信息成功")
            }
            else{
                NSLog("获取用户信息失败")
            }
        }
    }
    
}
