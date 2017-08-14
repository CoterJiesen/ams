//
//  ConsunmingDetalilInfoViewCell.swift
//  ams
//
//  Created by coterjiesen on 2017/8/7.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class ConsunmingDetalilInfoViewCell: UITableViewCell{
    
    var leftImg :UIImageView = {
       let img = UIImageView()
        img.layer.cornerRadius = 6
        return img
    }()
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        return label
    }()

    var countLabel : UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI(){
        self.selectionStyle = .none
        
        self.contentView.addSubview(leftImg)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(countLabel)
        
        leftImg.snp.makeConstraints { (mk) in
            mk.left.equalTo(self.contentView).offset(10)
            mk.centerY.equalTo(self.contentView)
            mk.width.height.equalTo(20)
        }
        countLabel.snp.makeConstraints { (mk) in
            mk.right.equalTo(self.contentView).offset(-10)
            mk.centerY.equalTo(self.contentView)
            mk.height.equalTo(leftImg)
            mk.width.equalTo(40)
        }
        titleLabel.snp.makeConstraints { (mk) in
            mk.left.equalTo(self.leftImg.snp.right).offset(6)
            mk.right.equalTo(self.countLabel.snp.left).offset(-6)
            mk.height.equalTo(leftImg)
            mk.center.equalTo(self.contentView)
        }
    }
    
    func bind(data: PersonConsumingInfo){
        leftImg.backgroundColor = data.color
        titleLabel.text = data.name
        countLabel.text = String(data.num)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
