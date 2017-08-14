//
//  HomeTableViewRecordsCell.swift
//  ams
//
//  Created by coterjiesen on 2017/5/19.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class HomeTableViewRecordsCell :UITableViewCell{
    
    //盘点记录
    let icon_Img = UIImageView()
    let icon_more = UIImageView()
    let title_lable : UILabel = {
        let label = UILabel()
        label.font = v2Font(20)
        return label;
    }()
    let totalnum : UILabel = {
        let label = UILabel()
        label.text = "总数:"
        label.font = v2Font(16)
        return label;
    }()
    let totalnum_v = UILabel()
    let recordnum : UILabel = {
        let label = UILabel()
        label.text = "记录:"
        label.font = v2Font(16)
        return label;
    }()
    let recordnum_v = UILabel()
    let time_lable = UILabel()
    
    /// 装上面定义的那些元素的容器
    var contentPanel:UIView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder :aDecoder)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    func setup(){
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        contentPanel.layer.cornerRadius = 5
        
        contentPanel.addSubview(icon_Img)
        contentPanel.addSubview(icon_more)
        contentPanel.addSubview(title_lable)
        contentPanel.addSubview(totalnum)
        contentPanel.addSubview(totalnum_v)
        contentPanel.addSubview(recordnum)
        contentPanel.addSubview(recordnum_v)
        contentPanel.addSubview(time_lable)
        self.contentView.addSubview(contentPanel)
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.contentPanel.backgroundColor = CuColor.colors.v2_CellWhiteBackgroundColor
        }
        setupLayout()
    }
    func setupLayout(){
        contentPanel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(6)
            make.right.equalTo(self.contentView).offset(-6)
            make.top.equalTo(self.contentView).offset(3)
            make.bottom.equalTo(self.contentView).offset(-3)
        }
        icon_Img.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentPanel).offset(8)
        }
        icon_more.snp.makeConstraints { (make) in
            make.top.equalTo(self.icon_Img)
            make.right.equalTo(self.contentPanel.snp.right).offset(-8)
        }

        title_lable.snp.makeConstraints { (make) in
            make.top.equalTo(self.icon_Img)
            make.left.equalTo(self.icon_Img.snp.right).offset(8)
        }
        totalnum.snp.makeConstraints { (make) in
            make.top.equalTo(self.title_lable.snp.bottom).offset(8)
            make.left.equalTo(self.title_lable)
        }
        totalnum_v.snp.makeConstraints { (make) in
            make.top.equalTo(totalnum)
            make.left.equalTo(self.totalnum.snp.right).offset(8)
        }
        time_lable.snp.makeConstraints { (make) in
            make.top.equalTo(icon_Img)
            make.left.equalTo(self.contentPanel).offset(SCREEN_WIDTH/2 + 8)
        }
        recordnum.snp.makeConstraints { (make) in
            make.top.equalTo(self.time_lable.snp.bottom).offset(8)
            make.left.equalTo(self.time_lable)
        }
        recordnum_v.snp.makeConstraints { (make) in
            make.top.equalTo(recordnum)
            make.left.equalTo(self.recordnum.snp.right).offset(8)
        }
    }
    func bind(index :Int){
        var imageName = ""
        switch index {
        case 1:
            imageName = "ic_out_bin"
            title_lable.text = "领用"
        case 2:
            imageName = "ic_check_bin"
            title_lable.text = "盘点"
        case 3:
            imageName = "ic_error_bin"
            title_lable.text = "报障"
        default:
            imageName = "ic_out_bin"
        }
        icon_Img.image = UIImage(named: imageName)
        icon_more.image = UIImage(named: "more")
        time_lable.text = "11:11"
        totalnum_v.text = "3"
        recordnum_v.text = "6"
    }
}
