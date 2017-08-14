//
//  CuUser.swift
//  ams
//
//  Created by coterjiesen on 2017/4/25.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//


import UIKit
import Alamofire
import Ji

let kUserName = "me.fin.username"

class CuUser: NSObject {
    static let sharedInstance = CuUser()
    /// 用户信息
    fileprivate var _user:UserInfo?
    var user:UserInfo? {
        get {
            return self._user
        }
        set {
            //保证给user赋值是在主线程进行的
            //原因是 有很多UI可能会监听这个属性，这个属性发生更改时，那些UI也会相应的修改自己，所以要在主线程操作
            dispatch_sync_safely_main_queue {
                self._user = newValue
                self.username = newValue?.username
            }
        }
    }
    
    dynamic var username:String?
    
    dynamic var isCheckLogin:Bool = false
    
    /// 通知数量
    dynamic var notificationCount:Int = 0
    
    
    
    fileprivate override init() {
        super.init()
        dispatch_sync_safely_main_queue {
            self.setup()
            //如果客户端是登录状态，则去验证一下登录有没有过期
            if self.isLogin {
                self.verifyLoginStatus()
            }
        }
    }
    func setup(){
        self.username = CuSettings.sharedInstance[kUserName]
    }
    
    
    /// 是否登录
    var isLogin:Bool {
        get {
            if let len = self.username?.Lenght , len > 0 {
                return true
            }
            else {
                return false
            }
        }
    }
    
    func ensureLoginWithHandler(_ handler:()->()) {
        guard isLogin else {
            CuInform("请先登录")
            return;
        }
        handler()
    }
    /**
     退出登录
     */
    func loginOut() {
        removeAllCookies()
        self.user = nil
        self.username = nil
        self.notificationCount = 0
        //清空settings中的username
        CuSettings.sharedInstance[kUserName] = nil
    }
    
    /**
     删除客户端所有cookies
     */
    func removeAllCookies() {
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
    }
    /**
     打印客户端cookies
     */
    func printAllCookies(){
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                NSLog("name:%@ , value:%@ \n", cookie.name,cookie.value)
            }
        }
    }
    
    

    /**
     验证客户端登录状态
     //TO DO
     - returns: ture: 正常登录 ,false: 登录过期，没登录
     */
    func verifyLoginStatus() {
        Alamofire.request(AMSURL + "main/showIndexOInfo", method:.post, headers: MOBILE_CLIENT_HEADERS).validate().responseString(encoding: nil) { (response) -> Void in
            print("检查登录状态！")
//            switch response.result {
//            case .success(let value):
//                let res = response.result.value
//                if (res?.contains("/REST/login.html"))!{
//                    print("登录过期")
//                    //没有登录 ,注销客户端
//                    dispatch_sync_safely_main_queue({ () -> () in
//                        self.loginOut()
//                    })
//                }
//                print("check_info:\(value)")
//            case .failure(let error):
//                dispatch_sync_safely_main_queue({ () -> () in
//                    self.loginOut()
//                })
//                print(error)
//            }
            //检查登录
            self.isCheckLogin = true
        }
    }
}
