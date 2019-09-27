//
//  DDInputView.swift
//  Project
//
//  Created by WY on 2019/9/18.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDInputView: UIView {
    var text  : String?{
        get {return self.textfield.text}
        set{self.textfield.text = text}
    }
    private let textfield = UITextField()
    private let icon = UIImageView()
    private let backgrountImageView = UIImageView()
    convenience init(frame: CGRect = .zero,iconImage:UIImage?,placeholder:String? = nil,backgroundImg : UIImage? = nil  ) {
        self.init(frame: frame)
        self.addSubview(backgrountImageView)
        self.addSubview(textfield)
        self.addSubview(icon)
        textfield.delegate = self
        textfield.returnKeyType = .done
        icon.contentMode = .scaleAspectFit
        self.icon.image = iconImage
        backgrountImageView.image = backgroundImg
        self.textfield.placeholder = placeholder
        if frame == CGRect.zero{
            self.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backgrountImageView.frame = self.bounds
        let iconH = self.bounds.height * 0.4
        self.icon.frame = CGRect(x: self.bounds.height * 0.35, y: (self.bounds.height - iconH) / 2, width:  iconH, height:iconH )
        let textfieldH = (self.bounds.height - 20)/2
        let textfieldX = icon.frame.maxX + icon.frame.minX
        let textfieldW = self.bounds.width - textfieldX
        self.textfield.frame = CGRect(x: icon.frame.maxX + icon.frame.minX, y: (self.bounds.height - textfieldH )/2, width: textfieldW , height: textfieldH)
//        self.layer.cornerRadius = self.bounds.size.height * 0.5
//        self.layer.masksToBounds = true
//        self.layer.borderColor = UIColor.colorWithHexStringSwift("4490DD").cgColor
//        self.layer.borderWidth = 1
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension DDInputView : UITextFieldDelegate{
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textfield.endEditing(true )
        return true
    }
}
