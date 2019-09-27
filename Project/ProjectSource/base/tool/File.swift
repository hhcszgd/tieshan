//
//  File.swift
//  Project
//
//  Created by w   y on 2019/9/3.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//


import UIKit

class DDKeyBoardHandler: NSObject {
    private weak var containerView : UIView?
    private weak var inPutView : UIView?
    private var originalFrame : CGRect = CGRect.zero
    private var isKeyboardShowing = false
    ///can move dynamicly when keyboard keep showing
    var canMoveWhileKeyboardShowing = true
    private var notificationWhileShowing : Notification?
    static let share = { () -> DDKeyBoardHandler in
        let temp = DDKeyBoardHandler()
        temp.prepare()
        return temp
    }()
    static let manager = { () -> DDKeyBoardHandler in
        let temp = DDKeyBoardHandler()
        temp.zkqprepare()
        return temp
    }()
    
    /// setViewToBeDeal , invoke this method after setting inputView's frame and inputViewContainer's frame
    ///
    /// - Parameters:
    ///   - containerView: inputView's container , it will be move while keyboard hide or show
    ///   - inPutView: inPutView
    /// for example :
    /*
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     DDKeyBoardHandler.share.setViewToBeDealt(containerView: getCashContainer, inPutView: textField)
     return true
     }
     */
    func setViewToBeDealt(containerView:UIView , inPutView : UIView) {
        if inPutView.frame == CGRect.zero {
            self.containerView = nil
            self.inPutView = nil
            originalFrame = CGRect.zero
            return
        }
        self.inPutView = inPutView
        guard  let  tempContainerView = self.containerView , tempContainerView == containerView else{
            self.containerView = containerView
            originalFrame = containerView.frame
            return
        }
        if isKeyboardShowing && canMoveWhileKeyboardShowing{
            self.actionWhileShowing(notification: self.notificationWhileShowing)
        }
    }
    func zkqsetViewToBeDealt(containerView:UIView , inPutView : UIScrollView) {
        self.containerView = containerView
        self.zkqInputView = inPutView
        originalFrame = containerView.frame
        
        
    }
    var y: CGFloat = 0
    var zkqInputView: UIScrollView?
    
    
    
    private func getInputViewFrameInWindow()  -> CGRect{
        if let window = UIApplication.shared.delegate?.window  , let input = self.inPutView{
            let rect =  input.convert(input.bounds, to: window)
            return rect
        }
        return CGRect.zero
    }
    
    
    private func getScrollViewFrameInWindow()  -> CGRect{
        if let window = UIApplication.shared.delegate?.window  , let input = self.containerView{
            let rect =  input.convert(input.bounds, to: window)
            return rect
        }
        return CGRect.zero
    }
    var keyboardY: CGFloat = 0
    
    func configContentSet(containerView: UIView, inputView: UIScrollView) {
        self.zkqInputView = inputView
        self.containerView = containerView
        let viewFrame = self.getScrollViewFrameInWindow()
        mylog(viewFrame.maxY)
        mylog(self.zkqInputView?.contentOffset)
        let contentY: CGFloat = (self.zkqInputView?.contentOffset.y)!
        if viewFrame.maxY > self.keyboardY {
            let cha = viewFrame.maxY - self.keyboardY
            self.zkqInputView?.setContentOffset(CGPoint.init(x: 0, y: contentY + cha + 20), animated: true)
        }
        
    }
    private func zkqprepare()  {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil  , queue: OperationQueue.main) { (notification) in
            if self.zkqInputView != nil {
                let keyboardFrame = self.getKeyboardFrameFromNotification(notification: notification)
                self.keyboardY = keyboardFrame.minY
                
                if let container = self.containerView {
                    self.configContentSet(containerView: container, inputView: self.zkqInputView!)
                }
                
            }
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil  , queue: OperationQueue.main) { (notification) in
            if self.zkqInputView != nil {
                
//                self.zkqInputView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            }
        }
    }
    
    
    private func prepare()  {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil  , queue: OperationQueue.main) { (notification) in
            self.isKeyboardShowing = true
            self.notificationWhileShowing = notification
            self.actionWhileShowing(notification : notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil  , queue: OperationQueue.main) { (notification) in
            self.isKeyboardShowing = true
            self.actionWhileHiding(notification:notification)
            self.notificationWhileShowing = nil
        }
    }
    
    private func actionWhileShowing(notification:Notification?){
        if self.containerView != nil {
            if let notification = notification {
                let keyboardFrame = self.getKeyboardFrameFromNotification(notification: notification)
                let viewFrame = self.getInputViewFrameInWindow()
                let keyboardToInputViewMargin : CGFloat = 28
                //                if viewFrame.maxY > keyboardFrame.origin.y {
                UIView.animate(withDuration: 0.25, animations: {
                    let cha = viewFrame.maxY - keyboardFrame.origin.y
                    self.containerView!.frame.origin.y -= cha
                    self.containerView!.frame.origin.y -= keyboardToInputViewMargin
                })
                //                }
            }
        }
    }
    
    private func actionWhileHiding(notification:Notification){
        if self.containerView != nil {
            UIView.animate(withDuration: 0.25, animations: {
                self.containerView!.frame = self.originalFrame
            })
        }
    }
    private func getKeyboardFrameFromNotification(notification : Notification) -> CGRect {
        if let rect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect{
            return rect
        }
        return CGRect.zero
    }
    
}


