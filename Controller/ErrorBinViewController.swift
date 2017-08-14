//
//  OutBinViewController.swift
//  ams
//
//  Created by yangyuan on 2017/5/26.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

//领用
class ErrorBinViewController:UIViewController,UITextFieldDelegate,scanDelegate {
    var deviceData :deviceInfo? = nil
    let formViewHeight = 130
    //输入框的高度
    let txtFieldHeight = 48
    let barCode  = UITextField()  //条码
    let goodsAllocation  = UITextField() //货位
    let goodsInBinTime = UITextField() //设备类型
    let inventory = UITextField() //库存
    let goodsStatusChangeTime = UITextField() //设备名
    let outBinButton = UIButton()
    
    var scanButton: UIButton = {
        //创建一个图片一个文字的按钮
        let button = UIButton()
        button.setImage(UIImage(named: "scan_blue"), for: .normal)
        return button
    }()
    let queryButton :UIButton = {
        //创建一个图片一个文字的按钮
        let button = UIButton()
        button.setImage(UIImage(named: "query"), for: .normal)
        return button
    }()
    let horizontalLine1 = UIView()        //分隔线
    let horizontalLine2 =  UIView()         //分隔线
    let contentView  = UIView()  //装上面的袁元素
    
    override func viewDidLoad(){
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setup()
        scanButton.addTarget(self, action: #selector(scanBtnClicked), for: .touchUpInside)
        queryButton.addTarget(self, action:#selector(queryGoodsStatusClick), for: .touchUpInside)
        outBinButton.addTarget(self, action: #selector(reportFault), for: .touchUpInside)
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
    }
    
    //代理方法实现
    func passBarcodeValue(title: String, message: String) {
        barCode.text = message
        print(title)
    }
    //扫描条码
    func scanBtnClicked(){
        let vc = ScanViewController();
        //设置代理
        vc.delegate = self
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "qrcode_scan_light_green")
        vc.scanStyle = style
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true);
        //        CuClient.sharedInstance.centerViewController!.navigationController?.pushViewController(vc, animated: true);
    }
    
    func queryGoodsStatusClick(){
//        var barCodeText :String!
//        if let len = barCode.text?.Lenght,len > 0 {
//            barCodeText = barCode.text
//        }else{
//            barCode.becomeFirstResponder()
//            CuError("条码不能为空！")
//            return
//        }
//        DataModel.getDeviceInfo(sn: barCodeText){
//            (response: CuValueResponse<deviceInfo>)->Void in
//            if response.success {
//                self.deviceData = response.value
//                if 0 == response.value?.status {
//                    self.inventory.text = "设备不存在！"
//                    self.goodsStatusChangeTime.text = ""
//                    self.goodsInBinTime.text = ""
//                    return
//                }
//                self.goodsStatusChangeTime.text = self.deviceData?.opTime
//                self.goodsInBinTime.text = self.deviceData?.statusTime
//                self.inventory.text = deviceStatus[Int((self.deviceData?.status)!)]
//            }
//        }
    }
//    func showMsg(title:String?,message:String?)
//    {
//        if LBXScanWrapper.isSysIos8Later()
//        {
//            //if #available(iOS 8.0, *)
//            let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
//            let alertAction = UIAlertAction(title:  "知道了", style: UIAlertActionStyle.default)
//            
//            alertController.addAction(alertAction)
//            present(alertController, animated: true, completion: nil)
//        }
//    }
    func reportFault(){
        var barcode: String?
        if let len = barCode.text?.Lenght, len > 0 {
            barcode = barCode.text
        }else{
            showMsg(self, title: "Error", message: "条码不能为空！")
            return
        }
        DataModel.reportFaultOfDevice(sn: barcode!){
            ( response:(CuValueResponse<String>)) ->Void in
            if response.success{
                if response.message == "报障成功"{
                    showMsg(self, title: "Success", message: "报障成功!")
                   self.queryGoodsStatusClick()
                }else{
                    showMsg(self, title: "Error", message: response.message)
                }
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.tag == 100){
            return true
        }
        return false
    }
    
    func setup(){
        //背景
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.cornerRadius = 5
        
        //条码
        let leftView = UIImageView(image : UIImage(named:"icon_code"))
        leftView.frame = CGRect(x: 6, y: 11, width: txtFieldHeight-12, height: txtFieldHeight-22)
        scanButton.frame = CGRect(x: -4, y: 4, width: txtFieldHeight, height: txtFieldHeight-8)
        barCode.keyboardType = .asciiCapable
        barCode.delegate = self
        barCode.placeholder = "条码"
        barCode.text = "ALCLF231201B"
        barCode.tag = 100
        barCode.font = v2Font(20)
        barCode.textColor = UIColor.white
        barCode.leftViewMode = .always
        barCode.rightViewMode = .always
        barCode.leftView =  UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        barCode.rightView = UIButton(frame:CGRect(x: 0, y: 0, width:txtFieldHeight, height: txtFieldHeight))
        barCode.layer.borderColor = UIColor.white.cgColor
        barCode.layer.borderWidth = 0.5
        barCode.layer.cornerRadius = 5
        barCode.leftView!.addSubview(leftView)
        barCode.rightView!.addSubview(scanButton)
        
        //库存
        let leftViewInventory = UIImageView(image : UIImage(named:"ic_inventory"))
        leftViewInventory.frame = CGRect(x: 6, y: 11, width: txtFieldHeight-12, height: txtFieldHeight-22)
        queryButton.frame = CGRect(x: -4, y: 4, width: txtFieldHeight, height: txtFieldHeight-8)
        inventory.keyboardType = .asciiCapable
        inventory.delegate = self
        inventory.placeholder = "状态,(点击右边按钮获取设备信息)"
        inventory.font = v2Font(16)
        inventory.textColor = UIColor.white
        inventory.leftViewMode = .always
        inventory.rightViewMode = .always
        inventory.leftView =  UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        inventory.rightView = UIButton(frame:CGRect(x: 0, y: 0, width:txtFieldHeight, height: txtFieldHeight))
        inventory.leftView!.addSubview(leftViewInventory)
        inventory.rightView!.addSubview(queryButton)
        //设备类型
        let leftViewGoods = UIImageView(image : UIImage(named:"device_type"))
        leftViewGoods.frame = CGRect(x: 6, y: 11, width: txtFieldHeight-12, height: txtFieldHeight-22)
        goodsInBinTime.keyboardType = .asciiCapable
        goodsInBinTime.delegate = self
        goodsInBinTime.placeholder = "入库时间"
        goodsInBinTime.font = v2Font(20)
        goodsInBinTime.textColor = UIColor.white
        goodsInBinTime.leftViewMode = .always
        goodsInBinTime.rightViewMode = .always
        goodsInBinTime.leftView =  UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        goodsInBinTime.leftView!.addSubview(leftViewGoods)
        //设备名
        let leftViewName = UIImageView(image : UIImage(named:"ic_device_name"))
        leftViewName.frame = CGRect(x: 6, y: 11, width: txtFieldHeight-12, height: txtFieldHeight-22)
        goodsStatusChangeTime.keyboardType = .asciiCapable
        goodsStatusChangeTime.delegate = self
        goodsStatusChangeTime.placeholder = "设备名"
        goodsStatusChangeTime.attributedPlaceholder = NSAttributedString(string: "状态更改时间", attributes: [NSForegroundColorAttributeName: CuColor.colors.v2_ButtonBackgroundColor])
        goodsStatusChangeTime.font = v2Font(20)
        goodsStatusChangeTime.textColor = UIColor.white
        goodsStatusChangeTime.leftViewMode = .always
        goodsStatusChangeTime.rightViewMode = .always
        goodsStatusChangeTime.leftView =  UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        goodsStatusChangeTime.leftView!.addSubview(leftViewName)
        //领用按钮
        outBinButton.setTitle("报障", for: UIControlState())
        outBinButton.titleLabel!.font = v2Font(20)
        outBinButton.layer.cornerRadius = 3;
        outBinButton.layer.borderWidth = 1
        outBinButton.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        outBinButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor;
        //分隔线1
        horizontalLine1.backgroundColor = UIColor.white
        //分隔线2
        horizontalLine2.backgroundColor = UIColor.white
        //join in view
        contentView.addSubview(self.horizontalLine1)
        contentView.addSubview(self.horizontalLine2)
        contentView.addSubview(self.goodsInBinTime)
        contentView.addSubview(self.inventory)
        contentView.addSubview(self.goodsStatusChangeTime)
        self.view.addSubview(contentView)
        self.view.addSubview(barCode)
        self.view.addSubview(self.outBinButton)
        
        setupLayout()
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = UIColor(patternImage: UIImage(named:"background.png")!)
            //            self?.contentView.backgroundColor = CuColor.colors.v2_backgroundColor
            //            	self?.barCode.backgroundColor = CuColor.colors.v2_TextViewBackgroundColor
        }
    }
    func setupLayout(){
        //最常规的设置模式
        contentView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(130)
            make.centerY.equalTo(self.view)
        }
        
        barCode.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(txtFieldHeight)
            make.bottom.equalTo(self.contentView.snp.top).offset(-15)
        }
        inventory.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.height.equalTo(txtFieldHeight)
            make.centerY.equalTo(self.contentView).offset(-formViewHeight/3+5)
        }
        
        goodsInBinTime.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.height.equalTo(txtFieldHeight)
            make.centerY.equalTo(self.contentView)
        }
        goodsStatusChangeTime.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.height.equalTo(txtFieldHeight)
            make.centerY.equalTo(self.contentView).offset(formViewHeight/3)
        }
        horizontalLine1.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.height.equalTo(1)
            make.centerY.equalTo(self.contentView).offset(-formViewHeight/6)
        }
        horizontalLine2.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.height.equalTo(1)
            make.centerY.equalTo(self.contentView).offset(formViewHeight/6)
        }
        
        outBinButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(40)
            make.top.equalTo(self.contentView.snp.bottom).offset(20)
        }
    }
}
