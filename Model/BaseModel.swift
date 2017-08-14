//
//  BaseModel.swift
//  ams
//
//  Created by coterjiesen on 2017/4/25.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

import ObjectMapper
import Ji

class BaseJsonModel: Mappable {
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
    }
}


protocol BaseHtmlModelProtocol {
    init(rootNode:JiNode)
}

