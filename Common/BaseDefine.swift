//
//  BaseDefine.swift
//  ams
//
//  Created by coterjiesen on 2017/4/18.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//


import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
// MARK: - 全局常用属性

public let kWindowWidth: CGFloat = UIScreen.main.bounds.size.width
public let kWindowHeigth: CGFloat = UIScreen.main.bounds.size.height


public let  KLoadingViewWidth: CGFloat = 70
public let  KShapeLayerWidth: CGFloat = 40
public let  KShapeLayerRadius: CGFloat = KShapeLayerWidth / 2
public let  KShapelayerLineWidth: CGFloat = 2.5
public let  KAnimationDurationTime: TimeInterval = 1.5
public let  KShapeLayerMargin: CGFloat = (KLoadingViewWidth - KShapeLayerWidth) / 2

public let  kLabelHeight: CGFloat =  50
public let  x_OffSet: CGFloat =  20

//用户代理，使用这个切换是获取 m站点 还是www站数据
let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";
let MOBILE_CLIENT_HEADERS = ["user-agent":USER_AGENT]


//站点地址
//let AMSURL = "http://10.3.4.39:8011/AMS_HN_INTF/apphttp/"

//let AMSURL = "http://yaohuaipeng.tunnel.qydev.com/AMS_HN_INTF/apphttp/"
//let AMSURLLogin = "http://yaohuaipeng.tunnel.qydev.com/AMS_HN_INTF/"

//let AMSURL = "http://182.148.107.195:64088/AMS_HN_INTF/apphttp/"
//let AMSURLLogin = "http://182.148.107.195:64088/AMS_HN_INTF/"

let AMSURL = "http://10.3.4.208:8007/AMS_HN_INTF/apphttp/"
let AMSURLLogin = "http://10.3.4.208:8007/AMS_HN_INTF/"

let SEPARATOR_HEIGHT = 1.0 / UIScreen.main.scale


func NSLocalizedString( _ key:String ) -> String {
    return NSLocalizedString(key, comment: "")
}


func dispatch_sync_safely_main_queue(_ block: ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}

func v2Font(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize);
}

func v2ScaleFont(_ fontSize: CGFloat) -> UIFont{
    return v2Font(fontSize * CGFloat(CuStyle.sharedInstance.fontScale))
}

internal func Init<Type>(_ value : Type, block: (_ object: Type) -> Void) -> Type
{
    block(value)
    return value
}

func showMsg(_ uvc: UIViewController, title:String?,message:String?)
{
    if LBXScanWrapper.isSysIos8Later()
    {
        
        //if #available(iOS 8.0, *)
        
        let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title:  "知道了", style: UIAlertActionStyle.default)
        alertController.addAction(alertAction)
        uvc.present(alertController, animated: true, completion: nil)
    }
}
