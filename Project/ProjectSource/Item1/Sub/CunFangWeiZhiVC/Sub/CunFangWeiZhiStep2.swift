//
//  CunFangWeiZhiStep2.swift
//  Project
//
//  Created by JohnConnor on 2019/10/5.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class CunFangWeiZhiStep2: ChuangJianVC {
    let addBtn = UIButton()
    let doneBtn = UIButton()
    let scanBtn = UIButton()
    lazy var models  : [CheYuanOrCheLiangModel] =  [
        CheYuanOrCheLiangModel(title: "车辆基本信息:", isValid: true, stringOfClassName: NSStringFromClass(ChuJianBaseInfoCell.self)),
        CheYuanOrCheLiangModel(title: "车辆存放位置", isValid: true, stringOfClassName: NSStringFromClass(DDSectionHeaderRow.self)),
        CheYuanOrCheLiangModel(title: "大区", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择"),
        
        CheYuanOrCheLiangModel(title: "排数", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择"),
        CheYuanOrCheLiangModel(title: "个数", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择"),
        CheYuanOrCheLiangModel(title: "层数", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择"),
        
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.title = "存放位置"
        _addSubviews()
        self.tableView?.reloadData()
        tableView?.showsVerticalScrollIndicator = false
        if tableView!.contentSize.height > tableView!.bounds.height{self.tableView?.isScrollEnabled = true}else{self.tableView?.isScrollEnabled = false}
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//actions
extension CunFangWeiZhiStep2{
    @objc func addBtnClick(sender: UIButton){
        mylog("addBtnClick")
        
    }
    @objc func doneBtnClick(sender: UIButton){
        mylog("doneBtnClick")
        let scanner = CarScannerVC()
        scanner.complateHandle = {[weak self] result in
            mylog(result)
        }
        self.present(scanner, animated: true) {}
    }
    @objc func scanBtnClick(sender: UIButton){
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

extension CunFangWeiZhiStep2 : UITableViewDelegate , UITableViewDataSource{
    
    
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
            cell.textfield.textAlignment = .right
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

extension CunFangWeiZhiStep2{
    func _addSubviews() {
        let tableViewFrame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width , height: self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        
        self.tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.plain)
        self.view.addSubview(self.tableView!)
        self.view.addSubview(addBtn)
        self.view.addSubview(doneBtn)
        self.view.addSubview(scanBtn)
        addBtn.frame = CGRect(x: 20, y: self.tableView!.frame.maxY, width: (view.bounds.width - 40 - 20)/2, height: 40)
        addBtn.setTitleColor(mainColor, for: .normal)
        addBtn.setTitle("暂存", for: UIControlState.normal)
        addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        addBtn.layer.cornerRadius = 8
        addBtn.layer.masksToBounds = true
        addBtn.layer.borderColor = mainColor.cgColor
        addBtn.layer.borderWidth = 1
        doneBtn.frame = CGRect(x:addBtn.frame.maxX + 20, y: self.tableView!.frame.maxY, width: addBtn.frame.width, height: 40)
        doneBtn.backgroundColor = mainColor
        doneBtn.setTitle("初检完成", for: UIControlState.normal)
        doneBtn.addTarget(self , action: #selector(doneBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        doneBtn.layer.cornerRadius = 8
        doneBtn.layer.masksToBounds = true
        
        scanBtn.frame = CGRect(x:addBtn.frame.minX, y: addBtn.frame.minY - 56, width: doneBtn.frame.maxX - addBtn.frame.minX, height: 40)
        scanBtn.backgroundColor = mainColor
        scanBtn.setTitle("扫描位置二维码", for: UIControlState.normal)
        scanBtn.addTarget(self , action: #selector(scanBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        scanBtn.layer.cornerRadius = 8
        scanBtn.layer.masksToBounds = true
        
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
