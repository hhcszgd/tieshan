//
//  ModiryProfileVC.swift
//  Project
//
//  Created by JohnConnor on 2019/9/28.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ModiryProfileVC: DDNormalVC {
    
    let pickVC = UIImagePickerController.init()
    private let lineH : CGFloat = 1
    lazy var  icon = DDRowView(frame: CGRect(x: 0, y: DDNavigationBarHeight + 10, width: UIScreen.main.bounds.width, height: 72))
    
    lazy var name = DDRowView(frame: CGRect(x: 0, y: icon.frame.maxY + lineH, width: UIScreen.main.bounds.width, height: 48))
    lazy var  mobile = DDRowView(frame: CGRect(x: 0, y: name.frame.maxY + lineH  * 2, width: UIScreen.main.bounds.width, height: 48))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "个人信息"
        let line = UIView(frame: CGRect(x: 0, y: DDNavigationBarHeight, width: view.frame.width , height: 10))
        self.view.addSubview(line)
        line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        self.view.addSubview(icon)
        self.view.addSubview(name)
        self.view.addSubview(mobile)
        addLine(icon)
        addLine(name)
        addLine(mobile)
        icon.titleLabel.text = "头像"
        icon.subImageView.image = UIImage(named: "profile_edit_icon_touxiang")
        icon.additionalImageView.isHidden = false
        name.titleLabel.text = "姓名"
        name.subTitleLabel.text = DDAccount.share.user_name
        name.additionalImageView.isHidden = false
        mobile.titleLabel.text = "电话号"
        mobile.subTitleLabel.text = DDAccount.share.phone
        icon.subImageView.setImageUrl(url: DDAccount.share.head_url)
        icon.addTarget(self, action: #selector(click(sender:)), for: UIControlEvents.touchUpInside)
        name.addTarget(self, action: #selector(click(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func updateUI()  {
        name.subTitleLabel.text = DDAccount.share.user_name
        mobile.subTitleLabel.text = DDAccount.share.phone
        icon.subImageView.setImageUrl(url: DDAccount.share.head_url)
    }
    
    @objc func click(sender:DDRowView){
        if sender == icon {
            mylog("icon")
            modifyPasswordSuccessAlert()
        }else if sender == name {
            mylog("name")
            self.navigationController?.pushViewController(ModifyName(), animated: true)
        }
        
    }
    func gotImage(image : UIImage)  {
        mylog(image)
    }
    func modifyPasswordSuccessAlert(){
        var actions = [DDAlertAction]()
        
        let takePhoto = DDAlertAction(title: "拍照", style: UIAlertActionStyle.default, handler: { (action ) in
            self.takeOrChooseImage(type: 1)
            
        })
        
        let choose = DDAlertAction(title: "从手机相册选择", style: UIAlertActionStyle.default, handler: { (action ) in
            self.takeOrChooseImage(type: 2)
        })
        let save = DDAlertAction(title: "保存图片", style: UIAlertActionStyle.default, handler: { (action ) in
            if let img = self.icon.subImageView.image{
                self.takeOrChooseImage(type: 3 , image: img)
            }
        })
        let cancel = DDAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action ) in
            print("cancel update")
        })
        actions.append(takePhoto)
        actions.append(choose)
        actions.append(save)
        actions.append(cancel)
        let alertView = DDSheetView(title: nil, message: nil,messageColor:UIColor.darkGray , preferredStyle: UIAlertControllerStyle.actionSheet, actions: actions)
        alertView.isHideWhenWhitespaceClick = false
        UIApplication.shared.keyWindow?.alert(alertView)
    }
    
    func addLine(_ bottomOf : UIView) {
        let line = UIView(frame: CGRect(x: 10, y: bottomOf.frame.maxY, width: bottomOf.frame.width - 20, height: lineH))
        self.view.addSubview(line)
        line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DDAccount.share.refreshInfo {
            self.updateUI()
        }
    }
    
}
extension ModiryProfileVC
{
    
    
    class DDSheetView: DDAlertContainer {
        var subviewsContainer = UIView()
        
        lazy var titleLabelBackview  = UIView()
        lazy var titleLabel  = UILabel()
        lazy var messageLabelBackview  = UIView()
        lazy var messageLabel  = UILabel()
        var messageColor:UIColor = UIColor.gray
        var title: String?
        var message: String?
        
        open var preferredStyle: UIAlertControllerStyle = .alert
        
        public  init(title: String? = nil , message: String? = nil,messageColor:UIColor = UIColor.gray , preferredStyle: UIAlertControllerStyle = .alert, actions:[DDAlertAction]){
            super.init(frame: CGRect.zero)
            self._actions = actions
            self.title = title
            self.message = message
            self.messageColor = messageColor
            self.preferredStyle = preferredStyle
            self.addSubview(subviewsContainer)
            subviewsContainer.backgroundColor = UIColor.gray(0.08)
            if title != nil {
                self.title = title
                self.titleLabel.text = title!
                self.titleLabel.textAlignment = .center
                titleLabel.textColor = UIColor.darkGray
                titleLabelBackview.addSubview(titleLabel)
                self.subviewsContainer.addSubview(titleLabelBackview)
                //            subviewsContainer.addSubview(titleLabel)
                titleLabel.numberOfLines = 0
                titleLabel.backgroundColor = UIColor.white
                titleLabelBackview.backgroundColor = UIColor.white
            }
            
            if message != nil {
                self.message = message
                self.messageLabel.text = message!
                self.messageLabel.textAlignment = .center
                messageLabel.textColor = self.messageColor
                messageLabel.font = UIFont.systemFont(ofSize: 15)
                messageLabelBackview.addSubview(messageLabel)
                self.subviewsContainer.addSubview(messageLabelBackview)
                //            subviewsContainer.addSubview(messageLabel)
                messageLabel.numberOfLines = 0
                messageLabel.backgroundColor = UIColor.white
                messageLabelBackview.backgroundColor = UIColor.white
            }
            for (index,action)  in _actions.enumerated() {
                let button = UIButton()
                button.backgroundColor = UIColor.white
                button.setTitleColor(UIColor.lightGray , for: UIControlState.normal)
                button.setTitle(action._title, for: UIControlState.normal)
                button.tag = index
                subviewsContainer.addSubview(button)
                actionButtons.append(button)
                button.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControlEvents.touchUpInside)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        @objc func buttonAction(sender:UIButton) {
            self._actions[sender.tag].handler?(self._actions[sender.tag])
            if self._actions[sender.tag].isAutomaticDisappear{self.remove()}
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            var maxY : CGFloat = 0
            let subviewsContainerW : CGFloat = self.bounds.width
            
            let rowH : CGFloat = 44
            let borderW : CGFloat = 10
            let margin : CGFloat = 1
            let titleMaxW = subviewsContainerW - borderW  * 2
            
            if self.title != nil {
                var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
                titleLabelH = titleLabelH > 44 ? titleLabelH : 44
                self.titleLabelBackview.frame = CGRect(x: 0, y: 0, width: subviewsContainerW, height: titleLabelH + borderW * 2)//高度是动态的
                self.titleLabel.frame = CGRect(x: borderW, y: borderW, width: titleMaxW, height: titleLabelH)//高度是动态的
                maxY = self.titleLabelBackview.frame.maxY
            }
            if self.message != nil {
                if title != nil {
                    var messageLabelH = self.messageLabel.text?.sizeWith(font: self.messageLabel.font, maxWidth: titleMaxW).height ?? 30
                    messageLabelH = messageLabelH > 30 ? messageLabelH : 30
                    self.messageLabelBackview.frame = CGRect(x: 0, y: maxY , width: subviewsContainerW, height: messageLabelH + borderW * 2)
                    self.messageLabel.frame =  CGRect(x: borderW, y:  0, width: titleMaxW, height: messageLabelH)//高度是动态的
                    maxY =  self.messageLabelBackview.frame.maxY
                }else{
                    var messageLabelH = self.messageLabel.text?.sizeWith(font: self.messageLabel.font, maxWidth: titleMaxW).height ?? 30
                    messageLabelH = 64
                    messageLabelH = messageLabelH > 30 ? messageLabelH : 30
                    self.messageLabelBackview.frame = CGRect(x: 0, y: maxY , width: subviewsContainerW, height: messageLabelH )
                    self.messageLabel.frame =  CGRect(x: borderW, y:  0, width: titleMaxW, height: messageLabelH)//高度是动态的
                    maxY =  self.messageLabelBackview.frame.maxY
                }
            }
            mylog(maxY)
            if _actions.count == 2{// action 横向排列
                if self.preferredStyle == .alert {
                    let buttonY = maxY + margin
                    for (index , button ) in actionButtons.enumerated(){
                        
                        if index == 0 {
                            button.frame = CGRect(x: 0, y: maxY + margin , width: (subviewsContainerW - margin ) / 2, height: rowH)
                        }else{
                            button.frame = CGRect(x:  subviewsContainerW/2 + margin/2, y: maxY + margin , width:(subviewsContainerW - margin ) / 2, height: rowH)
                        }
                    }
                    maxY = buttonY + rowH
                }else{
                    for button in actionButtons{
                        button.frame = CGRect(x: 0, y: maxY + margin , width: subviewsContainerW, height: rowH)
                        maxY = button.frame.maxY
                    }
                }
            }else{// action 纵向排列
                for (index , button)  in actionButtons.enumerated(){
                    if index != actionButtons.count - 1{
                        button.frame = CGRect(x: 0, y: maxY + margin , width: subviewsContainerW, height: rowH)
                    }else{
                        button.frame = CGRect(x: 0, y: maxY + margin * 8 , width: subviewsContainerW, height: rowH + 4)
                    }
                    maxY = button.frame.maxY
                }
            }
            subviewsContainer.bounds = CGRect(x: 0, y: 0, width: subviewsContainerW, height: maxY + 20)
            if self.preferredStyle == .alert {
                self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
            }else{
                self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height - self.subviewsContainer.bounds.height/2 + 20)
            }
            self.subviewsContainer.embellishView(redius: 10)
        }
        
        
    }
    
    
    
}

extension ModiryProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func choosePicture() {
        
    }
    /// 1take , 2choose , 3 save
    func takeOrChooseImage(type:Int  , image:UIImage? = nil) {
        pickVC.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        pickVC.allowsEditing = false
        switch type {
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.pickVC.sourceType = UIImagePickerControllerSourceType.camera
                self.present(self.pickVC, animated: true, completion: nil)
            }
        case 2:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                self.pickVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.pickVC.mediaTypes = UIImagePickerController.availableMediaTypes(for: self.pickVC.sourceType)!
                self.present(self.pickVC, animated: true, completion: nil)
            }
            
        default:
            if let image = image {
                DDPhotoManager.share.saveImage(image: image) { (str) in
                    mylog(str)

                    GDAlertView.alert("保存成功", image: nil, time: 2, complateBlock: nil)
                }
            }
            mylog("save")
        }
       
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var photoImage: UIImage?
        if picker.sourceType == UIImagePickerControllerSourceType.camera {
            if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
                photoImage = photo
            }
        }
        if picker.sourceType == UIImagePickerControllerSourceType.savedPhotosAlbum {
            if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
                photoImage = photo
            }
        }
        if picker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
            if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
                photoImage = photo
            }
        }
        
        if let image = photoImage {
            self.gotImage(image: image)
            
        }
        self.pickVC.dismiss(animated: true, completion: nil)
    }
    
}


