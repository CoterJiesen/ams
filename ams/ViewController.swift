
//
//  ViewController.swift
//  ams
//
//  Created by coterjiesen on 2017/4/12.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    var txtUser: UITextField!           //用户名输入框
    var txtPwd: UITextField!            //密码输入框
    var txtCap: UITextField!            //验证码输入框
    var capButton: UIButton!            //验证码按钮
    var formView: UIView!               //登陆框视图
    var horizontalLine1: UIView!         //分隔线
    var horizontalLine2: UIView!         //分隔线
    var confirmButton:UIButton!         //登录按钮
    var titleLabel: UILabel!            //标题标签
    
    
    var topConstraint: Constraint? //登录框距顶部距离约束
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //点击 空白 收起键盘
        self.hideKeyboardWhenTappedAround()
        
        //视图背景色
        self.view.backgroundColor = UIColor(red: 1/255, green: 170/255, blue: 235/255, alpha: 1)
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"login.png")!)
        
        //登录框高度
        let formViewHeight = 120
        //输入框的高度
        let txtFieldHeight = 44
        //登录框背景
        self.formView = UIView()
        self.formView.layer.borderWidth = 0.5
        self.formView.layer.borderColor = UIColor.lightGray.cgColor
        self.formView.backgroundColor = UIColor.white
        self.formView.layer.cornerRadius = 5
        self.view.addSubview(self.formView)
        //最常规的设置模式
        self.formView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            //存储top属性
            self.topConstraint = make.centerY.equalTo(self.view).constraint
            make.height.equalTo(formViewHeight)
        }
        
        //分隔线1
        self.horizontalLine1 =  UIView()
        self.horizontalLine1.backgroundColor = UIColor.lightGray
        self.formView.addSubview(self.horizontalLine1)
        self.horizontalLine1.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0.8)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(self.formView).offset(-formViewHeight/6)
        }
        //分隔线2
        self.horizontalLine2 =  UIView()
        self.horizontalLine2.backgroundColor = UIColor.lightGray
        self.formView.addSubview(self.horizontalLine2)
        self.horizontalLine2.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0.8)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(self.formView).offset(formViewHeight/6)
        }
        
        //用户名图标
        let imgLock1 =  UIImageView(frame:CGRect(x: 6, y: 11, width: txtFieldHeight/2, height: txtFieldHeight/2))
        imgLock1.image = UIImage(named:"iconfont-user")
        //密码图标
        let imgLock2 =  UIImageView(frame:CGRect(x: 6, y: 11, width: txtFieldHeight/2, height: txtFieldHeight/2))
        imgLock2.image = UIImage(named:"iconfont-password")
        //验证码图标
        let imgLock3 =  UIImageView(frame:CGRect(x: 6, y: 11, width: txtFieldHeight/2, height: txtFieldHeight/2))
        imgLock3.image = UIImage(named:"iconfont-cap")
        //验证码按钮
        self.capButton = UIButton(frame:CGRect(x: -4, y: 4, width: 2*txtFieldHeight+10, height: txtFieldHeight-8))
        self.capButton.backgroundColor = UIColor(patternImage: UIImage(named:"code.png")!)
        capButton.addTarget(self, action:#selector(capButtonOnClick), for:.touchUpInside)
        
        //用户名输入框
        self.txtUser = UITextField()
        self.txtUser.delegate = self
        self.txtUser.placeholder = "用户名"
        self.txtUser.tag = 100
        self.txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        self.txtUser.leftViewMode = UITextFieldViewMode.always
        self.txtUser.returnKeyType = UIReturnKeyType.next
        //用户名输入框左侧图标
        self.txtUser.leftView!.addSubview(imgLock1)
        self.formView.addSubview(self.txtUser)
        //布局
        self.txtUser.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(txtFieldHeight)
            make.centerY.equalTo(self.formView).offset(-formViewHeight/3)
        }
        
        //密码输入框
        self.txtPwd = UITextField()
        self.txtPwd.delegate = self
        self.txtPwd.placeholder = "密码"
        self.txtPwd.tag = 101
        self.txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        self.txtPwd.leftViewMode = UITextFieldViewMode.always
        self.txtPwd.returnKeyType = UIReturnKeyType.next
        self.txtPwd.isSecureTextEntry = true
        //密码输入框左侧图标
        self.txtPwd.leftView!.addSubview(imgLock2)
        self.formView.addSubview(self.txtPwd)
        //布局
        self.txtPwd.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(txtFieldHeight)
            make.centerY.equalTo(self.formView)
        }
        

        //验证码
        self.txtCap = UITextField()
        txtCap.keyboardType = UIKeyboardType.asciiCapable
        self.txtCap.delegate = self
        self.txtCap.placeholder = "验证码"
        self.txtCap.leftView = UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        self.txtCap.leftViewMode = UITextFieldViewMode.always
        self.txtCap.tag = 102
        self.txtCap.rightView = UIButton(frame:CGRect(x: 0, y: 0, width:2*txtFieldHeight+10, height: txtFieldHeight))
        self.txtCap.rightViewMode = UITextFieldViewMode.always
        self.txtCap.returnKeyType = UIReturnKeyType.next
        //密码输入框左侧图标
        self.txtCap.leftView!.addSubview(imgLock3)
        //验证码按钮右侧图标
        self.txtCap.rightView!.addSubview(self.capButton)
        self.formView.addSubview(self.txtCap)
        //布局
        self.txtCap.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(txtFieldHeight)
            make.centerY.equalTo(self.formView).offset(formViewHeight/3)
        }

        //登录按钮
        self.confirmButton = UIButton()
        self.confirmButton.setTitle("登录", for: UIControlState())
        self.confirmButton.setTitleColor(UIColor.black,
                                         for: UIControlState())
        self.confirmButton.layer.cornerRadius = 5
        self.confirmButton.backgroundColor = UIColor.red
        self.confirmButton.addTarget(self, action: #selector(loginConfrim),
                                     for: .touchUpInside)
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.top.equalTo(self.formView.snp.bottom).offset(20)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        //标题label
        self.titleLabel = UILabel()
        self.titleLabel.text = "资产管理系统"
        self.titleLabel.textColor = UIColor.blue
        self.titleLabel.font = UIFont.systemFont(ofSize: 38)
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.formView.snp.top).offset(-20)
            make.centerX.equalTo(self.view)
            make.height.equalTo(44)
        }
    }
    var flg = 1
    func capButtonOnClick(_ sender:AnyObject){
        if flg == 1{
            flg = 0
            self.capButton.backgroundColor = UIColor(patternImage: UIImage(named:"code1.png")!)
        }else{
            flg = 1
            self.capButton.backgroundColor = UIColor(patternImage: UIImage(named:"code.png")!)
        }
     
        
    }
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: -125)
            self.view.layoutIfNeeded()
        })
    }
    
    //输入框返回时操作
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        let tag = textField.tag
        switch tag {
        case 100:
            self.txtPwd.becomeFirstResponder()
        case 102:
            loginConfrim()
        default:
            print(textField.text!)
        }
        return true
    }
    
    //MARK: - 点击文本框外收回键盘
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.loginConfrim))
        view.addGestureRecognizer(tap)
    }
    //登录按钮点击
    func loginConfrim(){
        //收起键盘
        self.view.endEditing(true)
        //视图约束恢复初始设置
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}



