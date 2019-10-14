//
//  DDItem1VC.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit
import CryptoSwift
import CoreLocation
class DDItem1VC: DDNormalVC , UITextFieldDelegate{
    var collection : UICollectionView!
    let sectionHeaderH : CGFloat = 240 * SCALE
    let collectionHeader = HomeCollectionHeader()
//    var apiModel = DDHomeApiModel()
    var apiModel = ApiModel<HomeDataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiModel.data =  getHomeData()
        todoSomethingAfterCheckVersion()
        configCollectionView()
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        performRequestApi()
        
        self.title = "工作台"
//        self.navigationController?.title = nil
        let name = NSNotification.Name.init("ChangeSquenceSuccess")
        NotificationCenter.default.addObserver(self , selector: #selector(changeSquenceSuccess), name: name , object: nil )
//        let refreshControl = GDRefreshControl.init(target: self , selector: #selector(refresh))
//        let images = [UIImage.init(named: "loading1.png")!, UIImage.init(named: "loading2.png")!, UIImage.init(named: "loading3.png")!, UIImage.init(named: "loading4.png")!, UIImage.init(named: "loading5.png")!]
//        refreshControl.refreshingImages = images
//        refreshControl.pullingImages = images
//        refreshControl.successImage = UIImage.init(named: "loading1.png")!
//        refreshControl.failureImage = UIImage.init(named: "loading2.png")!
//        refreshControl.refreshingImages = [UIImage.init()]
//        refreshControl.refreshHeight = 40
//        self.collection.gdRefreshControl = refreshControl
        
        
    }
    
    @objc override func refresh() {
        self.performRequestApi()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.performRequestApi()
    }
    
    @objc func changeSquenceSuccess() {
        performRequestApi()
    }
    func performRequestApi()  {
        
    }
    
    func configCollectionView()  {
        let toBorderMargin :CGFloat  = 20
        let itemMargin  : CGFloat = 2
        let itemCountOneRow = 4
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.sectionInset = UIEdgeInsetsMake(0, toBorderMargin, 0, toBorderMargin)
        let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow)) / CGFloat(itemCountOneRow)
        let itemH = itemW
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
//        flowLayout.minimumInteritemSpacing = 3
//        flowLayout.minimumLineSpacing = 3
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 40)
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  DDNavigationBarHeight , width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.backgroundColor = UIColor.clear
        collection.register(HomeItem.self , forCellWithReuseIdentifier: "HomeItem")
        collection.register(HomeSectionFooter.self , forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter")
        collection.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader")
        
        collection.contentInset = UIEdgeInsetsMake(sectionHeaderH, 0, 10, 0  )
        collectionHeader.bannerActionDelegate = self
        collectionHeader.msgActionDelegate = self
        if let model = self.apiModel.data?.lastestMessage{
            collectionHeader.msgModel =    model
        }
        if let model = self.apiModel.data?.banners{
            collectionHeader.bannerModels = model
        }
        collection.addSubview(collectionHeader)
        collectionHeader.frame = CGRect(x: ToScreenEdge, y: -sectionHeaderH + ToScreenEdge, width: collection.bounds.width - ToScreenEdge * 2, height: sectionHeaderH - ToScreenEdge )
//        collectionHeader.layer.cornerRadius = 5
//        collectionHeader.layer.masksToBounds = true
        

        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        collection.alwaysBounceVertical = true
        collection.showsVerticalScrollIndicator = false 
    }

}



extension DDItem1VC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.apiModel.data?.functionSessions?[indexPath.section].functions?[indexPath.item]
        
//        var targetVC : UIViewController!
        
        var target = model?.actionType ?? ""
//        self.pushVC(vcIdentifier: target + "VC", userInfo : nil )
        mylog(target)
        var userInfo : Any?
        switch target {
        case     "ChuangJianCheYuan" :
            userInfo = nil
        case     "ChaKanCheYuan":
            userInfo = nil
        case     "HeDangTongGuo"://业务部核档通过
           userInfo = nil
        case     "SaoYiSao":
            let scanner = CarScannerVC()
            scanner.complateHandle = {[weak self] result in
                mylog(result)
            }
            self.navigationController?.pushViewController(scanner, animated: true)
//            self.present(scanner, animated: true) {}
            return
//           userInfo = nil
        case     "CheLiangRuChang":
           userInfo = nil
        case     "DengDaiChuJian":
            userInfo = nil
        case     "DengDaiYuChuLi":
            userInfo = nil
        case     "DengDaiTuoHao":
           userInfo = nil
        case     "ChaiJieFangShiShouXuBu":
           userInfo = nil
        case     "CunFangWeiZhi":
           userInfo = nil
        case     "DaiHuiXingCheLiang":
           userInfo = nil
        case "YiHuiXing":
            userInfo = nil
        case     "BuPaiZhaoPianShouXuBu":
           userInfo = nil
        case     "JianXiaoCheLiang":
            userInfo = nil
        case     "YiRuKu":
            target = "ChaiGuoDeChe"
           userInfo = 2
        case     "WeiChaiJie":
            target = "ChaiGuoDeChe"
           userInfo = 0
        case     "ChaiGuoDeChe":
            target = "ChaiGuoDeChe"
            userInfo = 1
        case     "BuPaiZhaoPianChaJieBu":
            userInfo = nil
        case     "HeDangWeiTongGuo":
            userInfo = 1 //
            target = "WeiHeDang"
        case     "HeDangYiTongGuo": // 外勤部核档通过
            userInfo = 2 //
            target = "WeiHeDang"
        case     "WeiHeDang":
            userInfo = 0 //
        case "RuKuGuanLi":
            userInfo = nil
        default:
            userInfo = nil
        }
        self.pushVC(vcIdentifier: target + "VC", userInfo : userInfo )
    }
//        func getMessageModels() -> [DDHuDong] {
//        var models = [DDHuDong]()
//        for index  in 0...5 {
//            let model = DDHuDong()
//            model.hd_name = "\(index)\(index)\(index)"
//            model.hd_title = "\(index)\(index)\(index)"
//            model.nikename = "\(index)\(index)\(index)"
//            models.append(model)
//        }
//        return models
//    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind ==  UICollectionElementKindSectionHeader{
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader", for: indexPath) as? HomeSectionHeader{
                
//                header.bounds = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 40)
                header.titleLabel.text = self.apiModel.data?.functionSessions?[indexPath.section].title
                return header
                
            }
        }else if kind == UICollectionElementKindSectionFooter  {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter", for: indexPath)
            footer.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 0)
            return footer
        }
        return UICollectionReusableView.init()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return apiModel.data?.functionSessions?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.functionSessions?[section].functions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeItem", for: indexPath)
        if let itemUnwrap = item as? HomeItem , let model = self.apiModel.data?.functionSessions?[indexPath.section].functions?[indexPath.row]{
            itemUnwrap.model = model
        }
//        item.backgroundColor = UIColor.randomColor()
        return item
    }

}
extension DDItem1VC : BannerAutoScrollViewActionDelegate , DDMsgScrollViewActionDelegate{
    func performMsgAction(indexPath: IndexPath) {
        if let data = self.apiModel.data{
            let msgModel = data.lastestMessage
//            toWebView(messageID: msgModel.id)
            mylog(indexPath)
            
        }
    }
    @objc func toWebView(messageID:String) {
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: DomainType.wap.rawValue + "message/\(messageID)?type=notice")
//        let model = DDActionModel.init()
//        model.keyParameter = DomainType.wap.rawValue + "message/\(messageID)?type=notice"
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
    func moreBtnClick() {
        mylog("to message page ")
        rootNaviVC?.selectChildViewControllerIndex(index: 3)
    }
    
    func performBannerAction(indexPath : IndexPath) {
        
        if let data = self.apiModel.data{
            let model = data.banners[indexPath.item % data.banners.count]
            self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: model.link_url)
        }

//        mylog(indexPath)
//        model.keyParameter = model.link_url
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
    
    
}
import SDWebImage
class HomeItem : UICollectionViewCell {
    var model : DDHomeFoundation = DDHomeFoundation(){
        didSet{
            if let url  = URL(string:model.image_url ?? "") {
//                imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                imageView.image = DDPlaceholderImage
            }
            imageView.image = UIImage(named: model.image_url ?? "")
            label.text = model.name
        }
    }
    
    
    let imageView = UIImageView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView )
        self.contentView.addSubview(label )
        self.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        label.text = "exemple"
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = GDFont.systemFont(ofSize: 13.4)
        label.adjustsFontSizeToFitWidth = true 
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageViewWH : CGFloat = bounds.width * 0.34
        let imageViewXY : CGFloat = (bounds.width - imageViewWH ) / 2
        imageView.frame = CGRect(x: imageViewXY , y : imageViewXY * 0.7 , width : imageViewWH , height : imageViewWH)
        label.frame = CGRect(x:0  , y : bounds.height - 33 , width : self.bounds.width , height : 33)
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeCollectionHeader: UIView ,BannerAutoScrollViewActionDelegate , DDMsgScrollViewActionDelegate{

    
    func performMsgAction(indexPath: IndexPath) {
        self.msgActionDelegate?.performMsgAction(indexPath: IndexPath(item: 0, section: 0   ))
    }
    func moreBtnClick() {
        self.msgActionDelegate?.moreBtnClick()
    }
    
    func performBannerAction(indexPath : IndexPath) {
        self.bannerActionDelegate?.performBannerAction(indexPath: indexPath)
    }
    
    var msgModel : DDHomeMsgModel = DDHomeMsgModel(){
        didSet{
            message.model = msgModel
        }
    }
    var bannerModels : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            banner.models = bannerModels
        }
    }
    weak var bannerActionDelegate : BannerAutoScrollViewActionDelegate?
    
    weak var msgActionDelegate : DDMsgScrollViewActionDelegate?
    let banner = HomeBannerScrollView.init(frame: CGRect.zero)
    let message : NewHomeMessage = NewHomeMessage(frame: CGRect.zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(message)
        self.addSubview(banner)
        banner.delegate = self
        message.addTarget(self , action: #selector(messageClick), for:.touchUpInside)
//        message.delegate = self
    }
    @objc func messageClick(){
         performMsgAction(indexPath: IndexPath(item: 0, section: 0))
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorder : CGFloat = 0
        message.frame = CGRect(x:toBorder , y : self.bounds.height - 70, width : self.bounds.width - toBorder * 2 , height : 70 )
        banner.frame = CGRect(x:0 , y : 0 , width : self.bounds.width  , height : self.bounds.height - message.bounds.height - 15 )
        banner.layer.cornerRadius = 5
        banner.layer.masksToBounds = true
        message.layer.cornerRadius = 5
        message.layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
final class NewHomeMessage: UIControl {
    private let icon = UIImageView(image: UIImage(named: "home_icon-tongzhi"))
    private let notice = UILabel()
    private let line = UIView()
    private let noticeTitle = UILabel()
    var model  : DDHomeMsgModel? = DDHomeMsgModel(){
        didSet{
            self.noticeTitle.text = model?.title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.addSubview(icon)
        self.addSubview(notice)
        self.addSubview(line )
        line.backgroundColor = mainColor
        notice.text = "通知"
        self.backgroundColor = UIColor.white
        self.addSubview(noticeTitle)
        notice.textColor = UIColor.gray
        noticeTitle.textColor = UIColor.gray
        notice.font = UIFont.systemFont(ofSize: 16)
        noticeTitle.font = UIFont.systemFont(ofSize: 13)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.frame = CGRect(x: 10, y: 10, width: 15, height: 15)
        notice.sizeToFit()
        notice.frame = CGRect(x: icon.frame.maxX + 5, y: icon.frame.minY - 2, width: notice.bounds.width, height: 20)
        line.frame = CGRect(x: notice.frame.minX, y: notice.frame.maxY + 1, width: notice.frame.width + 3, height: 1.5)
        noticeTitle.frame = CGRect(x: icon.frame.maxX + 5, y: line.frame.maxY, width: self.bounds.width - (icon.frame.maxX + 15) , height: self.bounds.height - line.frame.maxY)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private let ToScreenEdge : CGFloat = 20
class HomeSectionHeader: UICollectionReusableView {
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.backgroundColor = UIColor.clear
        self.titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.gray
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: ToScreenEdge, y: 0, width: bounds.width - 30, height: bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HomeBannerScrollView : UIView , BannerAutoScrollViewActionDelegate{
    func performBannerAction(indexPath : IndexPath) {
        self.delegate?.performBannerAction(indexPath: indexPath)
    }
    
    var models : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            self.banner.models = models
        }
    }
    let banner = DDLeftRightAutoScroll.init(frame: CGRect.zero)
    weak var delegate : BannerAutoScrollViewActionDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(banner)
        banner.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        banner.frame = CGRect(x:0  , y: 0  , width : self.bounds.width , height : self.bounds.height)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol DDMsgScrollViewActionDelegate : NSObjectProtocol{
    func performMsgAction(indexPath : IndexPath)
    func moreBtnClick()
}
class HomeMessageScrollView : UIView , DDUpDownAutoScrollDelegate{
    var models : [DDHomeMsgModel] = [DDHomeMsgModel](){
        didSet{
            self.messageScrollView.models = models
        }
    }
    let messageScrollView : DDUpDownAutoScroll = DDUpDownAutoScroll.init(frame: CGRect.zero)
    weak var delegate : DDMsgScrollViewActionDelegate?
    let  leftBtn = UIButton()
    let  rightBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        self.addSubview(messageScrollView)
        messageScrollView.delegate = self
//        leftBtn.setTitle("logo", for: UIControlState.normal)
        leftBtn.setImage(UIImage(named:"notificationicon"), for: UIControlState.normal)
        rightBtn.setTitle("更多", for: UIControlState.normal)
        rightBtn.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        leftBtn.setTitleColor(UIColor.DDTitleColor, for: UIControlState.normal)
//        rightBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        rightBtn.addTarget(self , action: #selector(moreBtnClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        rightBtn.frame = CGRect(x:self.bounds.width - self.bounds.height  , y: self.bounds.height/5  , width : self.bounds.height , height : self.bounds.height/2.5)
        rightBtn.ddSizeToFit()
        rightBtn.bounds = CGRect(x: 0, y: 0, width: rightBtn.bounds.width + 8, height: (rightBtn.titleLabel?.font.lineHeight ?? 13 ) + 3)
        rightBtn.center = CGPoint(x: self.bounds.width - rightBtn.bounds.width/2 - 10 , y: self.bounds.height/2)
        rightBtn.layer.cornerRadius = rightBtn.bounds.height/2
        rightBtn.layer.masksToBounds = true
        rightBtn.backgroundColor = .orange
        leftBtn.frame = CGRect(x:0  , y: 0  , width : self.bounds.height , height : self.bounds.height)
        messageScrollView.frame = CGRect(x: leftBtn.frame.maxX    , y: 0 , width : rightBtn.frame.minX - leftBtn.frame.maxX , height : self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func performMsgAction(indexPath : IndexPath){
        self.delegate?.performMsgAction(indexPath: indexPath)
    }
    @objc func moreBtnClick(sender:UIButton)  {
        self.delegate?.moreBtnClick()
    }

    
}

class HomeSectionFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDItem1VC{
    
    func todoSomethingAfterCheckVersion() {
        checkAppVersion { (result , description) in
            
            if let result = result{
                var actions = [DDAlertAction]()
                
                let sure = DDAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action ) in
                    print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
                    let urlStr =  "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8"
                    if let url = URL(string: urlStr){
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url )
                        }
                    }
                })
                actions.append(sure)
                if result{
                    print("force update")
                    sure.isAutomaticDisappear = false
                }else{
                    let cancel = DDAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action ) in
                         print("cancel update")
                    })
                    actions.append(cancel)
                }
                let alertView = DDAlertOrSheet(title: "新版本提示", message: description , preferredStyle: UIAlertControllerStyle.alert, actions: actions)
                alertView.isHideWhenWhitespaceClick = false 
                UIApplication.shared.keyWindow?.alert(alertView)
            }else{
                print("无最新版本")
            }
        }
            
            
            
            
//            print(result)
//            var actions = [UIAlertAction]()
//            let sure = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action ) in
//                print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
//               let urlStr =  "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8"
//                    if let url = URL(string: urlStr){
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.openURL(url )
//                    }
//                }
//            })
//
//            actions.append(sure)
//
//            if let result = result{
//                if result{
//                    print("force update")
//                }else{
//                    let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action ) in
//                        print("cancel update")
//                    })
//                        actions.append(cancel)
//                }
//                self.alert(title: description ?? "提示", detailTitle: nil , actions: actions)
//            }
//        }
    }
    
    
    struct CheckAppVersionResultModel  :  Codable{
        var upgrade_type : String
        var version : String
        var url  : String
        var desc : String
    }
    
    /// checkAppVersion
    ///
    /// - Parameter callBack: callBack block's parameter equal nil means need't update , false means optional update , true means force update
    /// - Parameter description : alert Message
    func checkAppVersion(callBack:@escaping (Bool?,String?) -> Void) {
        DDRequestManager.share.checkLatestAppVersion()?.responseJSON(completionHandler: { (response) in
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<CheckAppVersionResultModel>.self, from: response){
                print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
                dump(apiModel)
                let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                if  apiModel.data?.version ?? "" > currentAppVersion{ // 有新版本了
                    if apiModel.data?.upgrade_type ?? "" == "1"{//强制更新
                        callBack(true , apiModel.data?.desc)
                    }else{//非强制更新
                        callBack(false,apiModel.data?.desc)
                    }
                }else{//无新版本
                    callBack(nil,apiModel.data?.desc)
                }
                
            }
        })
    }
    
    func noPayPasswordAlertWhileGetCash() {
   
    }
    
    func noAuthorizedAlertWhileBandCard() {

    }
    func noAuthorizedAlertWhileGetCash() {
        

    }

    
}

struct PublickKeyModel : Codable {
    var public_key : String
}
func SSSS(){
    let dd =
"""
"chuangJianCheYuan"
"chaKanCheYuan"
"heDangTongGuo"
"saoYiSao"
"cheLiangRuChang"
"dengDaiChuJian"
"dengDaiYuChuLi"
"dengDaiTuoHao"
"chaiJieFangShi"
"cunFangWeiZhi"
"daiHuiXingCheLiang"
"buPaiZhaoPian-shouXuBu"
"jianXiaoCheLiang"
"yiRuKu"
"weiChaiJie"
"chaiJieFangShi"
"buPaiZhaoPian-chaJieBu"
"heDangWeiTongGuo"
"heDangYiTongGuo"
"weiHeDang"
"""
    dd.uppercased()
}
