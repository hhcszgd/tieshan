//
//  DDFucnEditApiModel.swift
//  Project
//
//  Created by WY on 2019/9/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDFucnEditApiModel: NSObject,Codable {
    var status: Int = -1
    var message:String = ""
    var data : DDFuncEditApiModel = DDFuncEditApiModel()
}

class DDFuncEditApiModel: DDActionModel ,Codable{
    var member_function : [DDFuncItemModel]?
    var system_function : [DDFuncItemModel]?
}

class DDFuncItemModel: DDActionModel,Codable {
    var id : String = ""
    var name: String = ""
    var image_url:String = ""
    var target:String = ""
    var link_url : String?
}
