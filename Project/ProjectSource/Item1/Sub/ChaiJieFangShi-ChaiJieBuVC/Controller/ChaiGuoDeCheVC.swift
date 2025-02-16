//
//  ChaiJieFangShi-ChaiJieBuVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
/// 拆解方式(拆解部)
class ChaiGuoDeCheVC: DDNormalVC {
    var collection : UICollectionView!
    let searchBar = DDSearchBar()
    ///待拆核已拆model
    var apiModel = ApiModel<DataModel>()
    var jianApiModel = ApiModel<JianDataModel>()
    lazy var categoryBar : CategoryBarView = {
        let bar = CategoryBarView(defaultIndex:index)
        bar.selectHandler = { [weak self] index in
            mylog(index)
            self?.index = index
            self?.prepareRequest(index:index)
        }
        return bar
    }()
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "监销车辆"
        if let index = userInfo as? Int {
            self.index = index
        }
        layoutSearchBar()
        layoutCategoryBar()
        addCollectionView()
        // Do any additional setup after loading the view.
        self.prepareRequest(index: index)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareRequest(index:Int) {
        switch index {
        case  0 :
            self.requestServer(type:1)
        case 1 :
            self.requestServer(type:2)
        default:
            requestChaiGuoDeJian()
        }
    }
    func requestChaiGuoDeJian() {
        DDQueryManager.share.chaiGuoDeJian(type: ApiModel<JianDataModel>.self, page: "\(pageIndex)", findMsg: searchBar.textField.text) { (apiModel) in
            self.jianApiModel = apiModel
            self.layoutCollectionView(index: self.index)
            mylog(apiModel.msg)
        }
    }

    func requestServer(type:Int)  {
        DDQueryManager.share.daiChaiYiChai(type: ApiModel<DataModel>.self, page: "1",   isDismantle: "\(type)", searchInfo: nil) { (result ) in
            mylog(result.msg)
            self.apiModel = result
            self.layoutCollectionView(index: self.index)
        }
    }
    func layoutCategoryBar(){
        self.view.addSubview(categoryBar)
        categoryBar.frame = CGRect(x: 0, y: DDNavigationBarHeight + 1, width: view.bounds.width, height: 64)
        let models = [
            ("待拆车辆" , "100" ),
            ("拆过的车" , "100" ),
            ("入库的件" , "100" ),
        ]
        categoryBar.models = models
    }
    func addCollectionView() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  categoryBar.frame.maxY , width: self.view.bounds.width, height: self.view.bounds.height - categoryBar.frame.maxY - DDTabBarHeight), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.backgroundColor = UIColor.clear
        collection.register(DaiChaiItem.self , forCellWithReuseIdentifier: "DaiChaiItem")
        collection.register(ChaiGuoItem.self , forCellWithReuseIdentifier: "ChaiGuoItem")
        collection.register(RuKuItem.self , forCellWithReuseIdentifier: "RuKuItem")
        collection.register(HomeSectionFooter.self , forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter")
        collection.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader")
        
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        collection.alwaysBounceVertical = true
        collection.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        layoutCollectionView()
    }
    func layoutCollectionView(index:Int = 0) {
        if index == 0 {
            let toBorderMargin :CGFloat  = 13
            var itemMargin  : CGFloat = 10
            let itemCountOneRow = 2
            if itemCountOneRow == 1 {
                itemMargin = 10
            }else if itemCountOneRow == 2 {
                itemMargin = 13
            }
            guard let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout else{return}
            flowLayout.minimumLineSpacing = itemMargin
            flowLayout.minimumInteritemSpacing = itemMargin
            flowLayout.sectionInset = UIEdgeInsetsMake(13, toBorderMargin, 0, toBorderMargin)
            let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow - 1)) / CGFloat(itemCountOneRow)
            var itemH = itemW
            if itemCountOneRow == 1 {
                itemH = 68
            }else if itemCountOneRow == 2 {
                itemH = itemW
            }
            flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        }else {
            
            let toBorderMargin :CGFloat  = 13
            var itemMargin  : CGFloat = 10
            let itemCountOneRow = 1
            if itemCountOneRow == 1 {
                itemMargin = 10
            }else if itemCountOneRow == 2 {
                itemMargin = 13
            }
            guard let flowLayout = self.collection.collectionViewLayout as? UICollectionViewFlowLayout else {return}
            flowLayout.minimumLineSpacing = itemMargin
            flowLayout.minimumInteritemSpacing = itemMargin
            flowLayout.sectionInset = UIEdgeInsetsMake(13, toBorderMargin, 0, toBorderMargin)
            let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow - 1)) / CGFloat(itemCountOneRow)
            var itemH = itemW
            if itemCountOneRow == 1 {
                itemH = 88
            }else if itemCountOneRow == 2 {
                itemH = itemW
            }
            flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        }
        collection.reloadData()
    }
    func layoutSearchBar()  {
        //        self.view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
        searchBar.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width - 88, height: 32)
        searchBar.layer.cornerRadius = searchBar.bounds.height/2
        searchBar.layer.masksToBounds = true
        searchBar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        searchBar.doneAction = { [weak self ] text in
            mylog(text )
        }
    }
    
}


extension ChaiGuoDeCheVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if index == 0 {
           var actions = [DDAlertAction]()
            let sure = DDAlertAction(title: "确定",textColor:mainColor, style: UIAlertActionStyle.default, handler: { (action ) in
                print("拆拆拆")
                let id = self.apiModel.data?.list?[indexPath.item].id ?? "0"
                DDQueryManager.share.queDingChaiJie(type: ApiModel<String>.self, carInfoId: id) { (result) in
                    if result.ret_code == "0"{
                        
                        let vc = ChaiCheRuKuVC()
                        vc.baseInfoModel = self.apiModel.data?.list?[indexPath.item] ?? ChaiGuoDeCheVC.ItemModel()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{GDAlertView.alert(result.msg)}
                }
                
            })
            
            let cancel = DDAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action ) in
                let vc = ChaiCheRuKuVC()
                vc.baseInfoModel = self.apiModel.data?.list?[indexPath.item] ?? ChaiGuoDeCheVC.ItemModel()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            actions.append(cancel)
            actions.append(sure)
            
            let alertView = DDAlertOrSheet(title: "确定拆解车辆?", message: nil,messageColor:mainColor , preferredStyle: UIAlertControllerStyle.alert, actions: actions)
            alertView.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert(alertView)
        }else {
            mylog("nothing to do")
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if index == 0 {
            return apiModel.data?.list?.count ?? 0
        }else if index == 1 {
            return apiModel.data?.list?.count ?? 0
        }else if index == 2  {
            return jianApiModel.data?.list?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if index == 0{
            
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "DaiChaiItem", for: indexPath)
            if let itemUnwrap = item as? DaiChaiItem{
                itemUnwrap.model = apiModel.data?.list?[indexPath.item]
            }
            return item
        }else if index == 1{
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ChaiGuoItem", for: indexPath)
            if let itemUnwrap = item as? ChaiGuoItem{
                itemUnwrap.model = apiModel.data?.list?[indexPath.item]
            }
            return item
        }else if index == 2{
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "RuKuItem", for: indexPath)
            if let itemUnwrap = item as? RuKuItem{
                itemUnwrap.model = jianApiModel.data?.list?[indexPath.item]
            }
            return item
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "DaiChaiItem", for: indexPath)
    }
    
}
extension ChaiGuoDeCheVC{
    class DataModel: Codable {
        var pageNum: String?
        var pageSize:String?
        var size : String?
        var startRow : String?
        var endRow:String?
        var total:String?
        var pages: String?
        var list:[ItemModel]?
        var prePage:String?
        var nextPage:String?
        var isFirstPage:Bool?
        var isLastPage : Bool?
        var hasPreviousPage : Bool?
        var hasNextPage: Bool?
        var navigatePages: String?
        var navigatepageNums : [String]?
        var navigateFirstPage: String?
        var navigateLastPage: String?
        var firstPage : String?
        var lastPage : String?
    }
    class JianDataModel: Codable {
        var pageNum: String?
        var pageSize:String?
        var size : String?
        var startRow : String?
        var endRow:String?
        var total:String?
        var pages: String?
        var list:[JianItemModel]?
        var prePage:String?
        var nextPage:String?
        var isFirstPage:Bool?
        var isLastPage : Bool?
        var hasPreviousPage : Bool?
        var hasNextPage: Bool?
        var navigatePages: String?
        var navigatepageNums : [String]?
        var navigateFirstPage: String?
        var navigateLastPage: String?
        var firstPage : String?
        var lastPage : String?
    }
    class JianItemModel: Codable {
        var printOperator : String?
        var carNo : String?
        var vin : String?
        var id : String?
        var printTime : String?
        var partsName : String?
    }
    
    class ItemModel : Codable {
        /**
         {\"carCode\":\"TSXXX191000022\",\"carNo\":\"京N00000\",\"vin\":\"22222\",\"time\":\"2019-10-13 19:51:32\",\"id\":\"1182221034242314240\"}
         
         */
        var carCode:String? // "TSXXX19092225",
        var vin: String? // "33333",
        var carNo: String? // "晋A88884",
        var time : String?// null,
        var id:String? // null
        var carName: String?
        ///拆解方式
        var dismantleWay : String?
    }
    
    class DaiChaiItem : UICollectionViewCell {
        var model : ItemModel?  {
            didSet{
                guard let model = model  else {
                    return
                }
                number.text = "编号:\(model.carCode ?? "")"
                chaiJieTime.text = "报废时间: \(model.time ?? "")"
                carNumber.text = "车牌:\(model.carNo ?? "")"
                vin.text = "VIN:\(model.vin ?? "")"
                
            }
        }
        
        let number = UILabel(title: "编号:", font: UIFont.systemFont(ofSize: 15))
        let carNumber = UILabel(title: "车牌号:", font: UIFont.systemFont(ofSize: 15))
        let vin  =  UILabel(title: "VIN:", font: UIFont.systemFont(ofSize: 15))
        let chaiJieTime =  UILabel(title: "报废时间:", font: UIFont.systemFont(ofSize: 15))
        let chaiBtn = UIButton()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(number )
            self.contentView.addSubview(carNumber)
            self.contentView.addSubview(vin)
            self.contentView.addSubview(chaiJieTime)
            self.contentView.addSubview(chaiBtn)
            self.backgroundColor = .white
            number.textColor = UIColor.gray
            carNumber.textColor = UIColor.gray
            chaiJieTime.textColor = UIColor.gray
            vin.textColor = UIColor.gray
            chaiBtn.backgroundColor = mainColor
            chaiBtn.setTitle("拆解车辆", for: UIControlState.normal)
            chaiBtn.layer.cornerRadius = 4
            chaiBtn.layer.masksToBounds = true
            chaiBtn.isUserInteractionEnabled = false
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let bottomH : CGFloat = 50
            let btnH : CGFloat = 30
            
            let h : CGFloat =  (bounds.height -  bottomH) / 4
            let w : CGFloat =  (bounds.width - margin * 2 ) / 1
            number.frame = CGRect(x: margin, y: 0, width: w, height: h)
            carNumber.frame = CGRect(x: margin, y: number.frame.maxY, width: w, height: h)
            
            vin.frame = CGRect(x: margin, y: carNumber.frame.maxY, width: w, height: h)
            chaiJieTime.frame = CGRect(x: vin.frame.minX, y: vin.frame.maxY, width: w, height: h)
            chaiBtn.frame = CGRect(x: (bounds.width - 100)/2, y: bounds.height - bottomH + 10, width: 100, height: btnH)
            self.layer.cornerRadius = 6
            self.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class ChaiGuoItem : UICollectionViewCell {
        var model : ItemModel?  {
            didSet{
                guard let model = model  else {
                    return
                }
                number.text = "编号:\(model.carCode ?? "")"
                chaiJieTime.text = "拆解时间: \(model.time ?? "")"
                carNumber.text = "车牌:\(model.carNo ?? "")"
                vin.text = "VIN:\(model.vin ?? "")"
                
            }
        }
        
        let number = UILabel(title: "编号:", font: UIFont.systemFont(ofSize: 15))
        let carNumber = UILabel(title: "车牌号:", font: UIFont.systemFont(ofSize: 15))
        let chaiJieTime =  UILabel(title: "拆解时间:", font: UIFont.systemFont(ofSize: 15))
        let vin  =  UILabel(title: "VIN:", font: UIFont.systemFont(ofSize: 15))
        let status =  UILabel(title: "已拆  入库333件",font: UIFont.systemFont(ofSize: 13), color: mainColor)
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(number )
            self.contentView.addSubview(carNumber)
            self.contentView.addSubview(chaiJieTime)
            self.contentView.addSubview(vin)
            self.contentView.addSubview(status)
            self.backgroundColor = .white
            number.textColor = UIColor.gray
            carNumber.textColor = UIColor.gray
            chaiJieTime.textColor = UIColor.gray
            vin.textColor = UIColor.gray
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let h : CGFloat =  (bounds.height - margin * 2 ) / 3
            let w : CGFloat =  (bounds.width - margin * 2 ) / 2
            number.frame = CGRect(x: margin, y: margin, width: w, height: h)
            carNumber.frame = CGRect(x: margin, y: number.frame.maxY, width: w, height: h)
            
            chaiJieTime.frame = CGRect(x: number.frame.maxX, y: margin, width: w, height: h)
            vin.frame = CGRect(x: chaiJieTime.frame.minX, y: chaiJieTime.frame.maxY, width: w, height: h)
            status.frame = CGRect(x: margin, y: vin.frame.maxY, width: w * 2, height: h)
            self.layer.cornerRadius = 6
            self.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class RuKuItem : UICollectionViewCell {
        var model : JianItemModel?  {
            didSet{
                guard let model = model  else {
                    return
                }
                number.text = "编号:\(model.vin ?? "")"
                chaiJieTime.text = "入库时间: \(model.printTime ?? "")"
                carNumber.text = "车牌:\(model.carNo ?? "")"
                vin.text = "VIN:\(model.vin ?? "")"
                locat.text = model.partsName
                rukuRen.text = "入库人: \(model.printOperator ?? "")"
                
            }
        }
        
        let number = UILabel(title: "编号:", font: UIFont.systemFont(ofSize: 15))
        let locat = UILabel(title: "前保险杠-保险杠总成", font: UIFont.systemFont(ofSize: 15))
        let carNumber = UILabel(title: "车牌号:", font: UIFont.systemFont(ofSize: 15))
        let vin  =  UILabel(title: "VIN:", font: UIFont.systemFont(ofSize: 15))
        let rukuRen  =  UILabel(title: "入库人:", font: UIFont.systemFont(ofSize: 15))
        let chaiJieTime =  UILabel(title: "入库时间:", font: UIFont.systemFont(ofSize: 15))
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(number )
            self.contentView.addSubview(locat)
            self.contentView.addSubview(carNumber)
            self.contentView.addSubview(chaiJieTime)
            self.contentView.addSubview(vin)
            self.contentView.addSubview(rukuRen)
            self.backgroundColor = .white
            number.textColor = UIColor.gray
            carNumber.textColor = UIColor.gray
            chaiJieTime.textColor = UIColor.gray
            vin.textColor = UIColor.gray
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let h : CGFloat =  (bounds.height - margin * 2 ) / 3
            let w : CGFloat =  (bounds.width - margin * 2 ) / 2
            number.frame = CGRect(x: margin, y: margin, width: w, height: h)
            carNumber.frame = CGRect(x: margin, y: number.frame.maxY, width: w, height: h)
            rukuRen.frame = CGRect(x: margin, y: carNumber.frame.maxY, width: w, height: h)
            
            locat.frame = CGRect(x: number.frame.maxX, y: margin, width: w, height: h)
            vin.frame = CGRect(x: locat.frame.minX, y: locat.frame.maxY, width: w, height: h)
            chaiJieTime.frame = CGRect(x: vin.frame.minX, y: vin.frame.maxY, width: w, height: h)
            
            self.layer.cornerRadius = 6
            self.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
