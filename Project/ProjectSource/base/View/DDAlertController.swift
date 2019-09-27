//
//  DDAlertController.swift
//  Project
//
//  Created by WY on 2019/9/31.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//this alert function is according to UIAlertController ,
// alert view class must inherit DDAlertContainer

import UIKit
extension  UIView {
    @discardableResult
    func alert<T : DDAlertContainer>(_ cover:T)  -> T{
        cover.frame = self.bounds
        cover.alpha = 0
        cover.backgroundColor = UIColor.lightGray.withAlphaComponent(cover.backgroundColorAlpha)
        self.addSubview(cover)
        UIView.animate(withDuration: 0.3) {
            cover.alpha = 1
        }
        return cover
    }
}
class DDAlertContainer: UIView {
    var isHideWhenWhitespaceClick = true
    var deinitHandle : (()-> ())?
    var backgroundColorAlpha : CGFloat = 0.3
    lazy var _actions = [DDAlertAction]()
    lazy var actionButtons = [UIButton]()
 
    override func didMoveToWindow(){
        super.didMoveToWindow()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    @objc func remove() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (bool ) in
            self.subviews.forEach({ (subview) in
                subview.removeFromSuperview()
            })
            self.removeFromSuperview()
            self.deinitHandle?()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstView = self.subviews.first{
            if let point = touches.first?.location(in: self){
                for subview in self.subviews{
                    if subview.frame.contains(point){
                        return
                    }
                }
//                if firstView.frame.contains(point){
//                    return
//                }
            }
        }
        mylog("corver view part touch")
        if isHideWhenWhitespaceClick {self.remove()}
    }
    deinit {
        self.deinitHandle?()
    }
}




class DDAlertAction : NSObject {
    var _title  : String?{
        didSet{
            
        }
    }
    open var isAutomaticDisappear = true
    
//    open var title: String? { return _title }
    
    open var _style: UIAlertActionStyle = .default {
        didSet{
            
        }
    }
    
    open var isEnabled: Bool = true {
        didSet{
            
        }
    }
    var textColor = UIColor.gray
    @objc var handler : ((DDAlertAction) -> Swift.Void)?
//    override init() {}

    public convenience init(title: String? , textColor : UIColor = UIColor.gray, style: UIAlertActionStyle = .default, handler: ((DDAlertAction) -> Swift.Void)? = nil){
        self.init()
        self.textColor = textColor
        self.handler = handler
        self._title = title
    }
}
