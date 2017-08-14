//
//  CuSetting.swift
//  ams
//
//  Created by coterjiesen on 2017/4/20.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

let keyPrefix =  "me.fin.CuSettings."

class CuSettings: NSObject {
    static let sharedInstance = CuSettings()
    fileprivate override init(){
        super.init()
    }
    
    subscript(key:String) -> String? {
        get {
            return UserDefaults.standard.object(forKey: keyPrefix + key) as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyPrefix + key )
        }
    }
}
