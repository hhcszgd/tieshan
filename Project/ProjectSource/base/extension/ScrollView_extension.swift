//
//  ScrollView_extension.swift
//  Project
//
//  Created by w   y on 2019/9/3.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import Foundation

extension UIScrollView {
    func configContentOffset(subView: UIView) {
        if DDKeyBoardHandler.manager.keyboardY > 0 {
            DDKeyBoardHandler.manager.configContentSet(containerView: subView, inputView: self)
        }else {
            DDKeyBoardHandler.manager.zkqsetViewToBeDealt(containerView: subView, inPutView: self)
        }
    }
}
