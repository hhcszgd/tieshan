//
//  ZengJiaCheLiangeVC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/4.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ZengJiaCheLiangeVC: ChuangJianVC {
    let addBtn = UIButton()
    lazy var models  : [CheYuanOrCheLiangModel] =  [
        CheYuanOrCheLiangModel(identify:"contacts", title: "联系人姓名:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系人姓名"),
        CheYuanOrCheLiangModel(identify:"contactsPhone", title: "联系人电话:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系人电话"),
        CheYuanOrCheLiangModel(identify:"contactsAddress", title: "联系人地址:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系人地址"),
        CheYuanOrCheLiangModel( isValid: false, stringOfClassName: NSStringFromClass(DDSectionSeparator.self)),
        CheYuanOrCheLiangModel(identify:"carNo", title: "车牌号:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入车牌号"),
        
        CheYuanOrCheLiangModel(identify:"carName", title: "车辆型号:",value: "科鲁兹滋滋滋滋", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择车辆型号"),
        CheYuanOrCheLiangModel(identify:"processingType", title: "处理方式:",value: "拖车", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择处理方式"),
        CheYuanOrCheLiangModel(identify:"processingDate", title: "处理日期:",value: "2019-09-18 15:39:56", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择处理日期"),
        CheYuanOrCheLiangModel(identify:"proceduresType", title: "手续获取:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择手续获取方式"),
        shouXuModel,
        CheYuanOrCheLiangModel(identify:"proceduresType", title: "备注:", isValid: true, stringOfClassName: NSStringFromClass(DDTips.self)),
        
        
        
    ]
    lazy var shouXuModel : CheYuanOrCheLiangModel = {
        let m = CheYuanOrCheLiangModel(title: "手续:", isValid: true, stringOfClassName: NSStringFromClass(DDShouxu.self))
        m.shouXuTypes = [
            ShouXuTypeModel(title: "行驶本", false, 0 ,identify:"drivLicense"),
            ShouXuTypeModel(title: "登记证", false, 1, identify:"registLicense"),
            ShouXuTypeModel(title: "身份证复印件", false, 2, identify:"peopleLicense"),
            ShouXuTypeModel(title: "营业执照复印件", false, 3, identify:"busineseLicense"),
            ShouXuTypeModel(title: "车辆报废表", false, 4, identify:"breakLicense"),
            ShouXuTypeModel(title: "车辆事故证明", false, 5, identify:"exceptionLicense")
        ]
        return m
    }()
    var cheYuanID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.title = "增加车辆"
        if let id = self.userInfo as? String {self.cheYuanID = id}
        _addSubviews()
        self.tableView?.reloadData()
        tableView?.showsVerticalScrollIndicator = false
        tableView?.contentInset = UIEdgeInsetsMake(10, 0, 288, 0)
//        if tableView!.contentSize.height += 414// > tableView!.bounds.height{self.tableView?.isScrollEnabled = true}else{self.tableView?.isScrollEnabled = false}
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//actions
extension ZengJiaCheLiangeVC{
    @objc func addBtnClick(sender: UIButton){
        mylog("addBtnClick")
        var dict : [String:Codable] = [:]
        models.forEach { (model) in
            if model.identify == "proceduresType"{
                model.shouXuTypes.forEach { (shouXuModel) in
                    dict[shouXuModel.identify] = "\(shouXuModel.status)"
                }
            }else{
                dict[model.identify] = model.value
            }
        }
        dict["carSource"] = Int(self.cheYuanID)
        DDQueryManager.share.addCar(type: ApiModel<String>.self, para: dict) { (apiModel) in
            if apiModel.ret_code == "0"{
                GDAlertView.alert("增加成功") {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                GDAlertView.alert(apiModel.msg) 
            }
            
        }
        
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

extension ZengJiaCheLiangeVC : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch models[indexPath.row].stringOfClassName {
        case NSStringFromClass(DDSectionHeaderRow.self):
            return 48
        case NSStringFromClass(DDSingleInputRow.self):
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
            
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "xxx")
        }
        
    }
    
    
    
    
}

extension ZengJiaCheLiangeVC{
    func _addSubviews() {
        self.view.addSubview(addBtn)
        let tableViewFrame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width , height: self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        
        self.tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.plain)
        self.view.addSubview(self.tableView!)
        addBtn.frame = CGRect(x: 20, y: self.tableView!.frame.maxY, width: view.bounds.width - 40, height: 40)
        addBtn.backgroundColor = mainColor
        addBtn.setTitle("增加完成", for: UIControlState.normal)
        addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
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
