//
//  ReportFaultDeviceViewController.swift
//  ams
//
//  Created by yangyuan on 2017/7/31.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit

class ConsumingSuccessViewController:UIViewController{
    var succList = [deviceInfo]()
    
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            regClass(_tableView, cell: DeviceInfoViewCell.self);
            
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.sectionHeaderHeight = 40
            return _tableView!;
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
    }

 
    func setup(){

        
        tableView.backgroundColor = .clear
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 0.5
        //        tableView.layer.cornerRadius = 5
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = CuColor.colors.v2_backgroundColor
            self?.tableView.backgroundColor = CuColor.colors.v2_CellWhiteBackgroundColor
        }
        
        self.view.addSubview(tableView)
        setupLayout()
        
    }
    func setupLayout(){
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self.view)
        }

    }

}
//重载tableview相关函数
extension ConsumingSuccessViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return succList.count > 0 ? succList.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: DeviceInfoViewCell.self, indexPath: indexPath);
        cell.bind(data: succList[indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
