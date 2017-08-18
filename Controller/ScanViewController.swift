//
//  ScanViewController.swift
//  Created by coterjiesen on 2017/4/12.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

import SnapKit
import AVFoundation

protocol scanDelegate{
    //回传条码类型和值
    func passBarcodeValue(title:String, message:String)
}

class ScanViewController: LBXScanViewController,UITextFieldDelegate {
    
    var topConstraint: Constraint? //框距顶部距离约束
    /**
    @brief  扫码区域上方提示文字
    */
    var topTitle:UILabel?

    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash:Bool = false
    var isSnInput:Bool = false
    
// MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    
    //底部显示的功能项
    var bottomItemsView:UIView?
   
    //相册
    var btnPhoto:UIButton = UIButton()
    
    //闪光灯
    var btnFlash:UIButton = UIButton()
    
    //SN
    var btnSn:UIButton = UIButton()
    
    var snInputView: TextFieldButtonView?
    //定代理
    var delegate : scanDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrayCodeType = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code]
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)
        
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
 
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawBottomItems()
        drawsnInputView()
        hideKeyboardWhenTappedAround()
    }
    
    
  
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
        for result:LBXScanResult in arrayResult
        {
            if let str = result.strScanned {
                print(str)
            }
        }
        
        let result:LBXScanResult = arrayResult[0]
        
        showMsg(title: result.strBarCodeType, message: result.strScanned)
        delegate?.passBarcodeValue(title: result.strBarCodeType!, message: result.strScanned!)
//        self.dismiss(animated: true,completion: nil)
        //navigation
        self.navigationController?.popViewController(animated: true)
        
    }
    func snOKbuttonClicked(){
        var sn:String?
        if let len = snInputView!.inputTextField!.text?.Lenght , len > 0{
            sn = snInputView!.inputTextField!.text! ;
        }
        else{
            snInputView!.inputTextField!.becomeFirstResponder()
            return
        }
       delegate?.passBarcodeValue(title: "input", message: sn!)
       self.navigationController?.popViewController(animated: true)
    }
    func drawsnInputView(){
        if snInputView != nil {
            return
        }
        snInputView = TextFieldButtonView()
        snInputView?.inputTextField?.delegate = self
        self.view.addSubview(snInputView!)
        snInputView!.backgroundColor = UIColor.gray
        snInputView!.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.left.equalTo(self.view)
            make.height.equalTo(60)
            self.topConstraint = make.top.equalTo(self.view.snp.bottom).constraint
        }
        snInputView!.rightButton!.addTarget(self, action: #selector(snOKbuttonClicked) , for: .touchUpInside)
    }
    func drawBottomItems()
    {
        if (bottomItemsView != nil) {
            
            return;
        }
        
        let yMax = self.view.frame.maxY - self.view.frame.minY
        
        bottomItemsView = UIView(frame:CGRect(x: 0.0, y: yMax-100,width: self.view.frame.size.width, height: 100 ) )
        
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        let size = CGSize(width: 65, height: 87);

        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/4, y: bottomItemsView!.frame.height/2)
        btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        btnFlash.addTarget(self, action: #selector(ScanViewController.openOrCloseFlash), for: UIControlEvents.touchUpInside)
        
        
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "qrcode_scan_btn_photo_nor"), for: UIControlState.normal)
        btnPhoto.setImage(UIImage(named: "qrcode_scan_btn_photo_down"), for: UIControlState.highlighted)
        btnPhoto.addTarget(self, action: #selector(openPhotoAlbum), for: UIControlEvents.touchUpInside)
        
        btnSn.bounds = btnFlash.bounds
        btnSn.center = CGPoint(x: bottomItemsView!.frame.width*3/4, y: bottomItemsView!.frame.height/2)
        btnSn.setImage(UIImage(named: "qrcode_scan_btn_sn_nor"), for:UIControlState.normal)
        btnSn.setImage(UIImage(named: "qrcode_scan_btn_sn_down"), for:UIControlState.highlighted)
        btnSn.addTarget(self, action: #selector(ScanViewController.inputSN), for: UIControlEvents.touchUpInside)
        
        
        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)
        bottomItemsView?.addSubview(btnSn)
        
        self.view.addSubview(bottomItemsView!)
    }
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: -290)
            self.view.layoutIfNeeded()
        })
    }
    //MARK: - 点击文本框外收回键盘
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.awayKeyboard))
        tap.cancelsTouchesInView = false //是否取消点击处的其他action
        view.addGestureRecognizer(tap)
    }
    //恢复view位置
    func awayKeyboard(){
        //收起键盘
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: -170)
            self.view.layoutIfNeeded()
        })
    }
    //开关闪光灯
    func openOrCloseFlash()
    {
        scanObj?.changeTorch();
        
        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_down"), for:UIControlState.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        }
    }
    func inputSN(){
        if isSnInput{
            btnSn.setImage(UIImage(named: "qrcode_scan_btn_sn_nor"), for:UIControlState.normal)
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.topConstraint?.update(offset: 0)
                self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                if finished{
                    self.isSnInput = false
                }
            })
        }else{
            btnSn.setImage(UIImage(named: "qrcode_scan_btn_sn_down"), for:UIControlState.normal)
            snInputView?.inputTextField?.resignFirstResponder()
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.topConstraint?.update(offset: -170)
                self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                if finished{
                    self.isSnInput = true
                }
            })
        }
    }
}
