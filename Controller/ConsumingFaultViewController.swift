//
//  ReportFaultHistoryViewController.swift
//  ams
//
//  Created by yangyuan on 2017/7/31.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit

class ConsumingFaultViewController:UIViewController,UITextFieldDelegate{
    var failList = [allocfailDevice]()
   
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            
            regClass(_tableView, cell: DeviceInfoWithFaultViewCell.self);
            
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.sectionHeaderHeight = 30
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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background.png")!)
        tableView.backgroundColor =  CuColor.colors.v2_backgroundColor
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 0.5
        self.view.addSubview(tableView)
        setupLayout()
        
    }
    func setupLayout(){
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }

}
//重载tableview相关函数
extension ConsumingFaultViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return failList.count > 0 ? failList.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: DeviceInfoWithFaultViewCell.self, indexPath: indexPath);
        cell.bind(data: failList[indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
