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
        
        mylog(old)
        mylog("验证通过,执行请求")
//        print(oldPassword.text)
//        print(newPassword1.text)
//        print(newPassword2.text)
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
