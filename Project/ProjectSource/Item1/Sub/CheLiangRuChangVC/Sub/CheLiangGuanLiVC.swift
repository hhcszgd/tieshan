//
//  CheLiangGuanLiVC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/4.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit
extension UIButton{
    convenience init(title:String){
        self.init()
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setImage(UIImage(named: "icon_btn_nor"), for: UIControlState.normal)
        self.setImage(UIImage(named: "icon_btn_sel"), for: UIControlState.selected)
        self.setTitle(" " + title, for: UIControlState.normal)
        self.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
}
class CheLiangGuanLiVC: DDNormalVC {
    lazy var carNumImageView : UIImageView = {
        let i = UIImageView()
        view.addSubview(i)
        i.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        i.frame = CGRect(x: 10, y: DDNavigationBarHeight + 20, width: view.bounds.width * 0.46, height: view.bounds.width * 0.3)
        return i
    }()
    lazy var carNumTitle:UILabel = {
        let l = UILabel(title: "车牌号:", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
        view.addSubview(l)
        l.frame = CGRect(x: carNumImageView.frame.minX, y: carNumImageView.frame.maxY, width: view.bounds.width * 0.44, height: 40)
        return l
    }()
    lazy var carNumValue:UILabel  = {
        let l = UILabel(title: "xxxx", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray,align: .right)
        view.addSubview(l)
        l.frame = CGRect(x: view.bounds.width - view.bounds.width * 0.44 - 10, y: carNumTitle.frame.minY, width: view.bounds.width * 0.44, height: 40)
        return l
    }()
    
    lazy var bottomLine1 : UIView = {
        let l = UIView()
        l.frame = CGRect(x: carNumTitle.frame.minX, y: carNumTitle.frame.maxY, width: carNumValue.frame.maxX - carNumTitle.frame.minX, height: 1)
        view.addSubview(l)
        l.backgroundColor = mainBgColor
        return l
    }()
    
    
    lazy var weightTitle:UILabel  =  {
        let l = UILabel(title: "车重:", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
        view.addSubview(l)
        l.frame = CGRect(x: carNumTitle.frame.minX, y: bottomLine1.frame.maxY, width: view.bounds.width * 0.44, height: 40)
        return l
    }()
    lazy var weightValue:UILabel  =  {
        let l = UILabel(title: "xxxx/公斤", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray,align: .right)
        view.addSubview(l)
        l.frame = CGRect(x:view.bounds.width - view.bounds.width * 0.44 - 10, y: bottomLine1.frame.maxY, width: view.bounds.width * 0.44, height: 40)
        return l
    }()
    lazy var carColorTitle:UILabel  =  {
        let l = UILabel(title: "车牌颜色:", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
        view.addSubview(l)
        l.sizeToFit()
        l.frame = CGRect(x: weightTitle.frame.minX, y: bottomLine2.frame.maxY, width: l.bounds.width , height: 40)
        return l
    }()
    private lazy var colorBtnW : CGFloat = {
        let left = (view.bounds.width - firstBtnX - 10)/4
        return left
    }()
    private lazy var firstBtnX : CGFloat = {
        let x = carColorTitle.frame.maxX + 10
        return x
    }()
    lazy var blue : UIButton = {
        let b = UIButton(title: "蓝色")
        b.frame = CGRect(x: firstBtnX, y: carColorTitle.frame.minY, width: colorBtnW, height: 40)
        b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(b)
        b.tag = 0
        return b
    }()
    
    lazy var yellow: UIButton  =  {
        let b = UIButton(title: "黄色")
        view.addSubview(b)
        b.tag = 1
        b.frame = CGRect(x: blue.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: 40)
        b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        return b
    }()
    lazy var white: UIButton  =  {
        let b = UIButton(title: "白色")
        b.frame = CGRect(x: yellow.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: 40)
        view.addSubview(b)
        b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        b.tag = 2
        return b
    }()
    lazy var black: UIButton =  {
        let b = UIButton(title: "黑色")
        view.addSubview(b)
        b.tag = 3
        b.frame = CGRect(x: white.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: 40)
        b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        return b
    }()
    
    lazy var bottomLine2 : UIView = {
        let l = UIView()
        l.frame = CGRect(x: weightTitle.frame.minX, y: weightTitle.frame.maxY, width: weightValue.frame.maxX - weightTitle.frame.minX, height: 1)
        l.backgroundColor = mainBgColor
        view.addSubview(l)
        return l
    }()
    
    lazy var cancle: UIButton =  {
        let b = UIButton()
        b.setTitle("取消", for: UIControlState.normal)
        b.setTitleColor(mainColor, for: UIControlState.normal)
        b.layer.borderWidth = 1
        b.layer.borderColor = mainColor.cgColor
        b.layer.cornerRadius = 6
        b.layer.masksToBounds  = true
        view.addSubview(b)
        let w = (view.bounds.width - 20 - 30)/2
        b.frame = CGRect(x: carColorTitle.frame.minX, y: view.bounds.height - DDSliderHeight - 58, width: w, height: 40)
        b.addTarget(self , action: #selector(cancle(sender:)), for: UIControlEvents.touchUpInside)
        return b
    }()
    var selectColorIndex = -1
    lazy var confirm: UIButton =  {
        let b = UIButton()
        b.setTitle("确定", for: UIControlState.normal)
        b.backgroundColor = mainColor
        b.layer.cornerRadius = 6
        b.layer.masksToBounds  = true
        view.addSubview(b)
        let w = (view.bounds.width - 20 - 30)/2
        b.frame = CGRect(x: cancle.frame.maxX + 30, y: cancle.frame.minY, width: w, height: 40)
        b.addTarget(self , action: #selector(confirm(sender:)), for: UIControlEvents.touchUpInside)
        return b
    }()
    var btns : [UIButton]{return [blue,yellow , white , black]}
    @objc func btnClick(sender:UIButton){
        mylog(sender.title(for: UIControlState.normal))
        sender.isSelected = !sender.isSelected
        btns.forEach { (b) in
            if b != sender{b.isSelected = false }
        }
        if sender.isSelected {selectColorIndex = sender.tag }else{selectColorIndex = -1}
    }
    @objc func cancle(sender:UIButton){
        mylog(sender.title(for: UIControlState.normal))
    }
    @objc func confirm(sender:UIButton){
        mylog(sender.title(for: UIControlState.normal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车辆管理"
        print(carColorTitle.tintColor)
        print(black.title(for: UIControlState.normal))
        print(confirm.title(for: UIControlState.normal))
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
