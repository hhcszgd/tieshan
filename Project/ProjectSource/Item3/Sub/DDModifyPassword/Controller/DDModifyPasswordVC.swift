//
//  DDModifyPasswordVC.swift
//  Project
//
//  Created by WY on 2019/9/22.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDModifyPasswordVC: DDNormalVC {

    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var bg3: UIView!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword1: UITextField!
    @IBOutlet weak var newPassword2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setBorder(view: bg1)
        setBorder(view: bg2)
        setBorder(view: bg3)
    }
    @IBAction func btnClick(_ sender: UIButton) {
        mylog("perform modify password")
        
        guard let old = oldPassword.text?.tieShanPasswordLawful()else{
            return
        }
        guard let new1 = newPassword1.text?.tieShanPasswordLawful()else{
            return
        }
        guard let new2 = newPassword2.text?.tieShanPasswordLawful()else{
            return
        }
        
        if !(old && (new1 && new2)) {
            GDAlertView.alert("请输入正确格式的密码", image: nil, time: 2, complateBlock: nil)
            return
        }
        
        if (newPassword1.text ?? "") != (newPassword2.text ?? "") {
            GDAlertView.alert("请输入相同的新密码", image: nil, time: 2, complateBlock: nil)
            return
        }
        DDQueryManager.share.modifyPassword(type: ApiModel<String>.self, old: oldPassword.text!, new: newPassword1.text!) { (apiModel) in
            if apiModel.ret_code == "0"{
                self.modifyPasswordSuccessAlert()
            }else{
                GDAlertView.alert("修改失败,请重试", image: nil, time: 3, complateBlock: nil)
            }
        }
        
        mylog(old)
        mylog("验证通过,执行请求")
//        print(oldPassword.text)
//        print(newPassword1.text)
//        print(newPassword2.text)
    }
    
    func modifyPasswordSuccessAlert(){
            var actions = [DDAlertAction]()
            
        let sure = DDAlertAction(title: "我知道了",textColor:mainColor, style: UIAlertActionStyle.default, handler: { (action ) in
//                print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
//                UIApplication.shared.openURL(URL(string: "telprompt:4006113233")!)
            })
            
//            let cancel = DDAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action ) in
//                print("cancel update")
//            })
//            actions.append(cancel)
            actions.append(sure)
        let alertView = DDAlertOrSheet(title: nil, message: "密码修改成功",messageColor:UIColor.darkGray , preferredStyle: UIAlertControllerStyle.alert, actions: actions)
            alertView.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert(alertView)
    }
    func setBorder(view:UIView)  {
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
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
