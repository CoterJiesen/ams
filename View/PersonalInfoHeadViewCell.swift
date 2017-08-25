//
//  PersonalInfoView.swift
//  ams
//
//  Created by coterjiesen on 2017/8/5.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit


class PersonalInfoView: UIView{
    
    var vibrancyView: UIVisualEffectView = {
        let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))
        vibrancyView.isUserInteractionEnabled = true
        return vibrancyView
    }()
    /// 头像
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 32
        imageView.image = UIImage(named: "m4")
        return imageView
    }()
    /// 用户名
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "--"
        return label
    }()
    //identity infomatiom
    var identityLable: UILabel = {
        let label = UILabel()
        label.font = v2Font(17)
        label.text = "班主管理员"
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
        self.backgroundColor = UIColor(patternImage: UIImage(named: "32.jpg")!)
        self.addSubview(vibrancyView)	
        self.addSubview(avatarImageView)
        self.addSubview(userNameLabel)
        self.addSubview(identityLable)
        
        setupUILayout()
        vibrancyView.frame = self.frame
    }
    func  setupUILayout(){

        self.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        vibrancyView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        self.avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self).offset(12)
            make.bottom.equalTo(self).offset(-12)
            make.width.height.equalTo(self.avatarImageView.layer.cornerRadius * 2)
        }
        self.userNameLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.avatarImageView).offset(8)
            make.left.equalTo(self.avatarImageView.snp.right).offset(20)
        }
        self.identityLable.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.avatarImageView).offset(-3)
            make.left.equalTo(userNameLabel)
        }
    }
}

class PersonalInfoHeadViewCell: UITableViewCell{
    
    var headView = PersonalInfoView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    func setupUI(){
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
    }
}
