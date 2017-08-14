//
//  File.swift
//  ams
//
//  Created by yangyuan on 2017/8/2.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class CheckUnusualView: UIView{
    
    var topView = UIView()
    var bottomView = UIView()
    var warningImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "pd2")
        return img
    }()

    var titileLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(25)
        label.text = "盘点异常"
        label.textColor = .white
        return label
    }()
    
    var realNumLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(20)
        label.text = "100"
        label.textColor = .white
        return label
    }()
    var realTitleLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "实物数量"
        label.textColor = .white
        return label
    }()
    var horizetolLineLabel = UILabel()
    
    var numCurentLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(20)
        label.text = "99"
        label.textColor = .white
        return label
    }()
    var curentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "账面数量"
        label.textColor = .white
        return label
    }()
    var litleWarningImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "pd3")
        return img
    }()
    var titleDetialLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "盘点情况为盘盈"
        label.textColor = .white
        return label
    }()

    var notForMeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "不在该库:"
        label.textColor = .white
        return label
    }()
    var noCheckTitleLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "没有盘点:"
        label.textColor = .white
        return label
    }()
    var notInBinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "没有入库:"
        label.textColor = .white
        return label
    }()
    override init(frame : CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI(){
        horizetolLineLabel.backgroundColor = .white
        self.addSubview(topView)
        self.addSubview(bottomView)
        topView.addSubview(warningImg)
        topView.addSubview(titileLabel)
        topView.addSubview(numCurentLabel)
        topView.addSubview(realNumLabel)
        topView.addSubview(realTitleLabel)
        topView.addSubview(curentTitleLabel)
        topView.addSubview(horizetolLineLabel)
        topView.addSubview(notForMeTitleLabel)
        topView.addSubview(noCheckTitleLabel)
        topView.addSubview(notInBinTitleLabel)
        bottomView.addSubview(litleWarningImg)
        bottomView.addSubview(titleDetialLabel)

        setupLayout()

    }
    func setupLayout(){
        self.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        self.topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-30)
        }
        self.bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.top.equalTo(topView.snp.bottom)
        }
        notForMeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView).offset(30)
            make.left.equalTo(self.topView).offset(10)
        }
        notInBinTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(notForMeTitleLabel)
            make.top.equalTo(notForMeTitleLabel.snp.bottom).offset(3)
        }
        noCheckTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(notForMeTitleLabel)
            make.top.equalTo(notInBinTitleLabel.snp.bottom).offset(3)
        }
        horizetolLineLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.topView)
            make.bottom.equalTo(self.topView).offset(-40)
            make.width.equalTo(1)
            make.height.equalTo(30)
        }
        realNumLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(topView).offset(-SCREEN_WIDTH/4)
            make.top.equalTo(horizetolLineLabel).offset(-10)
        }
        realTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(realNumLabel)
            make.bottom.equalTo(horizetolLineLabel).offset(10)
        }
        numCurentLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(topView).offset(SCREEN_WIDTH/4)
            make.top.equalTo(horizetolLineLabel).offset(-10)
        }
        curentTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(numCurentLabel)
            make.bottom.equalTo(horizetolLineLabel).offset(10)
        }

        titileLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(topView)
            make.height.equalTo(20)
            make.bottom.equalTo(horizetolLineLabel.snp.top).offset(-30)
        }
        warningImg.snp.makeConstraints { (make) in
            make.top.equalTo(topView).offset(20)
            make.centerX.equalTo(topView)
            make.bottom.equalTo(titileLabel.snp.top).offset(-30)
            make.width.equalTo(warningImg.snp.height)
        }
        litleWarningImg.snp.makeConstraints { (make) in
            make.left.equalTo(self.bottomView).offset(10)
            make.top.equalTo(self.bottomView).offset(8)
            make.bottom.equalTo(self.bottomView).offset(-8)
            make.width.equalTo(14)
        }
        titleDetialLabel.snp.makeConstraints { (make) in
            make.left.equalTo(litleWarningImg.snp.right).offset(5)
            make.top.equalTo(litleWarningImg)
            make.bottom.equalTo(litleWarningImg)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
