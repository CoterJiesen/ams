//
//  DataModel.swift
//  ams
//
//  Created by yangyuan on 2017/6/30.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//
import Alamofire
import SwiftyJSON
import UIKit


//let username = "huhdw_tianxing"
var deviceStatus = [8:"预领",9:"预占",7:"可用",11:"返修",10:"在用",12:"报废",13:"待回收",14:"回收",15:"待出库",16:"在途",17:"待返修",20:"已删除" ,21:"修改"]
var vendorDic = ["咪咕": "L1","华为":"L2","中兴":"L3"]

struct deviceInfo{
    var SN:     String
    var category: String?
    var vendor :String?
    var status :Int?
    var ret:    Int?   //0正常 2不在库中 1未盘点
    init(){
        category = ""
        vendor = ""
        status = 0
        SN = ""
        ret = -1
    }
}
struct useinfo{
    var used: Int?
    var all: Int?
    init(){
        used = 0
        all = 1
    }
}
struct checkDeviceInfo{
    var ret : Int?
    var countOfBin: Int?        //库存总量
    var countNoCheck: Int?      //未盘点    
    var countNotForMe:  Int?    //不在该班组库中
    var countNotInBin: Int?     //未入库
    var dvInfoList: [deviceInfo]?{
        didSet{
            countNoCheck = dvInfoList?.filter({ $0.ret == 1 }).count
            countNotForMe = dvInfoList?.filter({ $0.ret == 2 }).count
            countNotInBin = dvInfoList?.filter({ $0.ret == 3 }).count
        }
    }

    init(){
        dvInfoList = [deviceInfo]()
        ret = -1
        countOfBin = 0
        countNoCheck = 0
        countNotForMe = 0
        countNotInBin = 0
    }
}
struct allocfailDevice{
    var dvInfo: deviceInfo
    var reason: String?
    init(){
        dvInfo = deviceInfo()
        reason = ""
    }
}
struct allocHistory{
    var dvInfo: deviceInfo
    var name : String
    var time : String
    init(){
        dvInfo = deviceInfo()
        name = ""
        time = ""
    }
}
struct mangerInfo{
    var name: String
    var id: String
}

struct retAllocDeviceStatus{
    var sn:        String
    var ret:       Bool
    var failReason: String?
}


class DataModel {
    var deviceList: Array<deviceInfo>?
    var mangerList: Array<mangerInfo>?
    var numAvailDevice: Int = 0
    
    init() {
        self.deviceList = []
        self.mangerList = []
    }
    
    //h获取班主信息 可用设备列表和装维人员李彪
    class func getClassMonInfo(
        username aUsername: String ,
        completionHandler: @escaping (CuValueResponse<DataModel>)->Void
        )->Void{
        let data :DataModel = DataModel();

        Alamofire.request(AMSURL + "queryStores?username=" + aUsername, method: .post,  headers: MOBILE_CLIENT_HEADERS).responseJSON { response in
            switch response.result {
            case.success(let json):
                let mjson = JSON(json)
                if mjson.isEmpty{
                    return
                }
                var deviceinfo :deviceInfo = deviceInfo()
                var mangerinfo : mangerInfo = mangerInfo(name:"",id: "")
                for (_,subjson):(String,JSON) in mjson["teamStaff"]{
                    if let name = subjson["staffame"].string{
                        mangerinfo.name = name
                    }
                    if let id = subjson["staffid"].string{
                        mangerinfo.id = id
                    }
                    data.mangerList?.append(mangerinfo)
                }
                for (_,subjson):(String,JSON) in mjson["teamAsset"]{
                    if let sn = subjson["devsno"].string{
                       deviceinfo.SN =  sn
                    }else{
                        continue
                    }
                    if let category = subjson["category"].string{
                       deviceinfo.category = category
                    }
                    if let vendor = subjson["vendor"].string{
                       deviceinfo.vendor = vendor
                    }
                    if let status = subjson["status"].string {
                        deviceinfo.status = Int(status)
                        if deviceinfo.status == 7{
                            data.numAvailDevice += 1
                        }
                    }
                    data.deviceList?.append( deviceinfo)
                }
                let t =  CuValueResponse<DataModel>(value:data, success: response.result.isSuccess)
                completionHandler(t);
                
            case.failure(let error):
                print("\(error)")
            }
        }
    }
//    //设备查询
//    class func getDeviceInfo(
//        sn: String ,
//        completionHandler: @escaping (CuValueResponse<deviceInfo>)->Void
//        )->Void{
//        Alamofire.request(AMSURL + "queryController/queryAsset?SN=" + sn, method: .post,  headers: MOBILE_CLIENT_HEADERS).responseJSON { response in
//            switch response.result {
//            case.success(let json):
//                let subjson = JSON(json)
//                var deviceinfo :deviceInfo = deviceInfo(statusTime:"",opTime: "",status: 0 ,SN: "")
//                if subjson.isEmpty{
//                    let t =  CuValueResponse<deviceInfo>(value:deviceinfo, success: response.result.isSuccess)
//                    completionHandler(t);
//                    return
//                }
//                deviceinfo.statusTime = subjson["statustime"].string!
//                deviceinfo.opTime = subjson["opertime"].string!
//                deviceinfo.SN =  subjson["devsno"].string!
//                deviceinfo.status = (Int(subjson["status"].string!))!
//                let t =  CuValueResponse<deviceInfo>(value:deviceinfo, success: response.result.isSuccess)
//                completionHandler(t);
//                
//            case.failure(let error):
//                print("\(error)")
//            }
//        }
//    }
    class func getMangerList(
        classMonitor: String,
        completionHandler: @escaping (CuValueResponse<[String]>)->Void
    )->Void {
        var mangerList : Array<String> = []
        Alamofire.request(AMSURL + "queryController/queryStaff?username=" + classMonitor, method: .post,  headers: MOBILE_CLIENT_HEADERS).responseJSON { response in
            switch response.result {
            case.success(let json):
                let subjson = JSON(json)
                if subjson.isEmpty{
//                    let t =  CuValueResponse<deviceInfo>(value:deviceinfo, success: response.result.isSuccess)
                    let t =  CuValueResponse<[String]>(value:mangerList, success: response.result.isSuccess)
                    completionHandler(t);
                    return
                }
                for (_,subjson):(String,JSON) in subjson["list"]{
                    mangerList.append(subjson["staffame"].string!)
                }

                let t =  CuValueResponse<[String]>(value:mangerList, success: response.result.isSuccess)
                completionHandler(t);
                
            case.failure(let error):
                print("\(error)")
            }
        }
        
    }

    //分配领用接口
    class func alloctionDevice(staffID: String, strSns: String, username: String,completionHandler:
        @escaping (CuValueResponse<[retAllocDeviceStatus]>)->Void)->Void{
        var allocstatus = [retAllocDeviceStatus]()

        let parme = [
            "staffid": staffID,
            "sns": strSns,
            "username": username
        ]
        print(parme)
        Alamofire.request(AMSURL + "useAsset2", method: .post, parameters: parme, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                var flg = false
                var retStatus = retAllocDeviceStatus(sn: "", ret: false, failReason: "")
                for (_, subjson):(String, JSON) in JSON(json){
                    if let sn = subjson["devsno"].string{
                        retStatus.sn = sn
                    }else{
                        return
                    }
                    if let ret = subjson["ret"].string{
                        if ret == "0"{
                            retStatus.ret = true
                        }else{
                            retStatus.ret = false
                        }
                    }
                    if let failReason = subjson["reason"].string{
                        retStatus.failReason = failReason
                    }
                    allocstatus.append(retStatus)
                    flg = true
                }
                if flg{
                    completionHandler(CuValueResponse(value: allocstatus, success: true))
                }else{
                    completionHandler(CuValueResponse(value: allocstatus, success: false))
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    class func alloctionDeviceHistory( username: String,completionHandler:
        @escaping (CuValueResponse<[allocHistory]>)->Void)->Void{
        var listHistory = [allocHistory]()
        Alamofire.request(AMSURL + "usehistory?username=" + username, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
                switch response.result{
                case.success(let json):
                    var flg = false
                    let mjson = JSON(json)
                    var deviceinfo = allocHistory()
                    if mjson.isEmpty{
                        return
                    }
                    for (_,subjson):(String,JSON) in mjson{
                        if let sn = subjson["devsno"].string{
                            deviceinfo.dvInfo.SN =  sn
                        }else{
                            continue
                        }
                        if let category = subjson["category"].string{
                            deviceinfo.dvInfo.category = category
                        }
                        if let vendor = subjson["vendor"].string{
                            deviceinfo.dvInfo.vendor = vendor
                        }
                        if let allocattime = subjson["allocattime"].string {
                            deviceinfo.time = allocattime
                        }
                        if let staffname = subjson["staffname"].string {
                            deviceinfo.name = staffname
                        }
                        flg = true
                        listHistory.append(deviceinfo)
                    }
                    if flg{
                        completionHandler(CuValueResponse(value: listHistory, success: true))
                    }else{
                        completionHandler(CuValueResponse(value: listHistory, success: false))
                    }
                case.failure(let error):
                    print(error)
            }
        }
    }
    class func reporFalutDevice( username: String,completionHandler:
        @escaping (CuValueResponse<[deviceInfo]>)->Void)->Void{
        var listDeviceinfo = [deviceInfo]()
        Alamofire.request(AMSURL + "warningList?username=" + username, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                var flg = false
                let mjson = JSON(json)
                var deviceinfo = deviceInfo()
                if mjson.isEmpty{
                    return
                }
                for (_,subjson):(String,JSON) in mjson{
                    if let sn = subjson["devsno"].string{
                        deviceinfo.SN =  sn
                    }else{
                        continue
                    }
                    if let category = subjson["category"].string{
                        deviceinfo.category = category
                    }
                    if let vendor = subjson["vendor"].string{
                        deviceinfo.vendor = vendor
                    }
                    if let status = subjson["status"].string {
                        deviceinfo.status = Int(status)
                    }
                    flg = true
                    listDeviceinfo.append(deviceinfo)
                }
                if flg{
                    completionHandler(CuValueResponse(value: listDeviceinfo, success: true))
                }else{
                    completionHandler(CuValueResponse(value: listDeviceinfo, success: false))
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    //报障
    class func reportFalutDeviceAction(strSns: String, username: String,completionHandler:
        @escaping (CuValueResponse<[retAllocDeviceStatus]>)->Void)->Void{
        var allocstatus = [retAllocDeviceStatus]()
        
        let parme = [
            "sns": strSns,
            "username": username
        ]
        Alamofire.request(AMSURL + "warningUapdate", method: .post, parameters: parme, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                var flg = false
                var retStatus = retAllocDeviceStatus(sn: "", ret: false, failReason: "")
                for (_, subjson):(String, JSON) in JSON(json){
                    if let sn = subjson["devsno"].string{
                        retStatus.sn = sn
                    }else{
                        return
                    }
                    if let ret = subjson["ret"].string{
                        if ret == "0"{
                            retStatus.ret = true
                        }else{
                            retStatus.ret = false
                        }
                    }
                    if let failReason = subjson["reason"].string{
                        retStatus.failReason = failReason
                    }
                    allocstatus.append(retStatus)
                    flg = true
                }
                if flg{
                    completionHandler(CuValueResponse(value: allocstatus, success: true))
                }else{
                    completionHandler(CuValueResponse(value: allocstatus, success: false))
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    class func reportFalutDeviceHistory( username: String,completionHandler:
        @escaping (CuValueResponse<[allocHistory]>)->Void)->Void{
        var listHistory = [allocHistory]()
        Alamofire.request(AMSURL + "warninghistory?username=" + username, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                var flg = false
                let mjson = JSON(json)
                var deviceinfo = allocHistory()
                if mjson.isEmpty{
                    return
                }
                for (_,subjson):(String,JSON) in mjson{
                    if let sn = subjson["devsno"].string{
                        deviceinfo.dvInfo.SN =  sn
                    }else{
                        continue
                    }
                    if let category = subjson["category"].string{
                        deviceinfo.dvInfo.category = category
                    }
                    if let vendor = subjson["vendor"].string{
                        deviceinfo.dvInfo.vendor = vendor
                    }
                    if let allocattime = subjson["allocattime"].string {
                        deviceinfo.time = allocattime
                    }
                    if let staffname = subjson["staffname"].string {
                        deviceinfo.name = staffname
                    }
                    flg = true
                    listHistory.append(deviceinfo)
                }
                if flg{
                    completionHandler(CuValueResponse(value: listHistory, success: true))
                }else{
                    completionHandler(CuValueResponse(value: listHistory, success: false))
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    class func restitutionDevice( username: String,completionHandler:
        @escaping (CuValueResponse<[deviceInfo]>)->Void)->Void{
        var listDeviceinfo = [deviceInfo]()
        Alamofire.request(AMSURL + "returnlist?username=" + username, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                var flg = false
                let mjson = JSON(json)
                var deviceinfo = deviceInfo()
                if mjson.isEmpty{
                    return
                }
                for (_,subjson):(String,JSON) in mjson{
                    if let sn = subjson["devsno"].string{
                        deviceinfo.SN =  sn
                    }else{
                        continue
                    }
                    if let category = subjson["category"].string{
                        deviceinfo.category = category
                    }
                    if let vendor = subjson["vendor"].string{
                        deviceinfo.vendor = vendor
                    }
                    if let status = subjson["status"].string {
                        deviceinfo.status = Int(status)
                    }
                    flg = true
                    listDeviceinfo.append(deviceinfo)
                }
                if flg{
                    completionHandler(CuValueResponse(value: listDeviceinfo, success: true))
                }else{
                    completionHandler(CuValueResponse(value: listDeviceinfo, success: false))
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    //报障
    class func restitutionDeviceAction(strSns: String, username: String,completionHandler:
        @escaping (CuValueResponse<[retAllocDeviceStatus]>)->Void)->Void{
        var allocstatus = [retAllocDeviceStatus]()
        
        let parme = [
            "sns": strSns,
            "username": username
        ]
        Alamofire.request(AMSURL + "returnUapdate", method: .post, parameters: parme, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                var flg = false
                var retStatus = retAllocDeviceStatus(sn: "", ret: false, failReason: "")
                for (_, subjson):(String, JSON) in JSON(json){
                    if let sn = subjson["devsno"].string{
                        retStatus.sn = sn
                    }else{
                        return
                    }
                    if let ret = subjson["ret"].string{
                        if ret == "0"{
                            retStatus.ret = true
                        }else{
                            retStatus.ret = false
                        }
                    }
                    if let failReason = subjson["reason"].string{
                        retStatus.failReason = failReason
                    }
                    allocstatus.append(retStatus)
                    flg = true
                }
                if flg{
                    completionHandler(CuValueResponse(value: allocstatus, success: true))
                }else{
                    completionHandler(CuValueResponse(value: allocstatus, success: false))
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    class func restitutionDeviceHistory( username: String,completionHandler:
        @escaping (CuValueResponse<[allocHistory]>)->Void)->Void{
        var listHistory = [allocHistory]()
        Alamofire.request(AMSURL + "returnhistory?username=" + username, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                var flg = false
                let mjson = JSON(json)
                var deviceinfo = allocHistory()
                if mjson.isEmpty{
                    return
                }
                for (_,subjson):(String,JSON) in mjson{
                    if let sn = subjson["devsno"].string{
                        deviceinfo.dvInfo.SN =  sn
                    }else{
                        continue
                    }
                    if let category = subjson["category"].string{
                        deviceinfo.dvInfo.category = category
                    }
                    if let vendor = subjson["vendor"].string{
                        deviceinfo.dvInfo.vendor = vendor
                    }
                    if let allocattime = subjson["allocattime"].string {
                        deviceinfo.time = allocattime
                    }
                    if let staffname = subjson["staffname"].string {
                        deviceinfo.name = staffname
                    }
                    flg = true
                    listHistory.append(deviceinfo)
                }
                if flg{
                    completionHandler(CuValueResponse(value: listHistory, success: true))
                }else{
                    completionHandler(CuValueResponse(value: listHistory, success: false))
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    class func checkDevice(strSns: String, username: String,completionHandler:
        @escaping (CuValueResponse<checkDeviceInfo>)->Void)->Void{

        
        let parme = [
            "sns": strSns,
            "username": username
        ]
        Alamofire.request(AMSURL + "check", method: .post, parameters: parme, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                var flg = false
                let mjson = JSON(json)
                var checkinfo = checkDeviceInfo()
                var devinfolist = [deviceInfo]()
                if mjson.isEmpty{
                    return
                }
                if let ret = mjson["ret"].string{
                      checkinfo.ret = Int(ret)
                }else{
                    return
                }
                if let ret = mjson["allNum"].number{
                    checkinfo.countOfBin = Int(ret)
                }else{
                    return
                }
                for (_,subjson):(String,JSON) in mjson["asset"]{
                    var deviceinfo = deviceInfo()
                    if let ret = subjson["ret"].string ,ret != ""{
                        if ret == "0"{
                            continue
                        }
                        deviceinfo.ret = Int(ret)
                    }else{
                        continue
                    }
                    if let sn = subjson["devsno"].string, sn != ""{
                        deviceinfo.SN =  sn
                    }else{
                        continue
                    }
                    if let category = subjson["category"].string, category != ""{
                        deviceinfo.category = category
                    }
                    if let vendor = subjson["vendor"].string, vendor != ""{
                        deviceinfo.vendor = vendor
                    }
                    if let status = subjson["status"].string , status != ""{
                        deviceinfo.status = Int(status)
                    }
                    flg = true
                    devinfolist.append(deviceinfo)
                }
                if flg{
                    checkinfo.dvInfoList = devinfolist
                    completionHandler(CuValueResponse(value: checkinfo, success: true))
                }else{
                    completionHandler(CuValueResponse(value: checkinfo, success: false))
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    class func findAllandUsed( username: String,completionHandler:
        @escaping (CuValueResponse<useinfo>)->Void)->Void{
        Alamofire.request(AMSURL + "findAllAndUsd?username=" + username, headers: MOBILE_CLIENT_HEADERS).responseJSON{ response in
            switch response.result{
            case.success(let json):
                let mjson = JSON(json)
                var info = useinfo()
                if mjson.isEmpty{
                    return
                }
                if let use = mjson["use"].number{
                    info.used = Int(use)
                }
                if let all = mjson["all"].number{
                    info.all = Int(all)
                }
                completionHandler(CuValueResponse(value: info, success: true))
            case.failure(let error):
                print(error)
            }
        }
    }
    class func getVersionFromServer(completionHandler:
        @escaping (CuValueResponse<String>)->Void)->Void{
        Alamofire.request("https://git.oschina.net/coterjiesen/ios/raw/master/manifest.plist", method: .get, headers: MOBILE_CLIENT_HEADERS).responsePropertyList{ response in
            switch response.result{
            case.success(let plist):
                let meda = ((((plist as! NSDictionary)["items"]  as! NSArray)[0]) as! NSDictionary )["metadata"] as! NSDictionary
                let version = meda["bundle-version"] as! String
                completionHandler(CuValueResponse(value: version, success: true))
            case.failure(let error):
                print(error)
            }
        }
    }
}
