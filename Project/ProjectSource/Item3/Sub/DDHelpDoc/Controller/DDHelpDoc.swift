//
//  DDHelpDoc.swift
//  Project
//
//  Created by WY on 2019/9/20.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDHelpDoc: DDNormalVC {
    enum ShowType:String {
        case multipleSelection
        case cancle
        case done
    }
    let noMsgNoticeLabel = UILabel()
    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 1
    var currentKeyWord : String? = ""
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var multipleSelection : Bool = false
    var showType  = ShowType.multipleSelection
    var apiModel = ApiModel<[DDMessageModel]>(){
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        self.configTableView()
        
        self.view.addSubview(noMsgNoticeLabel)
        noMsgNoticeLabel.frame = CGRect(x: 0, y: self.view.bounds.height/2, width: self.view.bounds.width, height: 44)
        noMsgNoticeLabel.textColor = UIColor.DDSubTitleColor
        self.switchNoMsgStatus(show: false)
        noMsgNoticeLabel.textAlignment = .center
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestApi(loadType: LoadDataType.reload)
    }
    func switchNoMsgStatus(show:Bool)  {
        if show {
            self.noMsgNoticeLabel.isHidden = false
        }else{
            self.noMsgNoticeLabel.isHidden = true
        }
    }
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = self.view.backgroundColor
//        tableView.separatorColor = self.view.backgroundColor
//        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
//        tableView.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
//        tableView.gdLoadControl?.loadHeight = 40
//       requestApi(loadType: LoadDataType.initialize)
    }
    @objc func loadMore() {
        requestApi(loadType: LoadDataType.loadMore)
    }
    func testDataSource()  {
        self.apiModel = ApiModel<[DDMessageModel]>()
        let mm  = DDMessageModel()
        mm.title = "帮助文档1"
        mm.create_at = "2019 09 09"
        mm.message_type = "1"
        let mm2  = DDMessageModel()
        mm2.title = "帮助文档 2 "
        mm2.create_at = "2019 09 09"
        mm2.message_type = "2"
        
        self.apiModel.data = [mm , mm2]
        
        self.tableView.reloadData()
    }
    func requestApi(loadType : LoadDataType )  {
        testDataSource()
        return
        if loadType == .loadMore {
            pageNum += 1
        }else if loadType == .initialize{
            pageNum = 1
            noMsgNoticeLabel.text = "您还没有消息"
        }else{
            noMsgNoticeLabel.text = "找不到相关消息"
            pageNum = 1
        }
        DDRequestManager.share.messagePage(keyword:self.currentKeyWord,page:pageNum,true )?.responseJSON(completionHandler: { (response ) in
            mylog(response.result)
            switch response.result {
            case .failure :
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.failure)
                return
            default:
                break
            }
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<[DDMessageModel]>.self , from: response){
                if loadType == .loadMore {
                    if (apiModel.data?.count ?? 0) > 0{
                        self.apiModel.data?.append(contentsOf: apiModel.data!)
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                        self.switchNoMsgStatus(show: false)
                    }else{
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                    }
                }
//                else if loadType == .initialize{
//                    if (apiModel.data?.count ?? 0) > 0{
//                        self.switchNoMsgStatus(show: false)
//                    }else{
//                        self.switchNoMsgStatus(show: true)
//                    }
//                    self.apiModel = apiModel
//                }
                else{
                    self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
//                    self.tableView.gdLoadControl?.showStatus = .idle
                    if (apiModel.data?.count ?? 0) > 0{
                        self.switchNoMsgStatus(show: false)
                    }else{
                        self.switchNoMsgStatus(show: true)
                    }
                    self.apiModel = apiModel
                    
                }
                
                self.tableView.reloadData()
            }
        })
    }
    func configNaviBar() {
        self.title = "消息"
//        self.navigationController?.title = nil
    }
    
    
    @objc func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pageNum = 0
            
        }
    }
    
}

extension DDHelpDoc : UITableViewDelegate , UITableViewDataSource {
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 9
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let titles =  ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
//        let label = UILabel()
//        label.text = "  " +  titles[section]
//        label.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
//        return label
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.apiModel.data?[indexPath.row]{
//            if model.message_type == "1"{//公告
//                let vc = AnnouncementVC()
//                vc.showModel = model
//                self.navigationController?.pushViewController(vc , animated: true )
//            }else if model.message_type == "2"{//系统消息
//
//                let vc = DDSystemMsgVC()
//                vc.showModel = model
//                self.navigationController?.pushViewController(vc , animated: true )
//            }
            toWebView(messageID: model.id)
            
        }
        mylog("action by message type ")
        requestApi(loadType: LoadDataType.initialize)
    }
    
    @objc func toWebView(messageID:String) {
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: DomainType.wap.rawValue + "message/\(messageID)")
//        let model = DDActionModel.init()
//        model.keyParameter = DomainType.wap.rawValue + "message/\(messageID)"
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
//        self.searchBox.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.apiModel.data?[indexPath.row]
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
}
import SDWebImage
extension DDHelpDoc{
    class DDMessageCell : UITableViewCell {
        let bgView = UIView()
        let icon  = UIImageView(image: UIImage(named:"profile_icon_help_yiwen"))
        let title = UILabel()
        let arrow = UIImageView(image: UIImage(named: "profile_edit_icon-right"))
        let bottomLine = UIView()
//        let subTitle = UILabel()
//        let time = UILabel()
//        let messageStatus = UIView()
        var model : DDMessageModel? {
            didSet{
                title.text = model?.title
//                title.text = model?.id
//                if let messageType = model?.message_type , messageType == "1"{
////                    icon.image = UIImage(named:"list_icon_tongzhi")
//                    title.text = "公告"
//                }else{
////                    icon.image = UIImage(named:"list_icon_daiyuexiaoxi")
//                    title.text = "系统消息"
//                }
            }
        }

        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.backgroundColor = UIColor.clear
            self.contentView.addSubview(bgView)
            
            bgView.backgroundColor = UIColor.clear
            bgView.addSubview(icon)
            bgView.addSubview(title)
            title.textColor = UIColor.DDTitleColor
            title.font = GDFont.systemFont(ofSize: 15)
            bgView.addSubview(arrow)
            bgView.addSubview(bottomLine)
            bottomLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            //        icon.image = UIImage(named: "groupchatbackground")
//            icon.image = QRCodeScannerVC.creatQRCode(string: "this qrCode is created by wyf", imageToInsert: UIImage(named: "groupchatbackground"))
            title.text = "姓名"
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            bgView.frame = self.bounds // CGRect(x: 15, y: 5, width: self.bounds.width - 15 * 2, height: (self.bounds.height - 5 * 2))
            bgView.layer.cornerRadius = 6
            bgView.layer.masksToBounds = true
            let margin : CGFloat = 10
            icon.frame.scaleWidthTo(18)
            icon.frame = CGRect(x: margin , y: (bounds.height - icon.frame.height)/2 , width:icon.frame.width , height:icon.frame.height)
            arrow.frame.scaleWidthTo(8)
            arrow.frame = CGRect(x: bounds.width - arrow.frame.width - margin , y: (bounds.height - arrow.frame.height)/2 , width:arrow.frame.width, height:arrow.frame.height )
            
            title.ddSizeToFit()
            title.frame = CGRect(x: icon.frame.maxX + margin, y: 0 , width: self.frame.width - margin - icon.frame.maxX - margin , height: bounds.height)
            bottomLine.frame = CGRect(x:15, y:bounds.height - 1, width: bounds.width - 30, height: 1)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

}
