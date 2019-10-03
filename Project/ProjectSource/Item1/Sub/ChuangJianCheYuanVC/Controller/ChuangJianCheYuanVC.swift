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

class ChuangJianCheYuanVC: DDInternalVC {
    let addBtn = UIButton()
    var models  : [CheYuanOrCheLiangModel] =  [
        CheYuanOrCheLiangModel(title: "基本信息:", isValid: false , stringOfClassName: NSStringFromClass(DDSectionHeaderRow.self)),
        CheYuanOrCheLiangModel(title: "联系人姓名:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系人姓名"),
        CheYuanOrCheLiangModel(title: "联系人电话:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系人电话"),
        CheYuanOrCheLiangModel(title: "车辆台次:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入车辆台次"),
        CheYuanOrCheLiangModel(title: "联系地址:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入联系地址"),
        CheYuanOrCheLiangModel( isValid: false, stringOfClassName: NSStringFromClass(DDSectionSeparator.self)),
        CheYuanOrCheLiangModel(title: "银行信息:", isValid: false , stringOfClassName: NSStringFromClass(DDSectionHeaderRow.self)),
        
        CheYuanOrCheLiangModel(title: "银行名称:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleChoose.self),placeholder: "请选择银行"),
        
        
        
        CheYuanOrCheLiangModel(title: "支行名称:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入支行名称"),
        CheYuanOrCheLiangModel(title: "银行账号:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入银行账号"),
        CheYuanOrCheLiangModel(title: "账户姓名:", isValid: true, stringOfClassName: NSStringFromClass(DDSingleInputRow.self),placeholder: "请输入账户姓名"),
        
        
        
        
        CheYuanOrCheLiangModel(title: "备注:", isValid: true, stringOfClassName: NSStringFromClass(DDTips.self)),
        CheYuanOrCheLiangModel(title: "手续:", isValid: true, stringOfClassName: NSStringFromClass(DDShouxu.self)),
        
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "创建车源"
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
extension ChuangJianCheYuanVC{
    @objc func addBtnClick(sender: UIButton){
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
        mylog(3333333333333333333)
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

enum CheRowIdentifyType {
    case contactName
    case contactMobile
    case contactAddress
    case taiCi
    case bankName
    case branchBankName
    case bankNumber
    case bankAccountName
    case carNum
    /// 车型
    case carType
    case dealStyle
    case dealDate
    case shouXuHuoQuStyle
    case shouXu
    case tips
}
enum CheRowFunctionType {
    case singleChoose
    case multipleChoose
    case singleInput
    case multipleInput
    case chooseAndInput
    case save
    case sectionSpace
    case rowSpace
    case title
}
class CheYuanOrCheLiangModel {
    var title : String = ""
    /// name of cell
    var stringOfClassName = ""
    var placeHolder = ""
    var value = ""
    var addtionalValue = ""
    var id = ""
    var values : [Any] = []
    var isValid: Bool = true//是否有效
    var identify : CheRowIdentifyType = .contactName
    
    convenience init(title: String = "", isValid: Bool = true, stringOfClassName : String, placeholder: String = ""){
        self.init()
        self.title = title
        self.isValid = isValid
        self.stringOfClassName = stringOfClassName
        self.placeHolder = placeholder
    }
}
extension ChuangJianCheYuanVC{
    class DDSingleInputRow : UITableViewCell {
        let bottomLine = UIView()
        let title = UILabel()
        let textfield = UITextField()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
                textfield.placeholder = model.placeHolder
                textfield.text = model.value.isEmpty ? nil : model.value
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(textfield)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = mainBgColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            title.frame = CGRect(x: 10, y: 0, width: 100, height: bounds.height)
            textfield.frame = CGRect(x:title.frame.maxX, y: 0, width: bounds.width - title.frame.maxX - 20, height: bounds.height)
            bottomLine.frame  = CGRect(x:0, y: 0, width: bounds.height - 1, height: 1)
        }
        
    }
    class DDSectionHeaderRow : UITableViewCell {
        let blockView = UIView()
        let titleLabel = UILabel()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                titleLabel.text = model.title
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.backgroundColor = UIColor.white
            blockView.backgroundColor = mainColor
            self.contentView.addSubview(blockView)
            self.contentView.addSubview(titleLabel)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            blockView.frame = CGRect(x: 10, y: (bounds.height - 20 ) / 2, width: 4 , height: 20)
            titleLabel.frame = CGRect(x:blockView.frame.maxX + 10, y: 0 , width: bounds.width - blockView.frame.maxX - 30 , height: bounds.height)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    class DDSectionSeparator : UITableViewCell {
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.backgroundColor = mainBgColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDSingleChoose : UITableViewCell{
        let bottomLine = UIView()
        let title = UILabel()
        let arrow = UIImageView(image: UIImage(named:"icon_arrow_right2"))
        let textfield = UITextField()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
                textfield.placeholder = model.placeHolder
                textfield.text = model.value.isEmpty ? nil : model.value
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(arrow)
            self.contentView.addSubview(textfield)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = mainBgColor
            textfield.isEnabled = false
            arrow.contentMode = .scaleAspectFit
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            title.frame = CGRect(x: 10, y: 0, width: 100, height: bounds.height)
            arrow.frame = CGRect(x:bounds.width - 8 - 10, y: 0, width: 8, height: bounds.height)
            textfield.frame = CGRect(x:title.frame.maxX, y: 0, width: arrow.frame.minX - title.frame.maxX - 20, height: bounds.height)
            bottomLine.frame  = CGRect(x:0, y: 0, width: bounds.height - 1, height: 1)
        }
    }
    
    
    
    class DDTips : UITableViewCell , UITextViewDelegate{
        let title = UILabel()
        let textfield = UITextView()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
                if model.value.isEmpty {
                    textfield.text = "请输入..."
                    textfield.textColor = UIColor.lightGray
                }else{
                    textfield.text = model.value
                    textfield.textColor = UIColor.darkGray
                }
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(textfield)
            textfield.delegate = self
            textfield.backgroundColor = UIColor.DDLightGray1
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            title.frame = CGRect(x: 10, y: 0, width: 100, height: 38)
            textfield.frame = CGRect(x:title.frame.maxX, y: 0, width: bounds.width - title.frame.maxX - 20, height: bounds.height - 20)
        }
        
        func textViewDidEndEditing(_ textView: UITextView){
            if textView.text == ""{
                textView.text = "请输入"
                textView.textColor = UIColor.lightGray
            }
            mylog("...")
        }
        func textViewDidBeginEditing(_ textView: UITextView){
            if textView.text == "请输入"{
                textView.text = ""
                textView.textColor = UIColor.darkGray
            }
        }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
            if text == "\n"{
                textView.endEditing(true)
                return false
            }
            //        if textView.text.count > 120 && text.count > 0{
            //            return false
            //        }
            return true
        }
    }
    
    
    
    
    class DDShouxu : UITableViewCell{
        let bottomLine = UIView()
        let title = UILabel()
        let types: [(String,Int)] = [
            ("行驶本",0),
            ("登记证",1),
            ("身份证复印件",2),
            ("营业执照复印件",3),
            ("车辆报废表",4),
            ("车辆事故证明",5)
        ]
        lazy var btns: [UIButton] = {
            
            return self.types.map { (type ) -> UIButton in
                let btn = UIButton()
                btn.setTitle(type.0, for: UIControlState.normal)
                btn.setBackgroundImage(UIImage.ImageWithColor(color: mainColor, frame: CGRect(origin: .zero, size: CGSize(width: 88, height: 40))), for: UIControlState.normal)

                btn.setTitleColor(mainColor, for: UIControlState.selected)

                btn.setTitleColor(UIColor.gray, for: UIControlState.normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                self.contentView.addSubview(btn)
                btn.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
                return btn
            }
        }()
        /// 状态需要模型控制
        @objc func btnClick(sender:UIButton) {
            sender.isSelected = !sender.isSelected
        }
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = mainBgColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            title.frame = CGRect(x: 10, y: 0, width: 100, height: 38)
            let margin : CGFloat = 8
            let space = margin * 3 + 10
            let firstX = title.frame.maxX
            let firstY = margin
            let oneH = (bounds.height - margin * 3) / 2
            let oneW = (bounds.width - title.frame.maxX - space) / 3
            for (index , btn) in btns.enumerated(){
                btn.frame = CGRect(x: firstX + CGFloat(index % 3) * (oneW + margin) , y: CGFloat(index / 3) * (oneH + margin), width: oneW, height: oneH)
                if btn.isSelected{
                }else{
                    
                }
            }
            bottomLine.frame  = CGRect(x:0, y: 0, width: bounds.height - 1, height: 1)
        }
    }
    
}
