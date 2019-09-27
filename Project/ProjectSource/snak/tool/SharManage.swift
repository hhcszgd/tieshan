//
//  SharManage.swift
//  zuidilao
//
//  Created by w   y on 2019/9/21.
//  Copyright © 2019年 w   y. All rights reserved.
//

import UIKit

class SharManage: NSObject {
    static let shar = SharManage.init()
    private override init() {
        super.init()
    }
    
    func share() {
        
   UMSocialShareUIConfig.shareInstance().sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType.middle
    UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.sina.rawValue, UMSocialPlatformType.wechatSession.rawValue,UMSocialPlatformType.QQ.rawValue, UMSocialPlatformType.wechatTimeLine.rawValue])
    UMSocialUIManager.showShareMenuViewInWindow { (type, userInfo) in
        self.shareWebPageToPlatformType(type: type)
    }
        
    }
    
    func shareWebPageToPlatformType(type: UMSocialPlatformType) {
        let messageObject = UMSocialMessageObject.init()
        
        UMSocialManager.default().share(to: type, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            
            
        })
        
    }
        
        
        
        
}
    

