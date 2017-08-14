//
//  InventoryOverageViewController.swift
//  ams
//
//  Created by yangyuan on 2017/8/2.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

//盘点结果视图控制器
class InventoryOverageViewController: UIViewController{
    var checkinfo :checkDeviceInfo?
    let txtFieldHeight = 40
    let checkInfoView = CheckUnusualView()
//    var inBinButton : UIButton = {
//       let button = UIButton()
//        button.setTitle("重新入库", for: UIControlState())
//        button.titleLabel!.font = v2Font(20)
//        button.layer.cornerRadius = 3;
//        button.layer.borderWidth = 1
//        button.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
//        button.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor;
//        return button
//    }()
//    let buttonView = UIView()
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            //            _tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
            
            regClass(_tableView, cell: ConsumingHistoryViewCell.self);
            
            _tableView.delegate = self
            _tableView.dataSource = self
            return _tableView!;
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        checkInfoView.topView.backgroundColor = UIColor.orange
        checkInfoView.bottomView.backgroundColor = UIColor.gray
        self.view.addSubview(checkInfoView)
        self.view.addSubview(tableView)
//        self.view.addSubview(buttonView)
//        buttonView.addSubview(inBinButton)
        setupLayout()
    }
    func setupLayout(){
        checkInfoView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(64)
            make.height.equalTo(SCREEN_HEIGHT/2)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(checkInfoView.snp.bottom)
//            make.bottom.equalTo(buttonView.snp.top)
            make.bottom.equalTo(self.view)
        }
//        buttonView.snp.makeConstraints { (make) in
//            make.bottom.left.right.equalTo(self.view)
//            make.height.equalTo(txtFieldHeight + 20)
//            
//        }
//        inBinButton.snp.makeConstraints { (make) in
//            make.left.equalTo(self.buttonView).offset(10)
//            make.right.equalTo(self.buttonView).offset(-10)
//            make.top.equalTo(self.buttonView).offset(10)
//            make.bottom.equalTo(self.buttonView).offset(-10)
//        }
    }
}
//重载tableview相关函数
extension InventoryOverageViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = checkinfo?.dvInfoList?.count{
            return num
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: ConsumingHistoryViewCell.self, indexPath: indexPath);
        if let value = checkinfo?.dvInfoList?[indexPath.row]{
            cell.bindForCheck(data: value)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
