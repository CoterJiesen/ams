//
//  PersonalInfoViewCell.swift
//  ams
//
//  Created by coterjiesen on 2017/8/6.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//


import UIKit
import KVOController
import Kingfisher

class PersonalInfoViewCell: UITableViewCell {
    /// 头像
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        return label
    }()
    //identity infomatiom
    var identityLable: UILabel = {
        let label = UILabel()
        label.font = v2Font(12)
        return label
    }()
    
    var formView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup()->Void{

        self.selectionStyle = .none
        formView.layer.borderColor = UIColor.gray.cgColor
        formView.layer.borderWidth = 0.6
        self.contentView.addSubview(formView)
        formView.addSubview(avatarImageView)
        formView.addSubview(nameLabel)
        formView.addSubview(identityLable)
        formView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(formView).offset(6)
            make.centerY.equalTo(formView)
            make.width.height.equalTo(self.avatarImageView.layer.cornerRadius * 2)
        }
        nameLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(avatarImageView)
            make.left.equalTo(self.avatarImageView.snp.right).offset(6)
        }
        identityLable.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImageView)
            make.right.equalTo(self.contentView).offset(-12)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH/2 + 20)
        }
    }
}

class ExitLoginViewCell: UITableViewCell {
    /// 用户名
    var button: UIButton = {
        let button = UIButton()
        button.setTitle("退出当前账户", for: UIControlState.normal)
        button.titleLabel?.font = v2Font(16)
        button.setTitleColor(CuColor.colors.v2_ButtonBackgroundColor, for: UIControlState.normal)

        return button
    }()
    var buttonView = UIView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup()->Void{
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        buttonView.layer.borderWidth = 0.6
        buttonView.layer.borderColor = UIColor.gray.cgColor
        buttonView.backgroundColor = .white
        self.contentView.addSubview(buttonView)
        buttonView.addSubview(button)
        buttonView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(10)
        }
        button.snp.makeConstraints { (make) in
            make.center.equalTo(buttonView)
            make.height.equalTo(20)
        }
    }
}
