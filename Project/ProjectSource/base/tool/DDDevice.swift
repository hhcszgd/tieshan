//
//  DDDevice.swift
//  Project
//
//  Created by WY on 2019/9/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
enum DeviceType:String {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6p
    case iphoneX
    case unkonw
}
class DDDevice: UIDevice {
   class var type : DeviceType{
        //竖屏模式下
        switch (UIScreen.main.bounds.height , UIScreen.main.bounds.width) {
        case (480 , 320) ,  (320 , 480 ):
            return .iPhone4
        case (568 , 320) , (320 ,568):
            return .iPhone5
        case (667,375) , (375 , 667):
            return .iPhone6
        case (736 , 414) , (414 , 736 ):
            return .iPhone6p
        case (812 , 375) , (375 , 812) , (414 , 896), (896 , 414  ):
            return .iphoneX
        default:
            return .unkonw
        }
    }
    
    
}
var _scale: CGFloat {
    get{
        let width: CGFloat = UIScreen.main.bounds.size.width
        if width > 375.0 {
            return CGFloat(1.10)
        }else if width < 321 {
            return CGFloat(0.85)
        }else {
            return 1
        }
    }
}
