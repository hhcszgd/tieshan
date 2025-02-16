//
//  DDItem1NavVC.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit

class DDItem1NavVC: DDBaseNavVC {
    convenience init(){
        let rootVC = DDItem1VC()
        
        rootVC.title = "工作台"
//        rootVC.title = DDLanguageManager.text("tabbar_item1_title")
        self.init(rootViewController: rootVC)
        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.shadowImage = UIImage.getImage(startColor: UIColor.DDLightGray, endColor: .white, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1), size: CGSize(width: SCREENWIDTH, height: 10))
        self.tabBarItem.image = UIImage(named:"tab_icon_home_nor")
        self.tabBarItem.selectedImage = UIImage(named:"tab_icon_home_sel")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mylog(DDAccount.share.id)
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
