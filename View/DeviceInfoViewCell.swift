//
//  DeviceInfoViewCell.swift
//  ams
//
//  Created by yangyuan on 2017/6/27.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class DeviceInfoview: UIView{

    let lableSN : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(11)
        lable.text = "--"
        return lable
    }()
    
    let lableCompany : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(16)
        lable.text = "--"
        return lable
    }()
    
    let lableSeparate : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(13)
        lable.text = "/"
        return lable
    }()
    
    let lableType : UILabel = {
        let lable = UILabel()
        lable.font = v2Font(15)
        lable.text = "--"
        return lable
    }()
    
    let onOffButton = OnOffButton()
    let leftImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        onOffButton.frame = CGRect(origin: .zero, size:CGSize(width: 26,height: 26))
        onOffButton.lineWidth = 2
        onOffButton.ringAlpha = 0.3
        onOffButton.checked = true
        onOffButton.isUserInteractionEnabled = false
        self.addSubview(onOffButton)
        self.addSubview(lableSN)
        self.addSubview(lableCompany)
        self.addSubview(lableType)
        self.addSubview(lableSeparate)
        self.addSubview(leftImage)
        setupLayout()
    }
    func setupLayout(){
        self.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        leftImage.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(10)
            make.bottom.equalTo(-3)
            make.width.lessThanOrEqualTo(55)
        }
        lableCompany.snp.makeConstraints { (make) in
            make.top.equalTo(leftImage)
            make.bottom.equalTo(self.snp.centerY).offset(-1)
            make.left.equalTo(leftImage.snp.right).offset(6)
//            make.width.equalTo(80)
        }
        lableSeparate.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(lableCompany)
            make.left.equalTo(lableCompany.snp.right).offset(3)
            make.width.equalTo(5)
        }
        lableType.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(lableCompany)
            make.width.equalTo(40)
            make.left.equalTo(lableSeparate.snp.right).offset(5)
        }
        lableSN.snp.makeConstraints { (make) in
            make.left.equalTo(lableCompany)
            make.bottom.equalTo(leftImage)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - 80)
        }
        onOffButton.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.centerY.equalTo(leftImage)
        }
    }
}

class DeviceInfoViewCell: UITableViewCell{
    
    var content = DeviceInfoview()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI(){
//        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
//        self.selectionStyle = .none
        self.layer.cornerRadius = 20
        self.contentView.addSubview(content)
        content.leftImage.image = UIImage(named: "L1")
        content.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(2)
            make.left.right.bottom.equalTo(self.contentView)
        }
    }
    func bind(data : deviceInfo){
        content.lableSN.text = data.SN
        if let company = data.vendor{
            content.lableCompany.text = company
            if let imgName =  vendorDic[company]{
                content.leftImage.image = UIImage(named: imgName)
            }
        }
        if let category = data.category {
            content.lableType.text = category
        }
    }
    
}
