//
//  PersonInfoViewController.swift
//  ams
//
//  Created by yangyuan on 2017/6/27.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit

import Alamofire
import SwiftyJSON


let username = "huhdw_tianxing"
class PersonInfoViewController : UIViewController {
    let dcloseHeight: CGFloat = 53 //3 space
    let pcloseHeight: CGFloat = 100 //3 space
    let openHeight: CGFloat = 303
    var itemHeight = [CGFloat](repeating: 70.0, count: 3)
    var data :DataModel? = nil
    
    fileprivate var _tableView :UITableView!
    fileprivate var tableView :UITableView{
        get{
            if (nil != _tableView) {
                return _tableView!;
            }
            _tableView = UITableView()
            
            //注册cell
            regClass(_tableView, cell: MenuDeviceInfoViewCell.self)
            regClass(_tableView, cell: MenuPersonInfoViewCell.self)
            regClass(_tableView, cell: UserHeadCell.self)
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
            
            _tableView.backgroundColor = UIColor(patternImage: UIImage(named:"background.png")!)
            
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.rowHeight = UITableViewAutomaticDimension
            return _tableView!;
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.title = "个人中心";
        setup()
        getData()
    }
}

//tableview初始化
extension PersonInfoViewController {
    func setup(){
        itemHeight[1] = dcloseHeight
        itemHeight[2] = pcloseHeight
        self.view.addSubview(tableView)
        setupLayout()
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.tableView.backgroundColor = UIColor(patternImage: UIImage(named:"background.png")!)
        }
    }
    func setupLayout(){
        tableView.snp.makeConstraints{ (make) -> Void in
            make.top.right.left.bottom.equalTo(self.view);
        }
    }
    func getData(){
        DataModel.getClassMonInfo(username: username){
            (response: CuValueResponse<DataModel> ) -> Void in
            if response.success {
                self.data = response.value
                self.tableView.reloadData()
            }else{
                
            }
        }
    }
}

//重载tableview相关函数
extension PersonInfoViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemHeight.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 70
        }
        return itemHeight[indexPath.row]
    }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 1 == indexPath.row{
            guard case let cell as MenuDeviceInfoViewCell = cell else {
                return
            }
            
            if itemHeight[indexPath.row] == dcloseHeight {
                cell.unfold(false, animated: false, completion:nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }else   if 2 == indexPath.row{
            guard case let cell as MenuPersonInfoViewCell = cell else {
                return
            }
            
            if itemHeight[indexPath.row] == pcloseHeight {
                cell.unfold(false, animated: false, completion:nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.row{
            let cell = getCell(tableView, cell: UserHeadCell.self, indexPath: indexPath);
            if let data = self.data{
                cell.bind(name: username, id: data.identify!)
            }
            return cell;
        }else if 1 == indexPath.row{
            let cell = getCell(tableView, cell: MenuDeviceInfoViewCell.self, indexPath: indexPath);
            if let data = self.data{
                cell.bind(data: data)
            }
            return cell;
        }  else if 2 == indexPath.row{
                let cell = getCell(tableView, cell: MenuPersonInfoViewCell.self, indexPath: indexPath);
                if let data = self.data{
                    cell.bind(data: data)
                }
                return cell;
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if 0 != indexPath.row{
            let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
            if cell.isAnimating() {
                return
            }
            
            var duration = 0.0
            var tmpCHeight : CGFloat = 0
            switch indexPath.row {
            case 1:
                tmpCHeight = dcloseHeight
            case 2:
                tmpCHeight = pcloseHeight
            default:
                tmpCHeight = pcloseHeight
            }
            if itemHeight[indexPath.row] == tmpCHeight { // open cell
                itemHeight[indexPath.row] = openHeight
                cell.unfold(true, animated: true, completion: nil)
                duration = 0.5
            } else {// close cell
                itemHeight[indexPath.row] = tmpCHeight
                cell.unfold(false, animated: true, completion: nil)
                duration = 0.8
            }

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                tableView.beginUpdates()
                tableView.endUpdates()
            }, completion: nil)
        }
    }
}
