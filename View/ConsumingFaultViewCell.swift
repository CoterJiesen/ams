//
//  ConsumingFaultViewCell.swift
//  ams
//
//  Created by yangyuan on 2017/8/4.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit

class ConsumingFaultViewCell: UIView{
    var bottomView = UIView()
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
    var litleWarningImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "pd3")
        return img
    }()
    var titleDetialLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = ""
        label.textColor = .red
        return label
    }()
    let leftImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = UIColor.red.cgColor;

        self.addSubview(lableSN)
        self.addSubview(lableCompany)
        self.addSubview(lableType)
        self.addSubview(lableSeparate)
        self.addSubview(leftImage)
        self.addSubview(bottomView)
        bottomView.addSubview(litleWarningImg)
        bottomView.addSubview(titleDetialLabel)
        setupLayout()
    }
    func setupLayout(){
        self.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.height.equalTo(30)
            make.right.equalTo(-8)
            make.bottom.equalTo(self).offset(-3)
        }
        leftImage.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(10)
            make.bottom.equalTo(self.bottomView.snp.top).offset(-3)
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

        litleWarningImg.snp.makeConstraints { (make) in
            make.left.equalTo(self.bottomView).offset(10)
            make.top.equalTo(self.bottomView).offset(3)
            make.bottom.equalTo(self.bottomView).offset(-3)
            make.width.equalTo(14)
        }
        titleDetialLabel.snp.makeConstraints { (make) in
            make.left.equalTo(litleWarningImg.snp.right).offset(5)
            make.top.equalTo(litleWarningImg)
            make.bottom.equalTo(litleWarningImg)
        }
    }
}

class DeviceInfoWithFaultViewCell: UITableViewCell{
    
    var content = ConsumingFaultViewCell()
    
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
    func bind(data : allocfailDevice){
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
        if let reason = data.reason {
            content.titleDetialLabel.text = reason
        }
    }
    
}
