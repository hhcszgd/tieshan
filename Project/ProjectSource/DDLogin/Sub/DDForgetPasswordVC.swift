//
//  DDForgetPasswordVC.swift
//  Project
//
//  Created by WY on 2019/9/22.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDForgetPasswordVC: DDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "忘记密码"
        // Do any additional setup after loading the view.
    }
    @IBAction func telTapAction(_ sender: UIButton) {
        makeCall()
    }
    
    func makeCall() {
        var actions = [DDAlertAction]()
        
        let sure = DDAlertAction(title: "拨打电话",textColor:mainColor, style: UIAlertActionStyle.default, handler: { (action ) in
            print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
            UIApplication.shared.openURL(URL(string: "telprompt:4006113233")!)
        })
        
        let cancel = DDAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action ) in
            print("cancel update")
        })
        actions.append(cancel)
        actions.append(sure)
        
        let alertView = DDAlertOrSheet(title: "确定拨打客服电话?", message: "400-611-3233",messageColor:mainColor , preferredStyle: UIAlertControllerStyle.alert, actions: actions)
        alertView.isHideWhenWhitespaceClick = false
        UIApplication.shared.keyWindow?.alert(alertView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mylog(self.view.frame )
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
