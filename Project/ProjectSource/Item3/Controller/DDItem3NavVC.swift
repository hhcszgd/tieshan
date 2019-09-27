//
//  DDItem3NavVC.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit

class DDItem3NavVC: DDBaseNavVC {
    convenience init(){

        let rootVC = DDItem3VC()
        self.init(rootViewController: rootVC)
        self.title = "个人中心"
        self.navigationBar.isHidden = true
        
        self.navigationBar.shadowImage = UIImage()
        
        self.tabBarItem.image = UIImage(named:"tab_icon_profile_nor")
        self.tabBarItem.selectedImage = UIImage(named:"tab_icon_profile_sel")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
