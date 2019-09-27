//
//  VC+Extension.swift
//  Project
//
//  Created by WY on 2019/9/28.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import Foundation
extension UIViewController {
    func pushVC(vcIdentifier : String , userInfo:Any? = nil ) {
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"]as! String
        var clsName = vcIdentifier
        if !vcIdentifier.hasPrefix(namespace + ".") {
            clsName = namespace + "." + vcIdentifier
        }
        //UICollectionViewController
        if let cls = NSClassFromString(clsName) as? UICollectionViewController.Type{
            let vc = cls.init(collectionViewLayout: UICollectionViewFlowLayout())
            vc.userInfo = userInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }else if let cls = NSClassFromString(clsName) as? UIViewController.Type{
            let vc = cls.init()
            vc.userInfo = userInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print("there is no class:\(vcIdentifier)  from string:\(vcIdentifier)")
        }
    }
    static var userInfo: Void?
    /** key parameter of viewController */
    @IBInspectable var userInfo: Any? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.userInfo)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIViewController.userInfo, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    @discardableResult
    func alert(title:String = "提示",detailTitle:String? = nil ,style :UIAlertControllerStyle = UIAlertControllerStyle.alert ,actions:[UIAlertAction] ) -> UIAlertController{
        let actionVC = UIAlertController.init(title: title, message:detailTitle, preferredStyle: style)
        for action in actions{
            actionVC.addAction(action)
        }
        self.present(actionVC, animated: true, completion: nil)
        return actionVC
    }
    func openSetting(){
        DispatchQueue.main.async {
            let url : URL = URL(string: UIApplicationOpenSettingsURLString)!
            if UIApplication.shared.canOpenURL(url ) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [String : Any](), completionHandler: { (bool ) in
                        
                    })
                } else {
                    // Fallback on earlier versions
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
}
