//
//  DDShowManager.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit


///:the  old  skipManager
class DDShowManager: NSObject {
    class func whow(currentVC : UIViewController , showParameter : DDShowProtocol){
        if showParameter.isNeedJudge {
            //perform login
            
            return
        }
        guard  let  destinationVC : DDViewController = getDestinationVC(showParameter: showParameter)else { return}
        destinationVC.showModel  = showParameter
        if let naviVC  = currentVC as? UINavigationController {
            naviVC.pushViewController(destinationVC, animated: true )
        }else{
            currentVC.navigationController?.pushViewController(destinationVC, animated: true )
        }
    }
    
//    class func skip(current: UIViewController?, model: GDModel) {
//        if model.isNeedJudge {
//
//            if !DDAccount.share.isLogin {
//                current?.navigationController?.pushViewController(DDLoginVC(), animated: true)
//                return
//            }
//
//        }
//        guard let vc = self.nextVC(model: model) as? GDNormalVC else {
//            return
//        }
//        vc.keyModel = model
//        current?.navigationController?.pushViewController(vc, animated: true)
//
//    }
    
    private class func getDestinationVC(showParameter:DDShowProtocol) -> DDViewController? {
        switch showParameter.actionKey {
        case "WEB":
            return GDBaseWebVC()
        default:
            mylog("找不到对应的控制器")
            return nil
        }
    }
//    private class func nextVC(model: GDModel) -> UIViewController? {
//        switch model.actionKey {
//
//        default:
//            return nil
//        }
//
//    }
    
    
//    class func whow(viewController : DDViewController , model : DDShowProtocol){
//        mylog("当前actionKey为\(model.actionkey)")
//        guard var realActionKey = model.actionkey else {
//            return
//        }
//        if model.judge && !Account.shareAccount.isLogin {
//            mylog("当前处于登录状态 , 执行跳转")
//            realActionKey = "Login"
//        }
//        var targetVC : GDBaseVC?
//        switch realActionKey {
//        case "goodscollect" , "shopcollect" , "focusbrand" , "pay", "ship", "receive", "comment", "over", "balance", "coupons", "coins", "help" , "order" , "my_capital" , "member_club" , "webpage" : //webViewVC
//            targetVC = GDBaseWebVC()
//            break
//        case "info"://查看用户信息
//            mylog("跳转到个人信息页面")
//            break
//        case "QRCodeScannerVC":
//            targetVC = QRCodeScannerVC()
//            break
//        case "set":
//            targetVC = SettingVC()
//            break        case "Login"://执行登录操作
//                let loginVC = LoginVC()
//                let loginNaviVC = LoginNaviVC(rootViewController: loginVC)
//                loginNaviVC.navigationBar.isHidden = true
//                viewController.navigationController?.present(loginNaviVC, animated: true, completion: nil)
//            return
//        case "ChooseLuanguageVC":
//            targetVC = ChooseLanguageVC()
//            break
//        case "GDMapVC":
//            targetVC = GDMapVC()
//            break
//            
//        default:
//            mylog("\(realActionKey)是无效actionKey ,找不到跳转控制器")
//        }
//        
//        if let vc = targetVC {
//            vc.keyModel = model
//            if let naviVC  = viewController as? UINavigationController {
//                naviVC.pushViewController(vc, animated: true )
//            }else{
//                viewController.navigationController?.pushViewController(vc, animated: true )
//            }
//        }
//        
//    }
}
