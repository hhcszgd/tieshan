//
//  UITextView+extension.swift
//  Project
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
extension UITextView{
    /*
     public static let UITextViewTextDidBeginEditing: NSNotification.Name
     
     public static let UITextViewTextDidChange: NSNotification.Name
     
     public static let UITextViewTextDidEndEditing: NSNotification.Name
     */
    func addObserver() {
        NotificationCenter.default.addObserver(self , selector: #selector(begainEditing(notification:)), name:NSNotification.Name.UITextViewTextDidBeginEditing, object: nil )
        NotificationCenter.default.addObserver(self , selector: #selector(textDidChange(notification:)), name:NSNotification.Name.UITextViewTextDidChange, object: nil )
        NotificationCenter.default.addObserver(self , selector: #selector(textDidChange(notification:)), name:NSNotification.Name.UITextViewTextDidEndEditing, object: nil )
    }
    @objc  func begainEditing(notification:NSNotification) {
        mylog(notification)
        self.placeHolderLabel?.isHidden = true
    }
    @objc func textDidChange(notification:NSNotification){
//        mylog(notification)
    }
    @objc func textDidEndEditing(notification:NSNotification){
        mylog(notification)
        if let textView = notification.object as? UITextView , textView.text.count == 0 {
            self.placeHolderLabel?.isHidden = false
        }
    }
    var pleaceHolder:String? {
        get{return self.placeHolderLabel?.text}
        set{
            self.addObserver()
            self.placeHolderLabel = UILabel()
            self.placeHolderLabel?.frame = self.bounds
            self.placeHolderLabel?.numberOfLines = 0
            self.placeHolderLabel?.textColor = .lightGray
            self.placeHolderLabel?.textAlignment = .center
            self.placeHolderLabel?.font = self.font
            self.placeHolderLabel?.text = newValue
        }
    }
    
    
    
    private static var placeHolderLabel : Void?
    /** 加载控件 */
    @IBInspectable private var placeHolderLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &UITextView.placeHolderLabel) as? UILabel
        }
        set(newValue) {
            placeHolderLabel?.removeFromSuperview()
            self.addSubview(newValue!)
            
            objc_setAssociatedObject(self, &UITextView.placeHolderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
