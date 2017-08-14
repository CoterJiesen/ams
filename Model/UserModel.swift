//
//  UserModel.swift
//  ams
//
//  Created by coterjiesen on 2017/4/18.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserInfo{
    var username:String?
    var group:String?
    init(){
        username = ""
        group = ""
    }
}
class UserModel: BaseJsonModel {
    var status:String?
    var id:String?
    var url:String?
    var username:String?
    var Countlogin:String?
    var admintime:String?
    var ip:String?
    var netIn:String?
    var putaway:String?
    var putout:String?
    var repair:String?
    var scrap:String?
    var avatar_normal:String?
    var avatar_large:String?
    var created:String?
    
}

//MARK: - Request
extension UserModel{
    /*
        获取验证码
        - parameter completionHandler: 登录回调
     */
    class func getCapcha(_ completionHandler:@escaping (_ response:CuValueResponse<String>,_ cap:UIImage) -> Void)->Void{
        CuUser.sharedInstance.removeAllCookies()
        Alamofire.request(AMSURL+"code.do").responseData { response in
            if let data = response.result.value {
                let cap = UIImage(data:data)
                if nil != cap {
                       completionHandler(CuValueResponse(success: true),cap!)
                }else{
                    completionHandler(CuValueResponse(success: false,message: "获取验证码失败"),UIImage(named:"cap_err.png")!)
                }
            }else{
                completionHandler(CuValueResponse(success: false,message: "获取验证码失败"),UIImage(named:"cap_err.png")!)
            }
        }
    }

    /**
     登录
     - parameter username:          用户名
     - parameter password:          密码
     - parameter completionHandler: 登录回调
     */
    class func Login(_ username:String,password:String ,captcha:String,
                     completionHandler: @escaping (_ response:CuValueResponse<String>,_ url:String) -> Void
        ) -> Void{
        
        let prame = [
            "userName":username,
            "password":password,
            "rand":captcha
        ]
        Alamofire.request(AMSURLLogin+"index/login.html", method: .post, parameters: prame, headers: MOBILE_CLIENT_HEADERS).responseJSON { response in
            if let json = response.result.value as? [String: Any]{
                let msg = json["msg"] as! String
                completionHandler(CuValueResponse(value:username,success: true,message: msg),"")
                return
            }
            completionHandler(CuValueResponse(success: false,message: "登陆失败"),"")
        }
    }
    
    class func getUserInfoByUsername( username: String,completionHandler:
        @escaping (CuValueResponse<UserInfo>)->Void)->Void{
        var  userInfo = UserInfo()
        Alamofire.request(AMSURL + "querygroup?username=" + username, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                let group = JSON(json)["group"].string
                userInfo.group = group
                userInfo.username = username
                completionHandler(CuValueResponse(value: userInfo, success: true))
            case.failure(let error):
                print(error)
            }
        }
    }

}
