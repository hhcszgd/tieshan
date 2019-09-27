//
//  CGRect-extension.swift
//  Project
//
//  Created by WY on 2019/9/18.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

extension CGRect {
    mutating func scaleWidthTo(_ value : CGFloat)  {
        if self.size.width == 0 {return}
        let scale =  value / self.size.width
        
        self.size.width = value
        self.size.height  = self.size.height * scale
    }
    mutating func scaleHeightTo(_ value : CGFloat)  {
        if self.size.height == 0 {return}
        let scale =  value / self.size.height
        
        self.size.height = value
        self.size.width  = self.size.width * scale
    }
}
