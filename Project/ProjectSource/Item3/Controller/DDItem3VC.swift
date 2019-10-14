//
//  DDItem3VC.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
let mainColor = UIColor.colorWithHexStringSwift("007EFE")
extension DDItem3VC{
    enum ProfileActionType : String {
        case setting = "setting"
        case helpDocument = "helpDocument"
        case modifyPassword = "modifPassword"
        case aboutUs = "aboutUs"
        case serviceTel = "serviceTel"
        case loginOut = "loginOut"
    }
    
}
class DDItem3VC: DDInternalVC {
    let headerBG = UIImageView()
    let department = UILabel()
    let name = ProfileNameControl()
    let mobile = UILabel()
    let icon = UIButton()
    let functionBG = UIView()
    let pending = ProfileControl()
    let pended = ProfileControl()
    let toStorage = ProfileControl()
    var apiModel : [(icon:UIImage?,title:String,arrow:Bool,actionType:ProfileActionType)] =  [
//        (icon:UIImage(named: "nav_shezhi"),title:"设置",arrow:true,actionType:.setting ),
        (icon:UIImage(named: "profile_edit_icon_touxiang"),title:"帮助文档",arrow:true,actionType:.helpDocument ),
        (icon:UIImage(named: "profile_edit_icon_touxiang"),title:"修改密码",arrow:true,actionType:.modifyPassword ),
        (icon:UIImage(named: "profile_edit_icon_touxiang"),title:"关于我们",arrow:true,actionType:.aboutUs ),
        (icon:UIImage(named: "profile_edit_icon_touxiang"),title:"客服电话",arrow:true ,actionType:.serviceTel ),
        (icon:UIImage(named: "profile_edit_icon_touxiang"),title:"退出登录",arrow:false ,actionType:.loginOut)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.isHidden = true
        _addSubviews()
        _layoutSubviews()
        self.tableView?.reloadData()
        tableView?.showsVerticalScrollIndicator = false
        if tableView!.contentSize.height > tableView!.bounds.height{self.tableView?.isScrollEnabled = true}else{self.tableView?.isScrollEnabled = false}
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileInfo() 
    }
}

//actions
extension DDItem3VC{
    @objc func modifyIcon(sender: UIButton){
        mylog("modify icon")
        self.navigationController?.pushViewController(ModiryProfileVC(), animated: true)
    }
    @objc func pending(sender: ProfileControl){
        mylog("pending")
    }
    @objc func pended(sender: ProfileControl){
        mylog("pended")
    }
    @objc func toStore(sender: ProfileControl){
        mylog("toStore")
    }
    func getProfileInfo()  {
        DDAccount.share.refreshInfo {
            self.updateUI()
        }
    }
    
    func updateUI()  {
        name.name = DDAccount.share.user_name
        department.text = DDAccount.share.department_name
        mobile.text = DDAccount.share.phone
        icon.setImageUrl(url: DDAccount.share.head_url, status: UIControlState.normal)
        self._layoutSubviews()
    }
    func makeCall() {
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
    func loginOut()  {
        var actions = [DDAlertAction]()
        
        let sure = DDAlertAction(title: "确定",textColor:mainColor, style: UIAlertActionStyle.default, handler: { (action ) in
            print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
            DDAccount.share.louginout()
            
        })
        
        let cancel = DDAlertAction(title: "取消",textColor:mainColor, style: UIAlertActionStyle.cancel, handler: { (action ) in
            print("cancel update")
        })
        actions.append(cancel)
        actions.append(sure)
        
        let alertView = DDAlertOrSheet(title: "退出登录", message: "您确定要退出登录?" , preferredStyle: UIAlertControllerStyle.alert, actions: actions)
        alertView.isHideWhenWhitespaceClick = false
        UIApplication.shared.keyWindow?.alert(alertView)
    }
    
}

extension DDItem3VC : UITableViewDelegate , UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = apiModel[indexPath.row]
        switch model.actionType {
        case .setting:
            self.pushVC(vcIdentifier: "DDSettingVC")
//            self.navigationController?.pushViewController(DDSettingVC(), animated: true )
            mylog(model.actionType.rawValue)
            break
        case .helpDocument:
            self.navigationController?.pushViewController(DDHelpDoc(), animated: true )
            mylog(model.actionType.rawValue)
            break
        case .modifyPassword:
            self.navigationController?.pushViewController(DDModifyPasswordVC(), animated: true )
            mylog(model.actionType.rawValue)
            break
        case .aboutUs:
            self.navigationController?.pushViewController(DDAboutUsVC(), animated: true )
            mylog(model.actionType.rawValue)
            break
        case .serviceTel:
            makeCall()
            mylog(model.actionType.rawValue)
            break
        case .loginOut:
            loginOut()
            mylog(model.actionType.rawValue)
            break
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.apiModel[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDMessageCell") as? DDMessageCell{
            cell.model = model
            //            cell.keyWorld = self.searchBox.text
            return cell
        }else{
            
            let cell = DDMessageCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDMessageCell")
            //            cell.keyWorld = self.searchBox.text
            cell.model = model
            return cell
        }
    }

    
    class DDMessageCell : UITableViewCell {
        let rowview = DDRowView()
        let bgView = UIView()
        var model : (icon:UIImage?,title:String,arrow:Bool,actionType:ProfileActionType) = (icon:nil,title:"",arrow:true,actionType:ProfileActionType.setting) {
            didSet{
                rowview.imageView.image = model.icon
                rowview.titleLabel.text = model.title
                rowview.additionalImageView.isHidden = !model.arrow
                
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.backgroundColor = UIColor.clear
            self.contentView.addSubview(bgView)
            bgView.addSubview(rowview)
            rowview.isUserInteractionEnabled = false
            rowview.imageView.image = UIImage(named:"profile_edit_icon_touxiang")
            rowview.titleLabel.text = "xxxxxxxxxx"
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            bgView.frame = CGRect(x: 0, y: 3, width: self.bounds.width , height: (self.bounds.height - 3 * 2))
            bgView.layer.cornerRadius = 4
            bgView.layer.masksToBounds = true
            rowview.frame = bgView.bounds
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

extension DDItem3VC{
    func _addSubviews() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.view.addSubview(self.tableView!)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.isScrollEnabled = false
        self.view.addSubview(headerBG)
        self.view.addSubview(department)
        self.view.addSubview(name)
        self.view.addSubview(mobile)
        self.view.addSubview(functionBG)
        self.view.addSubview(icon)
        self.functionBG.addSubview(pending)
        self.functionBG.addSubview(pended)
        self.functionBG.addSubview(toStorage)
        headerBG.backgroundColor = mainColor
        icon.setBackgroundImage(UIImage(named: "profile_edit_icon_touxiang"), for: UIControlState.normal)
        pending.model = (title:"待拆车辆",num:"3",isRed:true)
        pended.model = (title:"拆过车辆",num:"4",isRed:false)
        toStorage.model = (title:"入库的件",num:"4323",isRed:true)
        name.name = "王二"
        mobile.text = "电话: 17777777777"
        
        mobile.textColor = .white
        mobile.font = UIFont.systemFont(ofSize: 13)
        department.backgroundColor = .black
        department.text = "   拆解部"
        department.textColor = .white
        department.font = UIFont.boldSystemFont(ofSize: 16)
        functionBG.backgroundColor = UIColor.white
        icon.backgroundColor = .clear
        tableView?.backgroundColor = .clear
        tableView?.separatorStyle = .none
        icon.addTarget(self , action: #selector(modifyIcon(sender:)), for: UIControlEvents.touchUpInside)
        icon.adjustsImageWhenHighlighted = false
        pending.addTarget(self , action: #selector(pending(sender:)), for: UIControlEvents.touchUpInside)
        pended.addTarget(self , action: #selector(pended(sender:)), for: UIControlEvents.touchUpInside)
        toStorage.addTarget(self , action: #selector(toStore(sender:)), for: UIControlEvents.touchUpInside)
        name.addTarget(self , action: #selector(modifyIcon(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func _layoutSubviews() {
        headerBG.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width * 0.5)
        let margin : CGFloat = 15
        name.frame = CGRect(x: margin, y: headerBG.frame.midY - 30, width: headerBG.bounds.width * 0.5, height: 30)
        department.sizeToFit()
        department.frame = CGRect(x: headerBG.frame.width - department.bounds.width - 34, y: name.frame.minY, width: department.bounds.width * 3, height: 30)
        mobile.frame = CGRect(x: margin, y: headerBG.frame.midY, width: headerBG.bounds.width * 0.5, height: 30)
        let functionBGH : CGFloat = 96
        functionBG.frame = CGRect(x: margin, y: headerBG.frame.maxY - functionBGH * 0.46, width: headerBG.bounds.width - margin * 2, height: functionBGH)
        let iconSize = CGSize(width: 72, height: 72)
        icon.frame = CGRect(origin: CGPoint(x: headerBG.bounds.width/2 - iconSize.width/2, y: functionBG.frame.minY - iconSize.height/2 -  6), size: iconSize)
        let componentW = functionBG.bounds.width / 3
        let componentH = functionBG.bounds.height * 0.8
        pending.frame = CGRect(x: 0, y: 20, width: componentW, height: componentH)
        pended.frame = CGRect(x: pending.frame.maxX, y: pending.frame.minY, width: componentW, height: componentH)
        toStorage.frame = CGRect(x: pended.frame.maxX, y: pending.frame.minY, width: componentW, height: componentH)
        
        department.layer.cornerRadius = department.bounds.height/2
        department.layer.masksToBounds = true
        icon.layer.cornerRadius = icon.bounds.width/2
        icon.layer.borderWidth = 3
        icon.layer.borderColor = UIColor.white.cgColor
        icon.layer.masksToBounds = true
        
        functionBG.layer.cornerRadius = 4
        tableView?.frame = CGRect(x: margin, y: functionBG.frame.maxY + 5, width: self.view.bounds.width - margin * 2, height: self.view.bounds.height - functionBG.frame.maxY - 10 - DDTabBarHeight)
        setValueToUI()
    }
    func setValueToUI() {
        switch DDAccount.share.departmentType {
        case .admin:
            department.text = "   管理员"
        case .chaiJieBu:
            department.text = "   拆解部"
        case .shouXuBu:
            department.text = "   手续部"
        case .waiQinBu:
            department.text = "   外勤部"
        case .yeWuBu:
            department.text = "   业务部"
        case .kuGuanBu:
        department.text = "   库管部"
        }
    }
}
class ProfileControl: UIControl {
    let title = UILabel()
    let num = UILabel()
    let redLogo = UIView()
    var model : (title:String,num:String,isRed:Bool ) = (title:"chaichaichai",num:"333",isRed:true  ){
        didSet{
            setValueToUI()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(title)
        self.addSubview(num)
        self.addSubview(redLogo)
        redLogo.backgroundColor = .red
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 15)
        num.font = UIFont.systemFont(ofSize: 13)
        num.textColor = UIColor.gray
        title.textColor = UIColor.gray
    }
    func setValueToUI() {
        self.title.text = model.title
        self.num.text = model.num
        self.redLogo.isHidden = !model.isRed
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setValueToUI()
        title.frame = CGRect(x: 0, y: bounds.height * 0.5, width: bounds.width, height: bounds.height * 0.5)
        num.sizeToFit()
        num.center = CGPoint(x: bounds.width/2, y: bounds.height * 0.35)
        redLogo.frame = CGRect(x: num.frame.maxX, y: num.frame.minY, width: 5, height: 5)
        redLogo.layer.cornerRadius = redLogo.bounds.width/2
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class ProfileNameControl: UIControl {
    private let title = UILabel()
    var name : String? {
        get{return title.text}
        set{title.text = newValue
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    private let arrow = UIImageView(image:UIImage(named:"icon_arrow_right1"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(title)
        self.addSubview(arrow)
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = UIColor.white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        title.sizeToFit()
        title.frame = CGRect(x: 0, y: 0, width: title.bounds.width, height: bounds.height)
        arrow.frame.scaleHeightTo(12)
        arrow.frame = CGRect(x: title.frame.maxX + 10, y: (bounds.height - arrow.frame.height)/2, width: arrow.frame.width, height: arrow.frame.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension DDItem3VC {
    
    class DDRowView: UIControl {
        private var customView : UIView = UIView()
        /*
         // Only override draw() if you perform custom drawing.
         // An empty implementation adversely affects performance during animation.
         override func draw(_ rect: CGRect) {
         // Drawing code
         }
         */
        
        lazy var titleLabel = UILabel()//主标题
        lazy var subTitleLabel = UILabel()//副标题
        lazy var additionalLabel = UILabel()
        lazy var imageView = UIImageView()//左侧icon
        lazy var subImageView = UIImageView()//右侧图片
        lazy var additionalImageView = UIImageView()//右侧箭头
        
        
        
        var diyView = UIView(){
            didSet{
                for view in self.customView.subviews {
                    view.removeFromSuperview()
                }
                self.customView.addSubview(diyView)
                self.customView.frame = diyView.frame
                diyView.frame = self.customView.bounds
                
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(customView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.subTitleLabel)
            self.addSubview(self.imageView)
            self.addSubview(self.subImageView)
            self.addSubview(self.additionalImageView)
            //        self.titleLabel.backgroundColor = UIColor.red
            //        self.subTitleLabel.backgroundColor = UIColor.yellow
            //        self.imageView.backgroundColor = UIColor.blue
            //        self.subImageView.backgroundColor = UIColor.purple
            //        self.additionalImageView.backgroundColor = UIColor.orange
            self.additionalImageView.image = UIImage(named: "icon_arrow_right2")
            
            self.imageView.contentMode = UIViewContentMode.scaleAspectFit
            self.subImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.additionalImageView.contentMode =  UIViewContentMode.scaleAspectFit
            
            self.titleLabel.textColor = UIColor.darkGray
            self.subTitleLabel.textColor = UIColor.lightGray
            self.titleLabel.font = GDFont.systemFont(ofSize: 14)
            self.subTitleLabel.font = GDFont.systemFont(ofSize: 13)//GDFont.systemFont(ofSize: 13*SCALE)
            //        self.addSubview(<#T##view: UIView##UIView#>)
            self.additionalImageView.isHidden = true
            self.backgroundColor = .white
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 13.0
            let selfH = self.bounds.size.height
            let selfW = self.bounds.size.width
            //有图和没图情况下 左侧的布局
            if self.imageView.image == nil {//忽略左侧图标 , 直接布局标题
                self.imageView.isHidden = true
                let titleLabelY : CGFloat = 0.0
                let titleLabelX =  margin
                let titleLabelH = selfH
                let titleLabelW = selfW * 0.5 - titleLabelX
                self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
                
            }else{
                self.imageView.isHidden = false//先布局图标 , 再布局标题
                let imageViewH : CGFloat = selfH - margin * 2
                let imageViewW = imageViewH
                let imageViewX = margin
                let imageViewY = margin
                self.imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
                let titleLabelY : CGFloat = 0.0
                let titleLabelX = self.imageView.frame.maxX + margin
                let titleLabelH = selfH
                let titleLabelW = selfW * 0.5 - titleLabelX
                self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
                
            }
            
            
            //箭头隐藏和不隐藏情况下 右侧的布局
            if self.additionalImageView.isHidden   {
                
                if self.subImageView.image == nil {//忽略箭头 , 忽略subimageView并隐藏
                    self.subImageView.isHidden = true//布局文字
                    let subLabelX : CGFloat = selfW * 0.5
                    let subLabelY : CGFloat = 0.0
                    let subLabelW : CGFloat =  selfW*0.5 - margin
                    let subLabelH : CGFloat = selfH
                    self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                    self.subTitleLabel.textAlignment = NSTextAlignment.right
                    
                }else{//显示subimageView ,并先布局它  , 再布局subtitleLabel//既有文字又有图片的情况先不考虑
                    self.subImageView.isHidden = false
                    //暂时先只布局图片
                    let subImageViewH : CGFloat = selfH - margin * 2
                    let subImageViewW = subImageViewH
                    let subImageViewY = margin
                    let subImageViewX = selfW - margin - subImageViewW
                    self.subImageView.frame = CGRect(x: subImageViewX, y: subImageViewY, width: subImageViewW, height: subImageViewH)
                    //等待布局文字
                    let subLabelX : CGFloat = selfW * 0.5
                    let subLabelY : CGFloat = 0.0
                    let subLabelW : CGFloat = self.subImageView.frame.minX - margin - selfW*0.5
                    let subLabelH : CGFloat = selfH
                    self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                    self.subTitleLabel.textAlignment = NSTextAlignment.right
                }
            }else{//先显示并布局箭头
                //布局箭头
                let addiW : CGFloat = 10.0
                let addiH : CGFloat = 14.0
                let addiX : CGFloat = selfW - margin - addiW
                let addiY : CGFloat = (selfH - addiH) * 0.5
                self.additionalImageView.frame = CGRect(x: addiX, y: addiY, width: addiW, height: addiH)
                
                
                
                if self.subImageView.image == nil {//忽略subimageView并隐藏 ,布局subtitleLabel
                    self.subImageView.isHidden = true
                    let subLabelX : CGFloat = selfW * 0.5
                    let subLabelY : CGFloat = 0.0
                    let subLabelW : CGFloat = self.additionalImageView.frame.minX - margin - selfW*0.5
                    let subLabelH : CGFloat = selfH
                    self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                    self.subTitleLabel.textAlignment = NSTextAlignment.right
                    
                }else{//先布局subimageView , 再布局subtitleLabel
                    self.subImageView.isHidden = false//暂时先只布局图片
                    let subImageViewH : CGFloat = selfH - margin * 2
                    let subImageViewW = subImageViewH
                    let subImageViewY = margin
                    let subImageViewX = self.additionalImageView.frame.minX - margin - subImageViewW
                    self.subImageView.frame = CGRect(x: subImageViewX, y: subImageViewY, width: subImageViewW, height: subImageViewH)
                    //等待布局文字
                    let subLabelX : CGFloat = selfW * 0.5
                    let subLabelY : CGFloat = 0.0
                    let subLabelW : CGFloat = self.subImageView.frame.minX - margin - selfW*0.5
                    let subLabelH : CGFloat = selfH
                    self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                    self.subTitleLabel.textAlignment = NSTextAlignment.right
                    
                }
            }
            
        }
        
        
    }

}
