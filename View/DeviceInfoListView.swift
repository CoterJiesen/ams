//
//  DeviceInfoListView.swift
//  ams
//
//  Created by yangyuan on 2017/6/28.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit


//包装DeviceInfoViewCell

class DeviceInfoListView : UIView{
    
    var data :DataModel? = nil
    fileprivate var _tableView :UITableView!
    var tableView :UITableView{
        get{
            if (nil != _tableView) {
                return _tableView!;
            }
            _tableView = UITableView()
            //注册cell
            regClass(_tableView, cell: DeviceInfoViewCell.self)
            _tableView.delegate = self
            _tableView.dataSource = self
            
            return _tableView!;
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        let closeView = UIView()
        self.backgroundColor = .green
        let closeImageView = UIImageView(image: UIImage(named:"ic_close"))
        let dragImageView = UIImageView(image: UIImage(named:"ic_drag"))
        self.addSubview(tableView)
        self.addSubview(closeView)
        closeView.addSubview(closeImageView)
        closeView.addSubview(dragImageView)
        //添加 拖拽和收起图标
        closeImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(closeView)
            make.centerX.equalTo(closeView).offset(-SCREEN_WIDTH / 4)
        }
        dragImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(closeView)
            make.centerX.equalTo(closeView).offset( SCREEN_WIDTH / 4)
        }
        
        closeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.equalTo(40)
            make.bottom.equalTo(self)
        }
        //view中就包含这个tableview
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.bottom.equalTo(closeView.snp.top)
        }
    }
}

extension DeviceInfoListView:UITableViewDataSource,UITableViewDelegate{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // Return the number of sections.
//        if let count = self.data?.deviceList?.count{
//            return count
//        }
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.data?.deviceList?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: DeviceInfoViewCell.self, indexPath: indexPath);
        cell.bind(data: (data?.deviceList?[indexPath.row])!)
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
