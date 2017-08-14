//
//  ReportFaultHistoryViewController.swift
//  ams
//
//  Created by yangyuan on 2017/7/31.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit

class MyAllocationViewController: UIViewController,UITextFieldDelegate{

    var modelInfo: Array<PersonConsumingInfo>?{
        didSet{
            tableView.reloadData()
        }
    }
   
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            
            regClass(_tableView, cell: ConsunmingDetalilInfoViewCell.self);
            
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
extension MyAllocationViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = modelInfo?.count{
            return num
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: ConsunmingDetalilInfoViewCell.self, indexPath: indexPath);
        if let value = modelInfo?[indexPath.row]{
             cell.bind(data: value)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
