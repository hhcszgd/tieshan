//
//  DDLoginVC.swift
//  Project
//
//  Created by WY on 2019/9/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDLoginVC: DDNormalVC {
    let bigTitle = UIImageView(image: UIImage(named: "login_logo"))
    let userName = DDInputView( iconImage: UIImage(named:"login_icon-yonghuming"), placeholder: "请输入用户名",backgroundImg:UIImage(named:"login_input"))
    let password = DDInputView( iconImage: UIImage(named:"login_icon-yonghuming"), placeholder: "请输入密码",backgroundImg:UIImage(named:"login_input"))
    let forgetBtn = UIButton(frame: CGRect.zero)
    let loginBtn = UIButton(frame: CGRect.zero)
    let bottomImage = UIImageView(image: UIImage(named: "login_bg"))
    override func viewDidLoad() {
        super.viewDidLoad()
        _addSubviews()
        _layoutsubviews()
//        self.navigationController?.setNavigationBarHidden(true , animated: false )
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true , animated: true )
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
//class LoginDada : Codable {
//    var token : String = ""
//    var login_name:String?
//    var head_url : String?
//    var phone: String?
//    var user_name: String?
//    var department_name:String?
//    var depart_code:String?
//    var id : Int?
//}
/// deal with actions
extension DDLoginVC : UITextFieldDelegate{
    @objc func forgetPassword(sender:UIButton){
        self.navigationController?.pushViewController(DDForgetPasswordVC(), animated: true )
    }
    
    @objc func loginBtn(sender:UIButton){

        DDRueryManager.share.login(type: ApiModel<DDAccount>.self, userName: "admin", passWord: "123456", success: { (m ) in
            
            if m.data != nil {
                DDAccount.share.setPropertisOfShareBy(otherAccount: m.data!)
                
                NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil)
                
            }
            mylog(m.data?.token)
            
        }, failure: nil , complate: nil )
        if self.userName.text == nil || self.userName.text!.count == 0 {
            GDAlertView.alert("请输入用户名", image: nil, time: 2, complateBlock: nil)
            return
        }
        if self.password.text == nil || self.password.text!.count == 0 {
            GDAlertView.alert("请输入密码", image: nil, time: 2, complateBlock: nil)
            return
        }
//        let account = DDAccount()
//        account.memberId = 333
//        account.mobile = "17600905015"
//
//        account.id = "sssssss"
//        account.nickName = "nickName"
//        account.head_images = "http://www.baidu.com/logo"
//        account.password = "xxxxx"
//
//        account.token = "xxxxxxxxxxxxxxxxxxx"
//
//        account.name = "xxxx"
//        account.memberTyep = "ss"
    }
    
}


/// layout subviews
fileprivate let maincolor = UIColor.colorWithRGB(red: 69, green: 134, blue: 217)
extension DDLoginVC{
    func _addSubviews() {
        self.view.addSubview(bigTitle)
        self.view.addSubview(userName)
        self.view.addSubview(password)
        self.view.addSubview(forgetBtn)
        self.view.addSubview(bottomImage)
        forgetBtn.setTitle("忘记密码 ?", for: UIControlState.normal)
        forgetBtn.setTitleColor(maincolor, for: UIControlState.normal)
        forgetBtn.sizeToFit()
        self.view.addSubview(loginBtn)
//        loginBtn.backgroundColor = maincolor
        loginBtn.setTitle("登录", for: UIControlState.normal)
        forgetBtn.addTarget(self , action: #selector(forgetPassword(sender:)), for: UIControlEvents.touchUpInside)
        loginBtn.addTarget(self , action: #selector(loginBtn(sender:)), for: UIControlEvents.touchUpInside)
    }
    func _layoutsubviews()  {
        let componentToBorder : CGFloat = 20
        let componentW = self.view.bounds.width - componentToBorder * 2
        let componentH : CGFloat = 58
        bigTitle.center = CGPoint(x: self.view.bounds.width/2, y: 156 * SCALE)
        userName.frame = CGRect(x: componentToBorder, y: bigTitle.frame.maxY + 44, width: componentW, height: componentH)
        password.frame = CGRect(x: componentToBorder, y: userName.frame.maxY + 33, width: componentW, height: componentH)
        forgetBtn.center = CGPoint(x: password.frame.maxX - forgetBtn.bounds.width/2, y: password.frame.maxY + 22)
        loginBtn.frame = CGRect(x: componentToBorder, y: password.frame.maxY + 66, width: componentW, height: componentH)
        loginBtn.setBackgroundImage(UIImage(named:"login_btn"), for: UIControlState.normal)
        bottomImage.frame.scaleWidthTo(self.view.bounds.width)
        bottomImage.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height - bottomImage.bounds.height/2)
    }
}
