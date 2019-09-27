//
//  ViewController.swift
//  Project
//
//  Created by WY on 2019/9/16.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configRootVC() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        if false  {
            let rootVC = DDNewFeature(isNewVersion: true)
            rootVC.done = {
                self.configRootVC()
            }
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
            return
        }
        let isLogin = DDAccount.share.isLogin
        if isLogin{
            let rootNavVC = DDRootNavVC()
            window.rootViewController = rootNavVC
            window.makeKeyAndVisible()
        }else{
            let loginVC = DDLoginVC()
            let naviVC = UINavigationController.init(rootViewController: loginVC)
            naviVC.navigationBar.isHidden  = true
            window.rootViewController = naviVC
            window.makeKeyAndVisible()
        }
    }

}

