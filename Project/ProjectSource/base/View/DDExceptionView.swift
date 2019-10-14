//
//  DDExceptionView.swift
//  YiLuMedia
//
//  Created by WY on 2019/2/21.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
struct DDExceptionModel {
    var title = ""
    var image = ""
}
class DDExceptionView: DDMaskBaseView {
    let reloadButton = UIButton()
    let errorMessage = UILabel()
    let errorImage = UIImageView()
    var manualRemoveAfterActionHandle  : (()-> ())?
    var automaticRemoveAfterActionHandle  : (()-> ())?
    var exception : DDExceptionModel = DDExceptionModel(title: "暂无内容", image: ""){
        didSet{
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.isHideWhenWhitespaceClick = false 
        self.addSubview(reloadButton)
        self.backgroundColorAlpha = 1
        self.backgroundColor = UIColor.white
        reloadButton.backgroundColor = mainColor
        reloadButton.setTitle("点击刷新", for: UIControl.State.normal)
        reloadButton.addTarget(self , action: #selector(reloadAction(sender:)), for: UIControl.Event.touchUpInside)
        reloadButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        errorMessage.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(errorMessage)
        errorMessage.textAlignment = .center
        self.addSubview(errorImage)
        errorMessage.numberOfLines = 3
        //        errorImage.image = UIImage(named:"feedback_icon")
        errorMessage.textColor = UIColor.lightGray
        errorImage.contentMode = .scaleAspectFit
        self.addObserver()
    }
    func addObserver()  {
        NotificationCenter.default.addObserver(self , selector: #selector(netWordChanged), name: NSNotification.Name("DDNetworkChanged"), object: nil )
    }
    @objc func netWordChanged() {
        self.reloadAction(sender: self.reloadButton)
    }
    func removeObser() {
        NotificationCenter.default.removeObserver(self )
        /*
         self.performPost( NSNotification.Name("DDNetworkChanged"), ["userInfo" : networkStatus])
         */
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.errorMessage.text = exception.title
        if exception.image.isEmpty {

            self.errorMessage.frame = CGRect(x: 0, y: self.bounds.height/3, width: self.bounds.width, height: 88)
            reloadButton.isHidden = true
//            self.reloadButton.bounds = CGRect(x: 0, y: 0, width: 110, height: 34)
//            self.reloadButton.center = CGPoint(x: self.bounds.width/2, y: errorMessage.frame.maxY + 10 )
//            reloadButton.layer.cornerRadius = 5
//            reloadButton.layer.masksToBounds = true
        }else{

            let image = UIImage(named: exception.image)
            let errorImageMaxW : CGFloat = self.bounds.width/2
            let errorImageMaxH : CGFloat = self.bounds.width/2
            var errorImageW : CGFloat = self.bounds.width/2
            var errorImageH : CGFloat = self.bounds.width/2
            let size = image?.size ?? CGSize(width: errorImageW, height: errorImageH)
            if size.width > errorImageMaxW{
                errorImageW = errorImageMaxW
                errorImageH = errorImageW * size.height / size.width
            }else{
                errorImageW = size.width
                errorImageH = size.height
            }

            errorImage.image = image
            let offSet : CGFloat = 36
            self.reloadButton.bounds = CGRect(x: 0, y: 0, width: 110, height: 34)
            self.reloadButton.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height * 0.75 )
            self.errorMessage.frame = CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width, height: 88)
            self.errorImage.frame = CGRect(x: self.bounds.width / 2 - errorImageW / 2, y: self.bounds.height/2 - errorImageH - offSet, width: errorImageW, height: errorImageH )
            reloadButton.layer.cornerRadius = 5
            reloadButton.layer.masksToBounds = true
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func reloadAction(sender:UIButton) {
        if  self.automaticRemoveAfterActionHandle != nil {
            self.remove()
            self.automaticRemoveAfterActionHandle?()
        }else if self.manualRemoveAfterActionHandle != nil {
            self.manualRemoveAfterActionHandle?()
        }
    }
    
    static func show(_ onSuperview: UIView  ,frame:CGRect = CGRect.zero, animate:((DDExceptionView) -> ())? = nil, showInfoModel: DDExceptionModel? = nil , refreshHandler: (()-> ())? ) -> DDExceptionView{
        //        onSuperview.removeAllExceptionView(maskClass: DDExceptionView.self)
        for subview in onSuperview.subviews{
            if subview.isKind(of: DDExceptionView.self) {
                subview.removeFromSuperview()
            }
        }
        let cover = DDExceptionView()
        if showInfoModel != nil { cover.exception = showInfoModel!}
        cover.manualRemoveAfterActionHandle = refreshHandler
        onSuperview.addSubview(cover)
        if frame == CGRect.zero{
            cover.frame = onSuperview.bounds
        }else{
            cover.frame = frame
        }
        
        if animate != nil {
            animate!(cover)
        }else{
            //            cover.alpha = 0
            let tempColor = cover.backgroundColor ?? UIColor.black
            cover.backgroundColor = tempColor.withAlphaComponent(cover.backgroundColorAlpha)
            //            UIView.animate(withDuration: 0.3) {
            //                cover.alpha = 1
            //            }
        }
        return cover
    }
    //        /// alert exceptionView or remove all exceptionView
    //        ///
    //        /// - Parameters:
    //        ///   - cover: exceptionView .
    //        ///   - switch: if false ,just remove existed exceptionView ,  if true show exceptionView
    //        ///   - frame: exceptionView's frame
    //        ///   - animate: custom animation
    //        /// - Returns: the exceptionView
    //        @discardableResult
    //        func s<T : DDMaskBaseView>(_ cover:T , _ alertSwitch : Bool = true  ,frame:CGRect = CGRect.zero, animate:((T) -> ())? = nil )  -> T{
    //            for subview in self.subviews{
    //                if subview.isKind(of: T.self) {
    //                    subview.removeFromSuperview()
    //                }
    //            }
    //            if !alertSwitch {
    //                return cover
    //            }
    //            self.addSubview(cover)
    //            if frame == CGRect.zero{
    //                cover.frame = self.bounds
    //            }else{
    //                cover.frame = frame
    //            }
    //
    //            if animate != nil {
    //                animate!(cover)
    //            }else{
    //    //            cover.alpha = 0
    //                let tempColor = cover.backgroundColor ?? UIColor.black
    //                cover.backgroundColor = tempColor.withAlphaComponent(cover.backgroundColorAlpha)
    //    //            UIView.animate(withDuration: 0.3) {
    //    //                cover.alpha = 1
    //    //            }
    //            }
    //            return cover
    //        }
    
}
extension UIView{
    func removeAllExceptionView<T : DDMaskBaseView>(maskClass:T.Type) {
        for subview in self.subviews{
            if subview.isKind(of: T.self) {
                subview.removeFromSuperview()
            }
        }
    }
}
