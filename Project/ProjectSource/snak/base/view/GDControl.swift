//
//  GDBaseControl.swift
//  zjlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2019年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDControl: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    lazy var imageV: UIImageView = {
        let image = UIImageView.init()
        image.backgroundColor = UIColor.white
        self.addSubview(image)
        return image
    }()
    lazy var titleL: UILabel = {
        let font = GDFont.systemFont(ofSize: 13)
        let color = UIColor.black
        let text = ""
        let label = UILabel.configlabel(font: font, textColor: color, text: text)
        label.sizeToFit()
        self.addSubview(label)
        return label
    }()
    lazy var subTitlelabel: UILabel = {
        let font = GDFont.systemFont(ofSize: 13)
        let color = UIColor.black
        let text = ""
        let label = UILabel.configlabel(font: font, textColor: color, text: text)
        label.sizeToFit()
        self.addSubview(label)
        return label
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    var myModel : BaseControlModel?
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    /*
     func boundingRect(with size: CGSize, options: NSStringDrawingOptions = [], attributes: [String : Any]? = nil, context: NSStringDrawingContext?) -> CGRect
     */
    //    textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect原生
    lazy var titleLabel = UILabel()
    lazy var additionalLabel = UILabel()
    
    
    lazy var imageView = UIImageView()
    lazy var subImageView = UIImageView()
    lazy var additionalImageView = UIImageView()
    lazy var backImageView = UIImageView()
    
    lazy var customView = UIView()
    
    lazy var textField = UITextField()
    
    
    lazy var button = UIButton()
    lazy var subButton = UIButton()


}
