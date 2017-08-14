//
//  CuClient.swift
//  ams
//
//  Created by coterjiesen on 2017/4/26.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit
import DrawerController

class CuClient: NSObject {
    static let sharedInstance = CuClient()
    
    var drawerController :DrawerController? = nil
    var centerViewController : HomeViewController? = nil
    var loginViewController : LoginViewController? = nil
    var centerNavigation : CuNavigationController? = nil
    
    // 当前程序中，最上层的 NavigationController
    var topNavigationController : UINavigationController {
        get{
            return CuClient.getTopNavigationController(CuClient.sharedInstance.centerNavigation!)
        }
    }
    
    fileprivate class func getTopNavigationController(_ currentNavigationController:UINavigationController) -> UINavigationController {
        if let topNav = currentNavigationController.visibleViewController?.navigationController{
            if topNav != currentNavigationController && topNav.isKind(of: UINavigationController.self){
                return getTopNavigationController(topNav)
            }
        }
        return currentNavigationController
    }
}
