//
//  DDTableView.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit

class DDTableView: UITableView {
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
