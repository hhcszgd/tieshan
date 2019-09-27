//
//  CustomTextfield.swift
//  Project
//
//  Created by w   y on 2019/9/14.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class CustomTextfield: UITextField {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(lineColor.cgColor)
        context?.fill(CGRect.init(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
    }

}
