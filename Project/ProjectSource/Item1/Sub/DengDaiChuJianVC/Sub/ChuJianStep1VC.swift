//
//  ChuJianStep1VC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/5.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ChuJianStep1VC: ChuangJianVC {
    let addBtn = UIButton()
    let doneBtn = UIButton()
    lazy var models  : [CheYuanOrCheLiangModel] =  [
        CheYuanOrCheLiangModel(title: "车辆基本信息:", isValid: true, stringOfClassName: NSStringFromClass(ChuJianBaseInfoCell.self),placeholder: "请输入车牌数量"),
        CheYuanOrCheLiangModel( isValid: true, stringOfClassName: NSStringFromClass(DDSectionSeparator.self)),
        CheYuanOrCheLiangModel(title: "车牌数量:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入车牌数量"),
        // TODO: 新旧程度
        CheYuanOrCheLiangModel(title: "新旧程度:", isValid: true, stringOfClassName: NSStringFromClass(OldLevelRow.self),placeholder: "请输入车牌数量"),
        CheYuanOrCheLiangModel(title: "空调泵:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入空调泵数量"),
        CheYuanOrCheLiangModel(title: "电池:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入电池数量"),
        CheYuanOrCheLiangModel(title: "马达:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入马达数量"),
        CheYuanOrCheLiangModel(title: "车门:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入车门数量"),
        CheYuanOrCheLiangModel(title: "铝圈数量:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入铝圈数量数量"),
        CheYuanOrCheLiangModel(title: "电机:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入电机数量"),
        // TODO: 是否是铝圈
        
        
        CheYuanOrCheLiangModel(title: "铝圈:", isValid: true, stringOfClassName: NSStringFromClass(YesOrNoRow.self),placeholder: "请输入水箱数量"),
        CheYuanOrCheLiangModel(title: "轮胎:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入水箱数量"),
        CheYuanOrCheLiangModel(title: "座椅:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入座椅数量"),
        CheYuanOrCheLiangModel(title: "空调:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入空调数量"),
        CheYuanOrCheLiangModel(title: "三元催化器:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入三元催化器数量"),
        
        CheYuanOrCheLiangModel(title: "备注:", isValid: true, stringOfClassName: NSStringFromClass(DDTips.self)),
        
        
        
    ]
    lazy var shouXuModel : CheYuanOrCheLiangModel = {
        let m = CheYuanOrCheLiangModel(title: "手续:", isValid: true, stringOfClassName: NSStringFromClass(DDShouxu.self))
        m.shouXuTypes = [
            ShouXuTypeModel(title: "行驶本", false, 0),
            ShouXuTypeModel(title: "登记证", false, 1),
            ShouXuTypeModel(title: "身份证复印件", false, 2),
            ShouXuTypeModel(title: "营业执照复印件", false, 3),
            ShouXuTypeModel(title: "车辆报废表", false, 4),
            ShouXuTypeModel(title: "车辆事故证明", false, 5)
        ]
        return m
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.title = "车辆初检"
        _addSubviews()
        self.tableView?.reloadData()
        tableView?.showsVerticalScrollIndicator = false
//        if tableView!.contentSize.height > tableView!.bounds.height{self.tableView?.isScrollEnabled = true}else{self.tableView?.isScrollEnabled = false}
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//actions
extension ChuJianStep1VC{
    @objc func addBtnClick(sender: UIButton){
        mylog("addBtnClick")
        
    }
    @objc func doneBtnClick(sender: UIButton){
        mylog("doneBtnClick")
        
    }
    func choose() {
        var actions = [DDAlertAction]()
        
        let sure = DDAlertAction(title: "拨打电话",textColor:mainColor, style: UIAlertActionStyle.default, handler: { (action ) in
            print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
            UIApplication.shared.openURL(URL(string: "telprompt:4006113233")!)
        })
        
        let cancel = DDAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action ) in
            print("cancel update")
        })
        actions.append(cancel)
        actions.append(sure)
        let alertView = DDAlertOrSheet(title: "确定拨打客服电话?", message: "400-611-3233",messageColor:mainColor , preferredStyle: UIAlertControllerStyle.alert, actions: actions)
        alertView.isHideWhenWhitespaceClick = false
        UIApplication.shared.keyWindow?.alert(alertView)
    }
    
    
}

extension ChuJianStep1VC : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch models[indexPath.row].stringOfClassName {
        case NSStringFromClass(ChuJianBaseInfoCell.self):
            return 100
        case NSStringFromClass(DDSectionHeaderRow.self):
            return 48
        case NSStringFromClass(DDSingleInputRow.self):
            return 48
        case NSStringFromClass(OldLevelRow.self):
            return 48
        case NSStringFromClass(YesOrNoRow.self):
            return 48
        case NSStringFromClass(DDSectionSeparator.self):
            return 11
        case NSStringFromClass(DDTips.self):
            return 100
        case NSStringFromClass(DDShouxu.self):
            return 88
        default:
            return 44
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.models[indexPath.row]
        switch model.stringOfClassName {
        case NSStringFromClass(DDSectionHeaderRow.self):
            let cell = DDSectionHeaderRow.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDSectionHeaderRow")
            cell.model = model
            return cell
        case NSStringFromClass(DDSingleInputRow.self):
            let cell = DDSingleInputRow.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDSingleInputRow")
            cell.textfield.textAlignment = .right
            cell.model = model
            return cell
            
        case NSStringFromClass(DDSectionSeparator.self):
            let cell = DDSectionSeparator.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDSectionSeparator")
            cell.model = model
            return cell
            
        case NSStringFromClass(DDSingleChoose.self):
            let cell = DDSingleChoose.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDSingleChoose")
            cell.model = model
            return cell
            
        case NSStringFromClass(DDTips.self):
            let cell = DDTips.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDTips")
            cell.model = model
            return cell
            
        case NSStringFromClass(DDShouxu.self):
            let cell = DDShouxu.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDShouxu")
            cell.model = model
            return cell
            
        case NSStringFromClass(ChuJianBaseInfoCell.self):
            let cell = ChuJianBaseInfoCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "ChuJianBaseInfoCell")
            cell.model = model
            return cell
        case NSStringFromClass(OldLevelRow.self):
            let cell = OldLevelRow.init(style: UITableViewCellStyle.default, reuseIdentifier: "OldLevelRow")
            cell.model = model
            return cell
        case NSStringFromClass(YesOrNoRow.self):
            let cell = YesOrNoRow.init(style: UITableViewCellStyle.default, reuseIdentifier: "YesOrNoRow")
            cell.model = model
            return cell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "xxx")
        }
        
    }
    
    
    
    
}

extension ChuJianStep1VC{
    func _addSubviews() {
        self.view.addSubview(addBtn)
        self.view.addSubview(doneBtn)
        let tableViewFrame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width , height: self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight - 52)
        
        self.tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.plain)
        self.view.addSubview(self.tableView!)
        addBtn.frame = CGRect(x: 20, y: view.bounds.height - DDSliderHeight - 48, width: (view.bounds.width - 40 - 20)/2, height: 40)
        addBtn.setTitleColor(mainColor, for: .normal)
        addBtn.setTitle("暂存", for: UIControlState.normal)
        addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        addBtn.layer.cornerRadius = 8
        addBtn.layer.masksToBounds = true
        addBtn.layer.borderColor = mainColor.cgColor
        addBtn.layer.borderWidth = 1
        doneBtn.frame = CGRect(x:addBtn.frame.maxX + 20, y: addBtn.frame.minY, width: addBtn.frame.width, height: 40)
        doneBtn.backgroundColor = mainColor
        doneBtn.setTitle("初检完成", for: UIControlState.normal)
        doneBtn.addTarget(self , action: #selector(doneBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        doneBtn.layer.cornerRadius = 8
        doneBtn.layer.masksToBounds = true
        
        tableView?.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        //        self.tableView?.isScrollEnabled = false
        
        tableView?.backgroundColor = .clear
        tableView?.separatorStyle = .none
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}
