//
//
//  LoginViewController.swift
//  ams
//
//  Created by coterjiesen on 2017/4/12.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import TKSubmitTransitionSwift3

public typealias LoginSuccessHandel = (String) -> Void

class LoginViewController: UIViewController,UITextFieldDelegate ,UIViewControllerTransitioningDelegate{
    
    var successHandel:LoginSuccessHandel?
    
    let backgroundImageView = UIImageView()
    let frostedView = UIView() // UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let txtUser = UITextField()           //用户名输入框
    let txtPwd = UITextField()            //密码输入框
//    let txtCap = UITextField()           //验证码输入框
    let capButton = UIButton()            //验证码按钮
    let formView  = UIView()              //登陆框视图
    let horizontalLine1 = UIView()        //分隔线
    let horizontalLine2 =  UIView()         //分隔线
//    let loginButton = UIButton()            //登录按钮
    let loginButton =  TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: 0, height: 40))   //登录按钮
    let titleLabel = UILabel()              //标题标签
    let titleSummaryLabel = UILabel()
    let forgetPasswordLabel = UILabel()
    let footLabel = UILabel()
    let formViewHeight = 110            //登录框高度
    let txtFieldHeight = 48             //输入框的高度
    
    var topConstraint: Constraint? //登录框距顶部距离约束
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //点击 空白 收起键盘
        hideKeyboardWhenTappedAround()
        
        //初始化界面
        setupView()
        //绑定事件
        loginButton.addTarget(self, action: #selector(loginClick),for: .touchUpInside)
//        capButton.addTarget(self, action:#selector(capButtonOnClick(_:)), for:.touchUpInside)
    }
    //view出现 设置背景
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2, animations: { () -> Void in
            self.backgroundImageView.alpha=1;
        })
//        UIView.animate(withDuration: 20, animations: { () -> Void in
//            self.backgroundImageView.frame = CGRect(x: -1*( 1000 - SCREEN_WIDTH )/2, y: 0, width: SCREEN_HEIGHT+500, height: SCREEN_HEIGHT+500);
//        })
    }
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 1, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    //获取验证码
    func getCapcha(){
        UserModel.getCapcha(){
            (response:CuValueResponse<String>,capcha:UIImage) -> Void in
            if response.success{
                self.capButton.backgroundColor = UIColor(patternImage: capcha)
            }else{
                CuError(response.message)
                self.capButton.backgroundColor = UIColor(patternImage: capcha)
            }
        }
    }
    //点击刷新验证码
    func capButtonOnClick(_ sneder:UIButton){
        getCapcha()
    }
    
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: -125)
            self.view.layoutIfNeeded()
        })
    }
    
    //输入框返回时操作 //按回车键时操作
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        let tag = textField.tag
        switch tag {
        case 100:
            txtPwd.becomeFirstResponder()
//        case 101:
//            txtCap.becomeFirstResponder()
        case 102:
            //收起键盘
            awayKeyboard()
            //登录
            loginClick()
        default:
            print(textField.text!)
        }
        return true
    }
    
    //MARK: - 点击文本框外收回键盘
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.awayKeyboard))
        view.addGestureRecognizer(tap)
    }
    //恢复view位置
    func awayKeyboard(){
        //收起键盘
        self.view.endEditing(true)
        //视图约束恢复初始设置
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        })
    }
    //登录实现
    func loginClick(){
        awayKeyboard()
        var userName:String
        var password:String
        var cap:String
        if let len = txtUser.text?.Lenght , len > 0{
            userName = txtUser.text! ;
        }
        else{
            txtUser.becomeFirstResponder()
            return
        }
        
        if let len =  txtPwd.text?.Lenght , len > 0  {
            password = txtPwd.text!
        }
        else{
            txtPwd.becomeFirstResponder()
            return
        }
//        if let len = txtCap.text?.Lenght ,len > 0 {
//            cap = txtCap.text!
//        }
//        else{
//            txtCap.becomeFirstResponder()
//            return
//        }
        CuBeginLoadingWithStatus("正在登录")
        UserModel.Login(userName, password: password,captcha: ""){
            (response:CuValueResponse<String> ,url:String) -> Void in
            if response.success {
                switch  response.message {
                    case "登录成功":
                        CuSuccess(response.message)
                        let username = response.value!
                        //保存下用户名
                        CuSettings.sharedInstance[kUserName] = username
                        //将用户名密码保存进keychain （安全保存)
                        UsersKeychain.sharedInstance.addUser(username, password: password)
                        //调用登录成功回调
                        if let handel = self.successHandel {
                              handel(username)
                         }
                        //获取用户信息
                        UserModel.getUserInfoByUsername(username: username) {
                            (response: CuValueResponse<UserInfo>) -> Void in
                            if response.success {
                                CuUser.sharedInstance.user = response.value
                                self.loginButton.animate(1, completion: { () -> () in
                                    let secondVC = MainTabViewController();
                                    CuClient.sharedInstance.centerViewController = secondVC.viewMain
                                    secondVC.transitioningDelegate = self
                                    self.present(secondVC, animated: true, completion: nil)
                                })
                            }
                        }
                        

//                        self.dismiss(animated: true, completion: nil)
                        break
                    case "密码错误","该用户不存在","验证码错误":
                        CuError(response.message)
                        break

                    default:
                        CuError(response.message)
                        break
                }
            }
            else{
                CuError("登陆失败")
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

//MARK: - 初始化界面
extension LoginViewController {
    func setupView(){

        self.view.backgroundColor = UIColor.black
//        backgroundImageView.image = UIImage(named: "login_bg.png")
        let colors = [UIColor.init(colorLiteralRed: 178.0/255.0, green: 226.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor, UIColor.init(colorLiteralRed: 232.0/255.0, green: 244.0/255.0, blue: 193.0/255.0, alpha: 1.0).cgColor]
        backgroundImageView.layer.initCALayer(self.view.bounds, colors, [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)])
        backgroundImageView.frame = self.view.frame
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.alpha = 0
        frostedView.frame = self.view.frame


        //登录框背景
//        formView.backgroundColor = UIColor.black
//        formView.backgroundColor = UIColor.darkGray
        formView.layer.borderWidth = 1
        formView.layer.cornerRadius = 5
        formView.layer.borderColor = CuColor.colors.v2_ButtonBackgroundColor.cgColor

        //分隔线1
        horizontalLine1.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor//UIColor.lightGray
        //分隔线2
        horizontalLine2.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        
        //标题label
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 32)!;
        titleLabel.text = "中国移动"
        titleSummaryLabel.font = v2Font(16);
        titleSummaryLabel.text = "资产管理系统"
   
        
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
        capButton.frame = CGRect(x: -4, y: 4, width: 2*txtFieldHeight+10, height: txtFieldHeight-8)
//        self.capButton.backgroundColor = UIColor(patternImage: UIImage(named: "cap_err.png")!)
//        self.getCapcha()
        
        //用户名输入框
        txtUser.delegate = self
        txtUser.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [NSForegroundColorAttributeName: CuColor.colors.v2_ButtonBackgroundColor])
        txtUser.text = "cfy666"
        txtUser.font = v2Font(20)
        txtUser.textColor = UIColor.black
        txtUser.clearButtonMode = .always
        txtUser.tag = 100
        txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        txtUser.leftViewMode = UITextFieldViewMode.always
        txtUser.returnKeyType = UIReturnKeyType.next
        //用户名输入框左侧图标
        txtUser.leftView!.addSubview(imgLock1)

        //密码输入框
        txtPwd.keyboardType = UIKeyboardType.namePhonePad
        txtPwd.delegate = self
        txtPwd.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSForegroundColorAttributeName: CuColor.colors.v2_ButtonBackgroundColor])
        txtPwd.text = "cfy666"
        txtPwd.font = v2Font(20)
        txtPwd.textColor = UIColor.black
        txtPwd.clearButtonMode = .always
        txtPwd.tag = 101
        txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        txtPwd.leftViewMode = UITextFieldViewMode.always
        txtPwd.returnKeyType = UIReturnKeyType.next
        txtPwd.isSecureTextEntry = true
        //密码输入框左侧图标
        txtPwd.leftView!.addSubview(imgLock2)

//        //验证码
//        txtCap.keyboardType = UIKeyboardType.namePhonePad
//        txtCap.delegate = self
//        txtCap.attributedPlaceholder = NSAttributedString(string: "验证码", attributes: [NSForegroundColorAttributeName: CuColor.colors.v2_ButtonBackgroundColor])
//        txtCap.font = v2Font(20)
//        txtCap.textColor = UIColor.black
//        txtCap.leftView = UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
//        txtCap.leftViewMode = UITextFieldViewMode.always
//        txtCap.tag = 102
//        txtCap.rightView = UIButton(frame:CGRect(x: 0, y: 0, width:2*txtFieldHeight+10, height: txtFieldHeight))
//        txtCap.rightViewMode = UITextFieldViewMode.always
//        txtCap.returnKeyType = UIReturnKeyType.next
//        //密码输入框左侧图标
//        txtCap.leftView!.addSubview(imgLock3)
//        //验证码按钮右侧图标
//        txtCap.rightView!.addSubview(self.capButton)

        //登录按钮
        loginButton.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        loginButton.setTitle("登录", for: UIControlState())
        loginButton.titleLabel!.font = v2Font(20)
        loginButton.layer.cornerRadius = 20;
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor;

        
        forgetPasswordLabel.alpha = 0.5
        forgetPasswordLabel.font = v2Font(16)
        forgetPasswordLabel.text = "忘记密码了?"
        
        footLabel.alpha = 0.5
        footLabel.font = v2Font(16)
        footLabel.text = "© 2017 ZZnode"
        
        
//       let bgImage: UIImageView = UIImageView(image: UIImage(named: "34.jpg"))
//        bgImage.isUserInteractionEnabled = true
//        bgImage.layer.cornerRadius = 5.0
//        bgImage.layer.borderWidth = 1.0
//        bgImage.layer.borderColor = UIColor.clear.cgColor
//        bgImage.layer.masksToBounds = true
//        bgImage.addSubview(formView)
//        formView.backgroundColor = UIColor(patternImage: UIImage(named: "34.jpg")!)
      //  formView.addSubview(bgImage)
       
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.frostedView)
        formView.addSubview(txtPwd)
        formView.addSubview(txtUser)
//        formView.addSubview(txtCap)
        formView.addSubview(self.horizontalLine1)
        formView.addSubview(self.horizontalLine2)
        frostedView.addSubview(formView)
        frostedView.addSubview(loginButton);
        frostedView.addSubview(forgetPasswordLabel);
        frostedView.addSubview(titleLabel);
        frostedView.addSubview(titleSummaryLabel);
        frostedView.addSubview(footLabel);

        setupLayout();

    }
    func setupLayout(){
       //最常规的设置模式
        formView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            //存储top属性
            self.topConstraint = make.centerY.equalTo(self.view).constraint
            make.height.equalTo(formViewHeight)
            
        }
       horizontalLine1.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(2)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(self.formView)
        }
//        horizontalLine2.snp.makeConstraints { (make) -> Void in
//            make.height.equalTo(2)
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            make.centerY.equalTo(self.formView).offset(formViewHeight/6)
//        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.formView.snp.top).offset(-30)
            make.centerX.equalTo(self.view)
            make.height.equalTo(44)
        }
       titleSummaryLabel.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(frostedView)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
        }
        txtUser.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(txtFieldHeight)
            make.centerY.equalTo(self.formView).offset(-formViewHeight/4)
        }
        
        txtPwd.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(txtFieldHeight)
            make.centerY.equalTo(self.formView).offset(formViewHeight/4)
        }
//        txtCap.snp.makeConstraints { (make) -> Void in
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            make.height.equalTo(txtFieldHeight)
//            make.centerY.equalTo(self.formView).offset(formViewHeight/3)
//        }
        loginButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.top.equalTo(self.formView.snp.bottom).offset(20)
            make.right.equalTo(-15)
            make.height.equalTo(40)
        }
        forgetPasswordLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.loginButton.snp.bottom).offset(14)
            make.right.equalTo(self.loginButton)
        }
        footLabel.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(frostedView).offset(-20)
            make.centerX.equalTo(frostedView)
        }
        
    }
}

