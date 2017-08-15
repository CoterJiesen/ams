//
//  CuNavigationController.swift
//  ams
//
//  Created by coterjiesen on 2017/4/26.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class CuNavigationController: UINavigationController {
    
    /// 毛玻璃效果的 navigationBar 背景
    var frostedView:UIToolbar = UIToolbar()
    /// navigationBar 阴影
    var shadowImage:UIImage?
    /// navigationBar 背景透明度
    var navigationBarAlpha:CGFloat {
        get{
            return  self.frostedView.alpha
        }
        set {
            var value = newValue
            if newValue > 1 {
                value = 1
            }
            else if value < 0 {
                value = 0
            }
            self.frostedView.alpha = newValue
            if(value == 1){
                if self.navigationBar.shadowImage != nil{
                    self.navigationBar.shadowImage = nil
                }
            }
            else {
                if self.navigationBar.shadowImage == nil{
                    self.navigationBar.shadowImage = UIImage()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.shared.setStatusBarStyle(.default, animated: true);
        UIApplication.shared.statusBarStyle = .default
        self.navigationBar.setBackgroundImage(createImageWithColor(UIColor.clear), for: .default)
        
        let maskingView = UIView()
        maskingView.isUserInteractionEnabled = false
        maskingView.backgroundColor = UIColor(white: 0, alpha: 0.0);
        self.navigationBar.superview!.insertSubview(maskingView, belowSubview: self.navigationBar)
        maskingView.snp.makeConstraints{ (make) -> Void in
            make.left.bottom.right.equalTo(self.navigationBar)
            make.top.equalTo(self.navigationBar).offset(-20);
        }
        
        self.frostedView.isUserInteractionEnabled = false
        self.frostedView.clipsToBounds = true
        maskingView.addSubview(self.frostedView);
        self.frostedView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.left.right.equalTo(maskingView);
        }
        
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.navigationBar.tintColor = CuColor.colors.v2_navigationBarTintColor
            
            self?.navigationBar.titleTextAttributes = [
                NSFontAttributeName : v2Font(18),
                NSForegroundColorAttributeName : CuColor.colors.v2_TopicListTitleColor
            ]
            
            if CuColor.sharedInstance.style == CuColor.CuColorStyleDefault {
                self?.frostedView.barStyle = .default
            //    UIApplication.shared.setStatusBarStyle(.default, animated: true);
                
                
                UIApplication.shared.statusBarStyle = .default
                
                //全局键盘颜色
                UITextView.appearance().keyboardAppearance = .light
                UITextField.appearance().keyboardAppearance = .light
                
            }
            else{
                self?.frostedView.barStyle = .black
               // UIApplication.shared.setStatusBarStyle(.lightContent, animated: true);
                UIApplication.shared.statusBarStyle = .lightContent
                
                UITextView.appearance().keyboardAppearance = .dark
                UITextField.appearance().keyboardAppearance = .dark
            }
        }
    }
}
