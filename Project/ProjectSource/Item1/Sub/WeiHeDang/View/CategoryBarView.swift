//
//  CategoryBarView.swift
//  Project
//
//  Created by JohnConnor on 2019/9/28.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class CategoryBarView: UIView {
    var defaultIndex = 0
    var selectedColor = mainColor
    convenience init(defaultIndex:Int,selectedColor:UIColor = mainColor,frame:CGRect = .zero){
        self.init(frame: frame)
        self.defaultIndex = defaultIndex
        self.selectedColor = selectedColor
    }
    var models : [(String,String)] = []{
        didSet{
            if models.isEmpty{return}
            if self.subviews.isEmpty {
                for (index , model) in models.enumerated() {
                    let item = CategoryItem()
                    item.model = model
                    self.addSubview(item)
                    item.addTarget(self , action: #selector(click(sender:)), for: UIControlEvents.touchUpInside)
                }
            }
            layoutIfNeeded()
            setNeedsLayout()
        }
        
    }
    @objc func click(sender:CategoryItem) {
        mylog(sender.model.0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.subviews.count <= models.count {
            let toBorder  : CGFloat = 10
            let margin : CGFloat = 3
            let spaceW = toBorder * 2 + margin * CGFloat(models.count - 1)
            let totalItemW = self.bounds.width - spaceW
            let itemW =  totalItemW /  CGFloat(models.count)
            for (index , view) in subviews.enumerated() {
                let item = view as! CategoryItem
                item.model = models[index]
                item.frame = CGRect(x: toBorder + CGFloat(index) * (itemW + margin), y: 0, width: itemW, height: bounds.height)
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
class CategoryItem: UIControl {
    var model : (String,String) = ("title","num"){
        didSet{
            titleLabel.text = model.0
            numLabel.text = model.1
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    let titleLabel = UILabel()
    let numLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.addSubview(titleLabel)
        self.addSubview(numLabel)
        numLabel.textColor = .white
        numLabel.backgroundColor = .red
        numLabel.textAlignment = .center
        self.backgroundColor = .white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: self.bounds.width/2, y: bounds.height/2)
        numLabel.sizeToFit()
        numLabel.size = CGSize(width: numLabel.bounds.width + 6, height: numLabel.height + 2)
        numLabel.center = CGPoint(x: titleLabel.frame.maxX, y: titleLabel.frame.minY)
        numLabel.layer.cornerRadius = numLabel.bounds.height/2
        numLabel.layer.masksToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
