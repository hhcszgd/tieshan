//
//  DDRootTabBarVC.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit
fileprivate let maincolor = UIColor.colorWithRGB(red: 69, green: 134, blue: 217)
class DDRootTabBarVC: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setViewControllers(self.childVCToBeAdd() , animated: false)
        self.tabBar.tintColor = maincolor//选中是,文字的颜色
        self.tabBar.barTintColor = UIColor.white//colorWithHexStringSwift("F5F5F5")//bar的背景色
        //去黑线
        self.tabBar.shadowImage = UIImage()
//        self.tabBar.backgroundImage = UIImage()
    }
    func childVCToBeAdd() -> [UIViewController] {
        var controllers = [UIViewController]()
        controllers.append(DDItem2NavVC())
        controllers.append(DDItem1NavVC())
        controllers.append(DDItem3NavVC())
        
        return controllers
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func reset() {
        self.setViewControllers(self.childVCToBeAdd(), animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
