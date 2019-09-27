//
//  DDCollectionReusableView.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCollectionReusableView: UICollectionReusableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        func showSubviews(isShow:Bool){
            for (_ , subview ) in self.subviews.enumerated(){
                subview.isHidden = !isShow
            }
        }
        if self.bounds.height <= 0  || self.isHidden{
            showSubviews(isShow: false)
        }else{
            showSubviews(isShow: true)
        }
    }
}
