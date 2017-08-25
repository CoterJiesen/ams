//
//  CALayer_Extention.swift
//  ams
//
//  Created by yangyuan on 2017/8/24.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

extension CALayer{
    //颜色渐变
    func initCALayer(_ frame: CGRect, _ colors:[CGColor], _ points: [CGPoint]) {
        let layer:CAGradientLayer = CAGradientLayer()
        layer.frame = frame
        //设置渐变的颜色
//        layer.colors = [UIColor.init(colorLiteralRed: 178.0/255.0, green: 226.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor, UIColor.init(colorLiteralRed: 232.0/255.0, green: 244.0/255.0, blue: 193.0/255.0, alpha: 1.0).cgColor]
        
        layer.colors = colors
        //设置渐变的方向为从左到右
        layer.startPoint = points[0] //CGPoint(x: 0, y: 0)
        layer.endPoint = points[1] //CGPoint(x: 1, y: 1)
        addSublayer(layer)
    }
}
