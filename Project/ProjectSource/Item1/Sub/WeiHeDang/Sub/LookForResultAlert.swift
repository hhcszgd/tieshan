//
//  LookForResultAlert.swift
//  Project
//
//  Created by JohnConnor on 2019/10/1.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class LookForResultAlert: DDAlertContainer {
    @IBOutlet weak var diya: UIButton!
    @IBOutlet weak var qiangdao: UIButton!
    @IBOutlet weak var daikuan: UIButton!
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.passBtn.layer.borderWidth = 1
        self.passBtn.layer.borderColor = mainColor.cgColor
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        if textView.text == "请输入"{
            textView.textColor = UIColor.lightGray
        }
        textView.returnKeyType = .done
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .green
        self.isHideWhenWhitespaceClick = false
    }
    @IBAction func closeAction(_ sender: UIButton) {
        remove()
    }
    @IBAction func selectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func passOrNot(_ sender: UIButton) {
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    deinit {
        mylog("distroid")
    }
    
}
extension LookForResultAlert :UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView){
        if textView.text == ""{
            textView.text = "请输入"
            textView.textColor = UIColor.lightGray
        }
        mylog("...")
    }
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == "请输入"{
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            self.textView.endEditing(true )
            return false
        }
//        if textView.text.count > 120 && text.count > 0{
//            return false
//        }
        return true
    }
}
