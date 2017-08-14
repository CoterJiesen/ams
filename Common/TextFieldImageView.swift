//
//  TextFieldImageView.swift
//  ams
//
//  Created by yangyuan on 2017/6/9.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class TextFieldImageView: UIView {
    
    /**
     *  输入框
     */
    var inputTextField: UITextField? {
        didSet{
            inputTextField!.placeholder = "user"//这里要写个不写没有效果，不知为啥
            let color = UIColor.white.withAlphaComponent(0.5)
            inputTextField!.setValue(color, forKeyPath: "_placeholderLabel.textColor")
        }
    }
    /**
     *  左边图片
     */
    var leftImage: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    func setUpUI() {
        
        let bgImage: UIImageView = UIImageView(frame: self.bounds)
        bgImage.image = UIImage(named: "bg_input_down")
        bgImage.isUserInteractionEnabled = true
        bgImage.layer.cornerRadius = 5.0
        bgImage.layer.borderWidth = 1.0
        bgImage.layer.borderColor = UIColor.clear.cgColor
        bgImage.layer.masksToBounds = true
        self.addSubview(bgImage)
        leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.height, height: self.bounds.size.height))
        leftImage!.contentMode = .center
        bgImage.addSubview(leftImage!)
        self.inputTextField = UITextField(frame: CGRect(x: leftImage!.frame.origin.x + leftImage!.frame.size.width + 5, y: 0, width: self.bounds.size.width - leftImage!.frame.size.width, height: leftImage!.frame.size.height))
        self.inputTextField!.textColor = UIColor.white
        self.inputTextField!.clearButtonMode = .whileEditing
        bgImage.addSubview(inputTextField!)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
