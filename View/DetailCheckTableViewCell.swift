//
//  DetailCheckTableViewCell.swift
//  ams
//
//  Created by coterjiesen on 2017/5/22.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class DetailCheckTableViewCell :UITableViewCell {
    
    var icon_code = UIImageView()
    let title_lable : UILabel = {
        let label = UILabel()
        label.text = "条码:"
        label.font = v2Font(20)
        return label;
    }()
    let code : UILabel = {
        let label = UILabel()
        label.font = v2Font(16)
        return label;
    }()
    let recordtime : UILabel = {
        let label = UILabel()
        label.text = "时间:"
        label.font = v2Font(16)
        return label;
    }()
    let time_lable = UILabel()
    //装上面的控件
    var content  = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    func setup(){
        self.contentView.addSubview(content)
        content.addSubview(icon_code)
        content.addSubview(title_lable)
        content.addSubview(code)
        content.addSubview(recordtime)
        content.addSubview(time_lable)
        setupLayout()
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.backgroundColor=CuColor.colors.v2_backgroundColor;
            self?.selectedBackgroundView!.backgroundColor = CuColor.colors.v2_backgroundColor
            self?.content.backgroundColor = CuColor.colors.v2_CellWhiteBackgroundColor
        }
    }
    func setupLayout(){
        content.snp.makeConstraints { (make) in	
            make.top.left.bottom.right.equalTo(self.contentView)
        }
        icon_code.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.content).offset(8)
        }
        title_lable.snp.makeConstraints { (make) in
            make.top.equalTo(self.icon_code)
            make.left.equalTo(self.icon_code.snp.right).offset(8)
        }
        code.snp.makeConstraints { (make) in
            make.left.equalTo(self.title_lable.snp.right).offset(8)
            make.top.equalTo(self.title_lable)
        }
        recordtime.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.icon_code)
            make.left.equalTo(self.title_lable)
        }
        time_lable.snp.makeConstraints { (make) in
            make.top.equalTo(self.recordtime)
            make.left.equalTo(self.code)
        }
    }
    func bind(){
        icon_code.image = UIImage(named:"icon_code")
        code.text = "123124434323"
        time_lable.text = "12.22"
    }
}
