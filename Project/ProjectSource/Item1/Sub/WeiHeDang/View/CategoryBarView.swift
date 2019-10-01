//
//  CategoryBarView.swift
//  Project
//
//  Created by JohnConnor on 2019/9/28.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class CategoryBarView: UIView {
    var selectedIndex = 0{
        didSet{
            if models.isEmpty || selectedIndex >= models.count || selectedIndex < 0 {return}
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    var selectHandler : ((Int)->())?
    
    var selectedColor = mainColor
    let lineView = UIView()
    convenience init(defaultIndex:Int,selectedColor:UIColor = mainColor,frame:CGRect = .zero){
        self.init(frame: frame)
        self.selectedIndex = defaultIndex
        self.selectedColor = selectedColor
        lineView.backgroundColor = selectedColor
        self.backgroundColor = .white
    }
    var models : [(String,String)] = []{
        didSet{
            if models.isEmpty{return}
            if self.subviews.isEmpty {
                for (index , model) in models.enumerated() {
                    let item = CategoryItem()
                    item.model = model
                    self.addSubview(item)
                    item.tag = index
                    item.addTarget(self , action: #selector(click(sender:)), for: UIControlEvents.touchUpInside)
                    self.lineView.frame = CGRect(x: CGFloat(selectedIndex) * self.bounds.width/CGFloat(self.models.count), y: self.bounds.height - 2, width: self.bounds.width/CGFloat(self.models.count), height: 2)
                }
                self.addSubview(lineView)
            }
            layoutIfNeeded()
            setNeedsLayout()
        }
        
    }
    @objc func click(sender:CategoryItem) {
        self.selectedIndex = sender.tag
        selectHandler?(sender.tag)
        UIView.animate(withDuration: 0.25) {
            self.lineView.frame = CGRect(x: CGFloat(sender.tag) * self.bounds.width/CGFloat(self.models.count), y: self.bounds.height - 2, width: self.bounds.width/CGFloat(self.models.count), height: 2)
        }
        mylog(sender.model.0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
            let toBorder  : CGFloat = 0
            let margin : CGFloat = 0
            let spaceW = toBorder * 2 + margin * CGFloat(models.count - 1)
            let totalItemW = self.bounds.width - spaceW
            let itemW =  totalItemW /  CGFloat(models.count)
            for (index , view) in subviews.enumerated() {
                if index >= models.count{
                    if view.frame == CGRect.zero {
                        view.frame = CGRect(x: 0, y: bounds.height - 2, width: itemW, height: 2)
                    }
                    return
                }
                let item = view as! CategoryItem
                if index == selectedIndex{
                    item.titleLabel.textColor = selectedColor
                }else{
                    item.titleLabel.textColor = UIColor.gray
                }
                item.model = models[index]
                if view.frame == CGRect.zero {
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
        numLabel.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        numLabel.textAlignment = .center
        self.backgroundColor = .white
        numLabel.font = UIFont.systemFont(ofSize: 13)
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
