//
//  UILabel_extension.swift
//  Project
//
//  Created by JohnConnor on 2019/10/1.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//
import UIKit
extension UILabel {
    convenience init(title : String = "", font:UIFont = UIFont.systemFont(ofSize: 16) , color textColor: UIColor = UIColor.darkGray, align textAlignment: NSTextAlignment = .left){
        self.init()
        self.text = title
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}
