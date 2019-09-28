//
//  ModifyName.swift
//  Project
//
//  Created by JohnConnor on 2019/9/28.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ModifyName: DDNormalVC , UITextFieldDelegate{
    let backView = UIView()
    let textField = UITextField()
    let clearButton = UIButton()
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 58, height: 36))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置名字"
        button.setTitle("完成", for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        // Do any additional setup after loading the view.
        button.addTarget(self , action: #selector(changeDone(sender:)), for: UIControlEvents.touchUpInside)
        clearButton.addTarget(self , action: #selector(changeDone(sender:)), for: UIControlEvents.touchUpInside)
       button.backgroundColor = UIColor(red: 68/255, green: 134/255, blue: 219/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        _addsubViews()
        _layoutSubviews()
    }
    @objc func changeDone(sender: UIButton){
        if sender == button{
            mylog("cc")
            DDQueryManager.share.modifyName(type: ApiModel<String>.self, name: textField.text ?? "") { (apiModel) in
                if apiModel.ret_code == "0"{
                    GDAlertView.alert("修改成功", image: nil, time: 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    GDAlertView.alert(apiModel.msg, image: nil, time: 3, complateBlock: nil)
                }
            }
        }else if sender == clearButton{
            self.textField.text = nil
            button.backgroundColor = UIColor(red: 168/255, green: 205/255, blue: 252/255, alpha: 1)
            button.isUserInteractionEnabled = false
        }
    }
    func _addsubViews() {
        self.view.addSubview(backView)
        backView.addSubview(textField)
        textField.text = DDAccount.share.user_name
        backView.addSubview(clearButton)
        backView.backgroundColor = UIColor.white
        clearButton.setImage(UIImage(named: "pro_icon_guanbi"), for: UIControlState.normal)
        textField.delegate = self
    }
    func _layoutSubviews() {
        backView.frame = CGRect(x: 10, y: DDNavigationBarHeight + 20, width: view.bounds.width - 20, height: 48)
        clearButton.frame = CGRect(x: backView.bounds.width - backView.frame.height, y: 0, width: backView.bounds.height, height: backView.bounds.height)
        textField.frame = CGRect(x: 10 ,y: 0 , width: clearButton.frame.minX, height: backView.bounds.height)
        backView.layer.cornerRadius = 6
        backView.layer.masksToBounds = true
    }
    @objc func done(sender:UIButton){
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textt = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        mylog(textt)
        if textt.isEmpty {
            button.backgroundColor = UIColor(red: 168/255, green: 205/255, blue: 252/255, alpha: 1)
            button.isUserInteractionEnabled = false
        }else{
            button.backgroundColor = UIColor(red: 68/255, green: 134/255, blue: 219/255, alpha: 1)
            button.isUserInteractionEnabled = true
        }
        return true
    }
}
