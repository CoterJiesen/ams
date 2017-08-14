//
//  CuProgressHDU.swift
//  ams
//
//  Created by coterjiesen on 2017/4/21.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//


import UIKit
import SVProgressHUD

open class CuProgressHUD: NSObject {
    open class func show() {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show()
       // SVProgressHUD.show(with: .none)
    }
    
    open class func showWithClearMask() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        // SVProgressHUD.show(with: .none)
    }
    
    open class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    open class func showWithStatus(_ status:String!) {
        SVProgressHUD.show(withStatus: status)
    }
    
    open class func success(_ status:String!) {
        SVProgressHUD.showSuccess(withStatus: status)
    }
    
    open class func error(_ status:String!) {
        SVProgressHUD.showError(withStatus: status)
    }
    
    open class func inform(_ status:String!) {
        SVProgressHUD.showInfo(withStatus: status)
    }
}

public func CuSuccess(_ status:String!) {
    CuProgressHUD.success(status)
}

public func CuError(_ status:String!) {
    CuProgressHUD.error(status)
}

public func CuInform(_ status:String!) {
    CuProgressHUD.inform(status)
}

public func CuBeginLoading() {
    CuProgressHUD.show()
}

public func CuBeginLoadingWithStatus(_ status:String!) {
    CuProgressHUD.showWithStatus(status)
}

public func CuEndLoading() {
    CuProgressHUD.dismiss()
}
