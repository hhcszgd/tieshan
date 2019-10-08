//
//  ChuangJianCheYuanVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

extension ChuangJianCheYuanVC{
    enum ProfileActionType : String {
        case setting = "setting"
        case helpDocument = "helpDocument"
        case modifyPassword = "modifPassword"
        case aboutUs = "aboutUs"
        case serviceTel = "serviceTel"
        case loginOut = "loginOut"
    }
    
}

class ChuangJianCheYuanVC: ChuangJianVC {
    let addBtn = UIButton()
    lazy var models  : [CheYuanOrCheLiangModel] =  [
        CheYuanOrCheLiangModel( title: "基本信息:", isValid: false , stringOfClassName: NSStringFromClass(DDSectionHeaderRow.self)),
        CheYuanOrCheLiangModel(identify:"contacts",title: "联系人姓名:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系人姓名"),
        CheYuanOrCheLiangModel(identify:"phone",title: "联系人电话:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系人电话"),
        CheYuanOrCheLiangModel(identify:"count",title: "车辆台次:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入车辆台次"),
        CheYuanOrCheLiangModel(identify:"carLocation",title: "联系地址:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系地址"),
        CheYuanOrCheLiangModel( isValid: false, stringOfClassName: NSStringFromClass(DDSectionSeparator.self)),
        CheYuanOrCheLiangModel(title: "银行信息:", isValid: false , stringOfClassName: NSStringFromClass(DDSectionHeaderRow.self)),
        
        CheYuanOrCheLiangModel(identify:"bankName",title: "银行名称:",value : "中国建设银行", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择银行"),
        
        
        
        CheYuanOrCheLiangModel(identify:"bankBranch",title: "支行名称:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入支行名称"),
        CheYuanOrCheLiangModel(identify:"account",title: "银行账号:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入银行账号"),
        CheYuanOrCheLiangModel(identify:"payee",title: "账户姓名:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入账户姓名")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.title = "创建车源"
        _addSubviews()
        self.tableView?.reloadData()
        tableView?.showsVerticalScrollIndicator = false
        tableView?.contentInset = UIEdgeInsetsMake(10, 0, 288, 0)
//        if tableView!.contentSize.height > tableView!.bounds.height{self.tableView?.isScrollEnabled = true}else{self.tableView?.isScrollEnabled = false}
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//actions
extension ChuangJianCheYuanVC{
    @objc func addBtnClick(sender: UIButton){
        var dict : [String: String ] = [:]
        self.models.forEach { (model ) in
            if !model.identify.isEmpty{dict[model.identify] = model.value}
            
        }
        DDQueryManager.share.chuangJianCheYuan(type: ApiModel<String>.self, para: dict, failure: { (error ) in
            GDAlertView.alert("创建失败,请重试")
        }) { (apiModel) in
            mylog(apiModel.msg)
            mylog(apiModel.ret_code)
            mylog(apiModel.data)
            if apiModel.ret_code == "0"{
                GDAlertView.alert("创建成功") {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{GDAlertView.alert(apiModel.msg)}
        }
        mylog("addBtnClick")
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

extension ChuangJianCheYuanVC : UITableViewDelegate , UITableViewDataSource{
    
    
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

extension ChuangJianCheYuanVC{
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
