//
//  UINavigationBar_Extention.swift
//  ams
//
//  Created by yangyuan on 2017/8/1.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

// MARK: - 扩展 UINavigationBar 显示/隐藏 黑色线条
extension UINavigationBar {
    
    func hideBottomHairLine() {
        let navigationBarImageView = hairLineImageViewInNavigationBar(view: self)
        navigationBarImageView?.isHidden = true
    }
    
    func showBottomHairLine() {
        let navigationBarImageView = hairLineImageViewInNavigationBar(view: self)
        navigationBarImageView?.isHidden = false
    }
    
    func hairLineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subViews = (view.subviews as [UIView])
        for subView: UIView in subViews {
            if let imageView: UIImageView = hairLineImageViewInNavigationBar(view: subView) {
                return imageView
            }
        }
        return nil
    }
}

