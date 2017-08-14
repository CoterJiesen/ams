//
//  ConsumingHistoryViewCell.swift
//  ams
//
//  Created by yangyuan on 2017/7/28.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit

class ConsumingDeviceInfoview: UIView{
    
    let lableSN : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(11)
        lable.text = "--"
        return lable
    }()
    
    let lableCompany : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(15)
        lable.text = "--"
        return lable
    }()
    
    let lableSeparate : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(15)
        lable.text = "/"
        return lable
    }()
    
    let lableType : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(15)
        lable.text = "--"
        return lable
    }()
    let lableName : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(15)
        lable.text = "--"
        return lable
    }()
    let lableTime : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(15)
        lable.text = "--"
        return lable
    }()
    let leftImage = UIImageView()
    let photoImage = UIImageView()
    let clockImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        photoImage.image = UIImage(named: "head")
        clockImage.image = UIImage(named: "clock")
        self.addSubview(lableSN)
        self.addSubview(lableCompany)
        self.addSubview(lableType)
        self.addSubview(lableSeparate)
        self.addSubview(leftImage)
        self.addSubview(photoImage)
        self.addSubview(clockImage)
        self.addSubview(lableName)
        self.addSubview(lableTime)
        setupLayout()
    }
    func setupLayout(){
        self.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        leftImage.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(55)
        }
        lableCompany.snp.makeConstraints { (make) in
            make.top.equalTo(leftImage)
            make.bottom.equalTo(self.snp.centerY).offset(-1)
            make.left.equalTo(leftImage.snp.right).offset(6)
            make.width.equalTo(40)
        }
        lableSeparate.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(lableCompany)
            make.left.equalTo(lableCompany.snp.right).offset(3)
            make.width.equalTo(5)
        }
        lableType.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(lableCompany)
            make.width.equalTo(40)
            make.left.equalTo(lableSeparate.snp.right).offset(3)
        }
        lableSN.snp.makeConstraints { (make) in
            make.left.equalTo(lableCompany)
            make.bottom.equalTo(leftImage)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - 80)
        }
        lableTime.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(lableCompany)
            make.right.equalTo(-2)
            make.width.equalTo(50)
        }
        clockImage.snp.makeConstraints { (make) in
            make.right.equalTo(lableTime.snp.left).offset(-3)
            make.centerY.equalTo(lableCompany)
            make.width.height.equalTo(15)
        }
        lableName.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(lableCompany)
            make.right.equalTo(clockImage.snp.left).offset(-3)
            make.width.lessThanOrEqualTo(100)
        }
        photoImage.snp.makeConstraints { (make) in
            make.right.equalTo(lableName.snp.left).offset(-3)
            make.centerY.equalTo(lableCompany)
            make.width.height.equalTo(15)
        }
    }
}

class ConsumingHistoryViewCell: UITableViewCell{
    
    var content = ConsumingDeviceInfoview()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI(){
        self.backgroundColor = UIColor.clear
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 20
        self.contentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(2)
            make.left.right.bottom.equalTo(self.contentView)
        }

    }

    func bind(data : allocHistory){
        content.lableSN.text = data.dvInfo.SN
        if let company = data.dvInfo.vendor{
            content.lableCompany.text = company
            if let imgName =  vendorDic[company]{
                content.leftImage.image = UIImage(named: imgName)
            }
        }
        if let category = data.dvInfo.category {
            content.lableType.text = category
        }
        content.lableName.text = data.name.components(separatedBy: "^")[0]
        let t = data.time.components(separatedBy: " ")[0].components(separatedBy: "-")
        if  t.count > 2{
            let time = t[1] + "/" + t[2]
            content.lableTime.text = time
        }
    }
    func bindReportFault(data : allocHistory){
        content.lableSN.text = data.dvInfo.SN
        if let company = data.dvInfo.vendor{
            content.lableCompany.text = company
            if let imgName =  vendorDic[company]{
                content.leftImage.image = UIImage(named: imgName)
            }
        }
        if let category = data.dvInfo.category {
            content.lableType.text = category
        }
        content.lableName.text = ""
        content.photoImage.image = UIImage(named: "")
        let t = data.time.components(separatedBy: " ")[0].components(separatedBy: "-")
        if  t.count > 2{
            let time = t[1] + "/" + t[2]
            content.lableTime.text = time
        }
        
    }
    func bindForCheck(data: deviceInfo){
        content.lableSN.text = data.SN
        content.photoImage.image = UIImage(named: "pd3")
        content.lableTime.text = ""
        content.clockImage.image = UIImage(named: "")
        if let ret = data.ret,( 1 == ret || 2 == ret ){
            if let company = data.vendor ,company != ""{
                content.lableCompany.text = company
                if let imgName =  vendorDic[company]{
                    content.leftImage.image = UIImage(named: imgName)
                }else{
                    content.leftImage.image = UIImage(named: "unkonw")
                }
            }else{
                content.lableCompany.text = "未知"
                content.leftImage.image = UIImage(named: "unkonw")
            }
            if let category = data.category ,category != ""{
                content.lableType.text = category
            }else {
                content.lableType.text = "未知"
            }
            if 1 == ret{
                content.lableName.text = "未盘点此设备"
            }else{
                content.lableName.text = "不在此班组库"
            }
            
        }else if let ret = data.ret, ret == 3{
            content.leftImage.image = UIImage(named: "unkonw")
            content.lableName.text = "此设备未入库"
            content.lableCompany.text = "未知"
            content.lableType.text = "未知"
        }



    }
}
