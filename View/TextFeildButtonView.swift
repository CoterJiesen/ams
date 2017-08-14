//
//  TextFeildButtonView.swift
//  ams
//
//  Created by yangyuan on 2017/7/27.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//


import UIKit

class TextFieldButtonView: UIView {
    
    /**
     *  输入框
     */
    var inputTextField: UITextField? {
        didSet{
            inputTextField!.placeholder = "输入SN" //这里要写个不写没有效果，不知为啥
            let color = UIColor.white.withAlphaComponent(0.5)
            inputTextField!.setValue(color, forKeyPath: "_placeholderLabel.textColor")
        }
    }
    var rightButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    func setUpUI() {
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
        inputTextField = UITextField()
        inputTextField!.textColor = UIColor.white
        inputTextField!.clearButtonMode = .whileEditing
        inputTextField!.layer.cornerRadius = 5
        inputTextField!.layer.borderWidth = 1
        inputTextField!.layer.borderColor = UIColor.clear.cgColor
        inputTextField!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        rightButton = UIButton()
        rightButton!.setTitle("确定", for: UIControlState())
        rightButton?.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        rightButton!.layer.cornerRadius = 5
        rightButton!.layer.borderWidth = 1
        self.addSubview(inputTextField!)
        self.addSubview(rightButton!)
        self.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self)
        }
        inputTextField!.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(6)
            make.bottom.equalTo(self).offset(-6)
            make.width.equalTo(SCREEN_WIDTH - 70)
        }
        rightButton!.snp.makeConstraints { (make) in
            make.top.height.equalTo(inputTextField!)
            make.left.equalTo(inputTextField!.snp.right).offset(6)
            make.right.equalTo(self).offset(-6)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
