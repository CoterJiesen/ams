//
//  UIButton+Extension.swift
//  ams
//
//  Created by coterjiesen on 2017/5/17.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//
import UIKit
//import Foundation

extension UIButton {
  
    func latout(isTop :Bool,space :CGFloat){

        self.contentEdgeInsets = .zero
        self.imageEdgeInsets = .zero
        self.titleEdgeInsets = .zero
        self.setNeedsLayout()
        self.layoutIfNeeded()

        
        let contentRect:CGRect = self.frame//self.bounds;
        let titleSize :CGSize = self.titleRect(forContentRect: contentRect).size;
        let imageSize :CGSize = self.imageRect(forContentRect: contentRect).size;
        
        let halfWidth :CGFloat = (titleSize.width + imageSize.width) / 2 ;
        let halfHeight :CGFloat = (titleSize.height + imageSize.height) / 2;
        
        let topInset :CGFloat = min(halfHeight, titleSize.height);
        var leftInset :CGFloat = (titleSize.width - imageSize.width)
        if leftInset > 0 {
            leftInset = leftInset / 2
        }else {
            leftInset = 0
        }
        
        var bottomInset :CGFloat = (titleSize.height - imageSize.height)
        if bottomInset > 0 {
            bottomInset = bottomInset / 2
        }else{
            bottomInset = 0
        }
        
        let rightInset :CGFloat = min(halfWidth, titleSize.width);
        
        if (isTop) {
            self.titleEdgeInsets = UIEdgeInsetsMake(-halfHeight-space,-halfWidth, halfHeight+space, halfWidth);
          //  self.contentEdgeInsets = UIEdgeInsetsMake(topInset+space, leftInset, -bottomInset, -rightInset)
            self.imageEdgeInsets = UIEdgeInsetsMake(topInset+space, leftInset, -bottomInset, -rightInset)
        } else {
            self.titleEdgeInsets = UIEdgeInsetsMake(halfHeight+space, -halfWidth, -halfHeight-space, halfWidth);
         //   self.contentEdgeInsets = UIEdgeInsetsMake(-bottomInset, leftInset, topInset+space, -rightInset)
            self.imageEdgeInsets = UIEdgeInsetsMake(-bottomInset, leftInset, topInset+space, -rightInset)
        }
    }
    func alignContentVerticallyByCenter(offset:CGFloat = 10) {
        let buttonSize = frame.size
        
        if let titleLabel = titleLabel,
            let imageView = imageView {
            
            if let buttonTitle = titleLabel.text,
                let image = imageView.image {
                let titleString:NSString = NSString(string: buttonTitle)
                let titleSize = titleString.size(attributes: [
                    NSFontAttributeName : titleLabel.font
                    ])
                let buttonImageSize = image.size
                
                let topImageOffset = (buttonSize.height - (titleSize.height + buttonImageSize.height + offset)) / 2
                let leftImageOffset = (buttonSize.width - buttonImageSize.width) / 2
                imageEdgeInsets = UIEdgeInsetsMake(topImageOffset,
                                                   leftImageOffset,
                                                   0,0)
                
                let titleTopOffset = topImageOffset + offset + buttonImageSize.height
                let leftTitleOffset = (buttonSize.width - titleSize.width) / 2 - image.size.width
                
                titleEdgeInsets = UIEdgeInsetsMake(titleTopOffset,
                                                   leftTitleOffset,
                                                   0,0)
            }
        }
    }
}
