//
//  MenuCell.swift
//  ams
//
//  Created by yangyuan on 2017/6/21.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class BottonImageView: UIView{
    var lable: UILabel?
    var image: UIImageView?
    var button: UIButton?
    override init(frame : CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI(){
        button = UIButton()
        image = UIImageView()
        lable = UILabel()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor;
        self.addSubview(button!)
        self.addSubview(image!)
        self.addSubview(lable!)

        self.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        image!.snp.makeConstraints { (make) in
            make.height.width.equalTo(SCREEN_WIDTH / 6	+ 10)
            make.centerY.equalTo(self).offset(-12)
            make.centerX.equalTo(self)
        }
        lable!.snp.makeConstraints { (make) in
            make.top.equalTo(self.image!.snp.bottom).offset(12)
            make.centerX.equalTo(self)
        }
        button!.snp.makeConstraints{ (	make) in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class MenuView: UIView{
    let heihtMenu = 3 * (SCREEN_WIDTH / 2 - 12) / 4
    let widthMenu = SCREEN_WIDTH / 2 - 12
    
    var consumingView :BottonImageView?
    var reportFaultView :BottonImageView?
    var restitutionView :BottonImageView?
    var reportView :BottonImageView?
    override init(frame : CGRect){
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        self.backgroundColor = UIColor.clear
        consumingView = BottonImageView()
        consumingView?.image?.image = UIImage(named: "s1")
        consumingView?.button?.addTarget(self, action: #selector(clickConsumingDevice), for: .touchUpInside)
        consumingView!.button!.backgroundColor = .white // colorWith255RGB(204, g: 154, b:63)
        consumingView?.lable?.text = "设备领用"
//        consumingView!.lable?.textColor = .white
        reportFaultView = BottonImageView(frame: CGRect(x: 0, y: 0, width: widthMenu, height: heihtMenu))
        reportFaultView?.image?.image = UIImage(named: "s2")
        reportFaultView?.button?.addTarget(self, action: #selector(clickReportFault), for: .touchUpInside)
        reportFaultView!.button!.backgroundColor = .white // colorWith255RGB(99, g: 139, b:146)
        reportFaultView?.lable?.text = "设备报障"
//        reportFaultView!.lable?.textColor = .white
        restitutionView = BottonImageView(frame: CGRect(x: 0, y: 0, width: widthMenu, height: heihtMenu))
        restitutionView?.image?.image = UIImage(named: "s3")
        restitutionView?.button?.addTarget(self, action: #selector(clickRestitution), for: .touchUpInside)
        restitutionView!.button!.backgroundColor = .white //colorWith255RGB(246, g: 96, b:41)
        restitutionView?.lable?.text = "设备返还"
//        restitutionView!.lable?.textColor = .white
        reportView = BottonImageView(frame: CGRect(x: 0, y: 0, width: widthMenu, height: heihtMenu))
        reportView?.image?.image = UIImage(named: "s4")
        reportView?.button?.addTarget(self, action: #selector(clickCheckDevice), for: .touchUpInside)
        reportView!.button!.backgroundColor = .white //colorWith255RGB(181, g: 144, b:246)
        reportView?.lable?.text = "设备盘点"
//        reportView!.lable?.textColor = .white
        
        self.addSubview(consumingView!)
        self.addSubview(reportFaultView!)
        self.addSubview(restitutionView!)
        self.addSubview(reportView!)
        
        setupLayout()
    }
    func click(){
        print("button clicked !")
    }
    func clickConsumingDevice(){
        let viewOutBin = ConsumingDeviceTabController()
        viewOutBin.hidesBottomBarWhenPushed = true
        CuClient.sharedInstance.centerViewController?.navigationController?.pushViewController(viewOutBin, animated: true)
    }
    
    func clickReportFault(){
        let vc = ReportFaultDeviceTabViewController()
        vc.hidesBottomBarWhenPushed = true
        CuClient.sharedInstance.centerViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    func clickRestitution(){
        let vc = RestitutionDeviceTabViewController()
        vc.hidesBottomBarWhenPushed = true
        CuClient.sharedInstance.centerViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    func clickCheckDevice(){
        let vc = CheckDeviceViewController()
        vc.hidesBottomBarWhenPushed = true
        CuClient.sharedInstance.centerViewController?.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    func setupLayout(){

        self.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
        }
        consumingView!.snp.makeConstraints { (make) in
            make.left.top.equalTo(6)
            make.width.equalTo(SCREEN_WIDTH / 2 - 10	)
            make.bottom.equalTo(self.snp.centerY)
        }
        reportFaultView!.snp.makeConstraints { (make) in
            make.top.equalTo(self.consumingView!)
            make.left.equalTo(self.consumingView!.snp.right).offset(6)
            make.width.equalTo(SCREEN_WIDTH / 2 - 10	)
            make.height.equalTo(consumingView!)
        }
        restitutionView!.snp.makeConstraints { (make) in
            make.left.equalTo(self.consumingView!)
            make.top.equalTo(self.consumingView!.snp.bottom).offset(4)
            make.width.equalTo(SCREEN_WIDTH / 2 - 10	)
            make.height.equalTo(consumingView!)
        }
        reportView!.snp.makeConstraints { (make) in
            make.left.equalTo(self.reportFaultView!)
            make.top.equalTo(self.restitutionView!)
            make.width.equalTo(SCREEN_WIDTH / 2 - 10	)
            make.height.equalTo(consumingView!)
        }
    }
}
