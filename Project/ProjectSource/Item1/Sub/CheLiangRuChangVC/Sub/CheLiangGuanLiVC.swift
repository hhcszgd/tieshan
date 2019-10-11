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
    
    var carBrandColor = ""
    var carBrandNum = ""
    var carImage = UIImage()
    lazy var colors  = ["蓝色","黄色","白色","黑色"]
    lazy var carNumImageView : UIImageView = {
        let i = UIImageView(image: self.carImage)
        i.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        i.frame = CGRect(x: 10, y: DDNavigationBarHeight + 20, width: view.bounds.width * 0.46, height: view.bounds.width * 0.3)
        return i
    }()
    lazy var carNumTitle:UILabel = {
        let l = UILabel(title: "车牌号: ", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
        l.frame = CGRect(x: carNumImageView.frame.minX, y: carNumImageView.frame.maxY, width: view.bounds.width * 0.44, height: 40)
        return l
    }()
    lazy var carNumValue:UILabel  = {
        let l = UILabel(title: self.carBrandNum , font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray,align: .right)
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
        l.frame = CGRect(x: carNumTitle.frame.minX, y: bottomLine1.frame.maxY, width: view.bounds.width * 0.44, height: 40)
        return l
    }()
    lazy var weightValue:UILabel  =  {
        let l = UILabel(title: "1111吨", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray,align: .right)
        l.frame = CGRect(x:view.bounds.width - view.bounds.width * 0.44 - 10, y: bottomLine1.frame.maxY, width: view.bounds.width * 0.44, height: 40)
        return l
    }()
    lazy var carColorTitle:UILabel  =  {
        let l = UILabel(title: "车牌颜色:", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
        l.sizeToFit()
        l.frame = CGRect(x: weightTitle.frame.minX, y: bottomLine2.frame.maxY, width: l.bounds.width , height: 40)
        return l
    }()
    private lazy var colorBtnW : CGFloat = {
        let left = (view.bounds.width - firstBtnX - 10)/CGFloat(colors.count)
        return left
    }()
    private lazy var firstBtnX : CGFloat = {
        let x = carColorTitle.frame.maxX + 10
        return x
    }()
    lazy var blue : UIButton = {
        let b = UIButton(title: colors[0])
        b.frame = CGRect(x: firstBtnX, y: carColorTitle.frame.minY, width: colorBtnW, height: 40)
        b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        b.tag = 0
        return b
    }()
    
    lazy var yellow: UIButton  =  {
        let b = UIButton(title: colors[1])
        b.tag = 1
        b.frame = CGRect(x: blue.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: 40)
        b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        return b
    }()
    lazy var white: UIButton  =  {
        let b = UIButton(title: colors[2])
        b.frame = CGRect(x: yellow.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: 40)
        b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        b.tag = 2
        return b
    }()
    lazy var black: UIButton =  {
        let b = UIButton(title: colors[3])
        b.tag = 3
        b.frame = CGRect(x: white.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: 40)
        b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        return b
    }()
    
    lazy var bottomLine2 : UIView = {
        let l = UIView()
        l.frame = CGRect(x: weightTitle.frame.minX, y: weightTitle.frame.maxY, width: weightValue.frame.maxX - weightTitle.frame.minX, height: 1)
        l.backgroundColor = mainBgColor
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
        if sender.isSelected {
            selectColorIndex = sender.tag
            carBrandColor = sender.title(for: UIControlState.normal) ?? "蓝色"
        }else{selectColorIndex = -1}
    }
    @objc func cancle(sender:UIButton){
        mylog(sender.title(for: UIControlState.normal))
        self.navigationController?.popToSpecifyVC(DDItem1VC.self)
    }
    @objc func confirm(sender:UIButton){
        mylog(sender.title(for: UIControlState.normal))
        DDQueryManager.share.ruChang(type: ApiModel<String>.self, carNo: self.carBrandNum, cardColor: carBrandColor, selfWeight: "2") { (apiModel) in
            if apiModel.ret_code == "0"{
                GDAlertView.alert("添加成功") {
                    self.navigationController?.popToSpecifyVC(DDItem1VC.self)
                }
            }else{GDAlertView.alert(apiModel.msg) }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车辆管理"
        view.addSubview(carNumImageView)
        view.addSubview(carNumTitle)
        view.addSubview(carNumValue)
        view.addSubview(weightTitle)
        view.addSubview(weightValue)
        view.addSubview(carColorTitle)
        view.addSubview(blue)
        view.addSubview(yellow)
        view.addSubview(white)
        view.addSubview(black)
        view.addSubview(bottomLine2)
        view.addSubview(confirm)
        view.addSubview(cancle)
        view.backgroundColor = .white
        for color in colors.enumerated(){
            if color.element.contains(self.carBrandColor){
                btns[color.offset].isSelected = true
            }else{btns[color.offset].isSelected = false}
        }
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
