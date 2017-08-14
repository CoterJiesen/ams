//
//  CheckSuccessViewController.swift
//  ams
//
//  Created by yangyuan on 2017/8/10.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

//盘点成功视图控制器
class CheckSuccessViewController: UIViewController {

    var  imageSucc : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "pd1")
        return img
    }()
    var labelTitle: UILabel = {
       let label = UILabel()
        label.text = "恭喜您!"
        label.font = v2Font(40)
        label.textColor = .white
        return label
    }()
    var labelDetial: UILabel = {
       let label = UILabel()
        label.text = "成功盘点设备0台"
        label.textColor = .white
        label.font = v2Font(20)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setup(){
        self.view.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        self.view.addSubview(imageSucc)
        self.view.addSubview(labelTitle)
        self.view.addSubview(labelDetial)
        setupLayout()
    }
    func setupLayout(){
        self.imageSucc.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-60)
            make.height.width.equalTo(SCREEN_WIDTH / 2)
        }
        self.labelTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(60)
            make.height.equalTo(40)
        }
        self.labelDetial.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.labelTitle.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
    }
}
