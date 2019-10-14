//
//  DDHomeModel.swift
//  Project
//
//  Created by WY on 2019/9/5.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit


class test : NSObject , Decodable {
    var isNeedJudge: Bool = false
    var actionKey: String = ""
    var keyParameter: Any? = nil
    private enum CodingKeys: String, CodingKey  {
        case isNeedJudge
        case actionKey
        case keyParameter
    }
    
    required init(from decoder: Decoder) throws{
        var container = try decoder.container(keyedBy: CodingKeys.self)
        isNeedJudge = try container.decode(type(of: isNeedJudge), forKey: test.CodingKeys.isNeedJudge)
        //           var container =  try decoder.container(keyedBy: CodingKeys.self)
        //        var container = decoder.container(keyedBy: CodingKeys.self)
        //            try container.decode(isNeedJudge, forKey:.isNeedJudge)
        //        try container.decode(isNeedJudge, forKey: DDActionModel.CodingKeys.isNeedJudge)
    }
}

class DDActionModel: NSObject , DDShowProtocol {
    var isNeedJudge: Bool = false
    var actionKey: String = ""
    var keyParameter: Any? = nil
}
///data模型
class HomeDataModel   : NSObject , Codable{
    var banners : [DDHomeBannerModel] = [DDHomeBannerModel]()
    var lastestMessage : DDHomeMsgModel?
    var functionSessions :  [DDHomeFoundationSesstion]?
}

///banner图
class DDHomeBannerModel:   Codable{
    var image_url : String? = ""
    var link_url : String? = ""
    var actionType : String?
}
///轮播消息
class DDHomeMsgModel:   Codable {
    var id : String?    = ""
    var title : String? = ""
}
///模块儿
class DDHomeFoundationSesstion : Codable{
    var title : String?
    var functions : [DDHomeFoundation]?
}

class DDHomeFoundation :  Codable {
    var id :  String?
    var name : String = ""
    var image_url : String? = ""
    var target :String? = ""
    var status : String?
    var link_url : String?
    var actionType : String?
}


func getHomeData() -> HomeDataModel?{
    
   var admin =  """
{
 "banners" : [
            {"image_url":"https://pics1.baidu.com/feed/2e2eb9389b504fc2792f69ed91d09e1491ef6dfd.jpeg?token=7845b4cd703aa421ee2bd02596a03b68&s=A525D4144E38148E9123E8C90300F09B" , "actionType":""}
        ],
        "lastestMessage":{"title":"newest message " , "id" :"2222"},
        "functionSessions" : [
            {
                "title" : "业务部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "创建车源",
                        "image_url"  : "home-icon-chuangjiancheyuan",
                        "actionType" : "ChuangJianCheYuan"
                    },
                    {
                        "id" : "33" ,
                        "name" : "查看车源",
                        "image_url"  : "home-icon-chakancheyuan",
                        "actionType" : "ChaKanCheYuan"
                    },
                    {
                        "id" : "33" ,
                        "name" : "核档已通过",
                        "image_url"  : "home-icon-hedangyitongguo",
                        "actionType" : "HeDangTongGuo"
                    }
                ]
                
            },
            {
                "title" : "手续部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "车辆入场",
                        "image_url"  : "home-icon-shouxubu1",
                        "actionType" : "CheLiangRuChang"
                    },
                    {
                        "id" : "33" ,
                        "name" : "等待初检",
                        "image_url"  : "home_icon_shouxubu2",
                        "actionType" : "DengDaiChuJian"
                    },
                    {
                        "id" : "33" ,
                        "name" : "等待预处理",
                        "image_url"  : "home-icon-shouxubu3",
                        "actionType" : "DengDaiYuChuLi"
                    },
                    {
                        "id" : "33" ,
                        "name" : "等待拓号",
                        "image_url"  : "home_icon_shouxubu4",
                        "actionType" : "DengDaiTuoHao"
                    },
                    {
                        "id" : "33" ,
                        "name" : "拆解方式",
                        "image_url"  : "home_icon_shouxubu5",
                        "actionType" : "ChaiJieFangShiShouXuBu"
                    },
                    {
                        "id" : "33" ,
                        "name" : "存放位置",
                        "image_url"  : "home_icon_shouxubu6",
                        "actionType" : "CunFangWeiZhi"
                    },
                    {
                        "id" : "33" ,
                        "name" : "待毁形车辆",
                        "image_url"  : "home_icon_shouxubu7",
                        "actionType" : "DaiHuiXingCheLiang"
                    },
                    {
                        "id" : "33" ,
                        "name" : "已毁形",
                        "image_url"  : "home_icon_shouxubu8",
                        "actionType" : "YiHuiXing"
                    }
                ]
                
            } ,
            {
                "title" : "拆解部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "监销车辆",
                        "image_url"  : "home_icon_chaijiebu1",
                        "actionType" : "JianXiaoCheLiang"
                    },
                    {
                        "id" : "33" ,
                        "name" : "已入库",
                        "image_url"  : "home_icon_chaijiebu2",
                        "actionType" : "YiRuKu"
                    },
                    {
                        "id" : "33" ,
                        "name" : "未拆解",
                        "image_url"  : "home_icon_chaijiebu3",
                        "actionType" : "WeiChaiJie"
                    },
                    {
                        "id" : "33" ,
                        "name" : "拆过的车",
                        "image_url"  : "home_icon_chaijiebu4",
                        "actionType" : "ChaiGuoDeChe"
                    }
                ]
                
            } ,
            {
                "title" : "外勤部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "核档未通过",
                        "image_url"  : "home_icon_waiqinbu1",
                        "actionType" : "HeDangWeiTongGuo"
                    },
                    {
                        "id" : "33" ,
                        "name" : "核档已通过",
                        "image_url"  : "home_icon_waiqinbu2",
                        "actionType" : "HeDangYiTongGuo"
                    },
                    {
                        "id" : "33" ,
                        "name" : "未核档",
                        "image_url"  : "home_icon_waiqinbu3",
                        "actionType" : "WeiHeDang"
                    }
                ]
                
            },
            {
                "title" : "库管部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "入库管理",
                        "image_url"  : "home_icon_waiqinbu1",
                        "actionType" : "RuKuGuanLi"
                    }
                ]
                
            }
        
        ]
    

}
"""
    let chaiJieBu = """
{
 "banners" : [
            {"image_url":"https://pics1.baidu.com/feed/2e2eb9389b504fc2792f69ed91d09e1491ef6dfd.jpeg?token=7845b4cd703aa421ee2bd02596a03b68&s=A525D4144E38148E9123E8C90300F09B" , "actionType":""}
        ],
        "lastestMessage":{"title":"newest message " , "id" :"2222"},
        "functionSessions" : [
            {
                "title" : "拆解部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "监销车辆",
                        "image_url"  : "home_icon_chaijiebu1",
                        "actionType" : "JianXiaoCheLiang"
                    },
                    {
                        "id" : "33" ,
                        "name" : "已入库",
                        "image_url"  : "home_icon_chaijiebu2",
                        "actionType" : "YiRuKu"
                    },
                    {
                        "id" : "33" ,
                        "name" : "未拆解",
                        "image_url"  : "home_icon_chaijiebu3",
                        "actionType" : "WeiChaiJie"
                    },
                    {
                        "id" : "33" ,
                        "name" : "拆过的车",
                        "image_url"  : "home_icon_chaijiebu4",
                        "actionType" : "ChaiGuoDeChe"
                    }
                ]
                
            }
        
        ]
    

}
"""
    
    let shouXuBu =  """
{
 "banners" : [
            {"image_url":"https://pics1.baidu.com/feed/2e2eb9389b504fc2792f69ed91d09e1491ef6dfd.jpeg?token=7845b4cd703aa421ee2bd02596a03b68&s=A525D4144E38148E9123E8C90300F09B" , "actionType":""}
        ],
        "lastestMessage":{"title":"newest message " , "id" :"2222"},
        "functionSessions" : [
            
            {
                "title" : "手续部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "车辆入场",
                        "image_url"  : "home-icon-shouxubu1",
                        "actionType" : "CheLiangRuChang"
                    },
                    {
                        "id" : "33" ,
                        "name" : "等待初检",
                        "image_url"  : "home_icon_shouxubu2",
                        "actionType" : "DengDaiChuJian"
                    },
                    {
                        "id" : "33" ,
                        "name" : "等待预处理",
                        "image_url"  : "home-icon-shouxubu3",
                        "actionType" : "DengDaiYuChuLi"
                    },
                    {
                        "id" : "33" ,
                        "name" : "等待拓号",
                        "image_url"  : "home_icon_shouxubu4",
                        "actionType" : "DengDaiTuoHao"
                    },
                    {
                        "id" : "33" ,
                        "name" : "拆解方式",
                        "image_url"  : "home_icon_shouxubu5",
                        "actionType" : "ChaiJieFangShiShouXuBu"
                    },
                    {
                        "id" : "33" ,
                        "name" : "存放位置",
                        "image_url"  : "home_icon_shouxubu6",
                        "actionType" : "CunFangWeiZhi"
                    },
                    {
                        "id" : "33" ,
                        "name" : "待毁形车辆",
                        "image_url"  : "home_icon_shouxubu7",
                        "actionType" : "DaiHuiXingCheLiang"
                    },
                    {
                        "id" : "33" ,
                        "name" : "已毁形",
                        "image_url"  : "home_icon_shouxubu8",
                        "actionType" : "YiHuiXing"
                    }
                ]
                
            }
        ]
    

}
"""
    let waiQinBu =  """
{
 "banners" : [
            {"image_url":"https://pics1.baidu.com/feed/2e2eb9389b504fc2792f69ed91d09e1491ef6dfd.jpeg?token=7845b4cd703aa421ee2bd02596a03b68&s=A525D4144E38148E9123E8C90300F09B" , "actionType":""}
        ],
        "lastestMessage":{"title":"newest message " , "id" :"2222"},
        "functionSessions" : [
            {
                "title" : "外勤部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "核档未通过",
                        "image_url"  : "home_icon_waiqinbu1",
                        "actionType" : "HeDangWeiTongGuo"
                    },
                    {
                        "id" : "33" ,
                        "name" : "核档已通过",
                        "image_url"  : "home_icon_waiqinbu2",
                        "actionType" : "HeDangYiTongGuo"
                    },
                    {
                        "id" : "33" ,
                        "name" : "未核档",
                        "image_url"  : "home_icon_waiqinbu3",
                        "actionType" : "WeiHeDang"
                    }
                ]
                
            }
        
        ]
    

}
"""
    let yeWuBu =  """
{
 "banners" : [
            {"image_url":"https://pics1.baidu.com/feed/2e2eb9389b504fc2792f69ed91d09e1491ef6dfd.jpeg?token=7845b4cd703aa421ee2bd02596a03b68&s=A525D4144E38148E9123E8C90300F09B" , "actionType":""}
        ],
        "lastestMessage":{"title":"newest message " , "id" :"2222"},
        "functionSessions" : [
            {
                "title" : "业务部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "创建车源",
                        "image_url"  : "home-icon-chuangjiancheyuan",
                        "actionType" : "ChuangJianCheYuan"
                    },
                    {
                        "id" : "33" ,
                        "name" : "查看车源",
                        "image_url"  : "home-icon-chakancheyuan",
                        "actionType" : "ChaKanCheYuan"
                    },
                    {
                        "id" : "33" ,
                        "name" : "核档已通过",
                        "image_url"  : "home-icon-hedangyitongguo",
                        "actionType" : "HeDangTongGuo"
                    }
                ]
                
            }
        ]
    

}
"""
let kuGuanBu =  """
{
 "banners" : [
            {"image_url":"https://pics1.baidu.com/feed/2e2eb9389b504fc2792f69ed91d09e1491ef6dfd.jpeg?token=7845b4cd703aa421ee2bd02596a03b68&s=A525D4144E38148E9123E8C90300F09B" , "actionType":""}
        ],
        "lastestMessage":{"title":"newest message " , "id" :"2222"},
        "functionSessions" : [
            {
                "title" : "库管部",
                "functions" : [
                    {
                        "id" : "33" ,
                        "name" : "入库管理",
                        "image_url"  : "home-icon-chuangjiancheyuan",
                        "actionType" : "RuKuGuanLi"
                    }
                    
                ]
                
            }
        ]
    

}
"""
    
    var json =  ""
    switch DDAccount.share.departmentType {
    case .admin:
        json = admin
    case .chaiJieBu:
        json = chaiJieBu
    case .shouXuBu:
        json = shouXuBu
    case .waiQinBu:
        json = waiQinBu
    case .yeWuBu:
        json = yeWuBu
    case .kuGuanBu:
    json = kuGuanBu
    }
    
    let jsonDecoder = JSONDecoder()
    do {
       let result =  try jsonDecoder.decode(HomeDataModel.self , from: json.data(using: String.Encoding.utf8)!)
        return result
    } catch   {
        mylog(error )
    }
    return nil
}
