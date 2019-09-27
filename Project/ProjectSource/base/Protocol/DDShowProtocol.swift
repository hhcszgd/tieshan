//
//  DDShowProtocol.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit
protocol DDShowProtocol : NSObjectProtocol{
    var isNeedJudge : Bool{get set}
    var actionKey : String{get set}
    var keyParameter : Any?{get set }
}
