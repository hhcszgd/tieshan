//
//  JianXiaoCheLiangVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class JianXiaoCheLiangVC: DDNormalVC {
    var collection : UICollectionView!
    let searchBar = DDSearchBar()
    var apiModel = ApiModel<DataModel>()
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
        layoutCollectionView()
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
                self.requestServer(type:3)
            default:
                self.requestServer(type:2)
            }
            
            self.requestServer(type:index)
        }
        /// 1：未核档(暂存)，2：已核档，3：核档不通过
        func requestServer(type:Int)  {
            DDQueryManager.share.heDangJiLu(type: ApiModel<DataModel>.self, page: "1",   isVerify: "\(type)", searchInfo: nil) { (result ) in
                mylog(result.msg)
                let test : ItemModel = ItemModel()
                test.approachTime = "1999-09-09"
                test.carNo = "京A 8888"
                test.isVerify = 1
                test.carCode = "ssssssseed"
                test.vin = "laslsadlfserrsrr"
                if result.data?.list?.count ?? 0 == 0 {result.data?.list = [test]}
                self.apiModel = result
                self.collection.reloadData()
            }
        }
        func layoutCategoryBar(){
            self.view.addSubview(categoryBar)
            categoryBar.frame = CGRect(x: 0, y: DDNavigationBarHeight + 1, width: view.bounds.width, height: 64)
            let models = [
                ("已监销" , "100" ),
                ("未监销" , "100" )
            ]
            categoryBar.models = models
        }
        func layoutCollectionView() {
            
            let toBorderMargin :CGFloat  = 13
            var itemMargin  : CGFloat = 10
            let itemCountOneRow = 1
            if itemCountOneRow == 1 {
                itemMargin = 10
            }else if itemCountOneRow == 2 {
                itemMargin = 13
            }
            let flowLayout = UICollectionViewFlowLayout.init()
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
            //        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
            //        flowLayout.minimumInteritemSpacing = 3
            //        flowLayout.minimumLineSpacing = 3
            flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
    //        flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 40)
            self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  categoryBar.frame.maxY , width: self.view.bounds.width, height: self.view.bounds.height - categoryBar.frame.maxY - DDTabBarHeight), collectionViewLayout: flowLayout)
            self.view.addSubview(collection)
            collection.backgroundColor = UIColor.clear
            collection.register(JianXiaoItem.self , forCellWithReuseIdentifier: "JianXiaoItem")
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


extension JianXiaoCheLiangVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if index == 0 {
            UIApplication.shared.keyWindow?.alert(Bundle.main.loadNibNamed("LookForResultAlert", owner: "LookForResultAlert" , options: nil )?.first as! LookForResultAlert)
        }else {
            self.navigationController?.pushViewController(DDDealDetailVC(), animated: true)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "JianXiaoItem", for: indexPath)
        if let itemUnwrap = item as? JianXiaoItem{
            itemUnwrap.model = apiModel.data?.list?[indexPath.row]
        }
        //        item.backgroundColor = UIColor.randomColor()
        return item
    }
    
}
extension JianXiaoCheLiangVC{
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
    
    
    
    class ItemModel : Codable {
        var carInfoId : Int? // 1176367626889334786,
       var carCode:String? // "TSXXX19092225",
        var approachTime : String?// null,
        var carNo: String? // "晋A88884",
        var vin: String? // "33333",
        /// 1：未核档(暂存)，2：已核档，3：核档不通过
        var isVerify: Int = 0// 2,
        var carProcessingId: Int = 0 // 1176367626889336667,
        var verificationResult:String? // null
    }
    
    class JianXiaoItem : UICollectionViewCell {
        var model : ItemModel?  {
            didSet{
                guard let model = model  else {
                    return
                }
                number.text = "编号:\(model.carCode ?? "")"
                chaiJieTime.text = "拆解时间: \(model.approachTime ?? "")"
                carNumber.text = "车牌:\(model.carNo ?? "")"
                vin.text = "VIN:\(model.vin ?? "")"
                
            }
        }
        
        let number = UILabel(title: "编号:", font: UIFont.systemFont(ofSize: 15))
        let carNumber = UILabel(title: "车牌号:", font: UIFont.systemFont(ofSize: 15))
        let chaiJieTime =  UILabel(title: "拆解时间:", font: UIFont.systemFont(ofSize: 15))
        let vin  =  UILabel(title: "VIN:", font: UIFont.systemFont(ofSize: 15))
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(number )
            self.contentView.addSubview(carNumber)
            self.contentView.addSubview(chaiJieTime)
            self.contentView.addSubview(vin)
            self.backgroundColor = .white
            number.textColor = UIColor.gray
            carNumber.textColor = UIColor.gray
            chaiJieTime.textColor = UIColor.gray
            vin.textColor = UIColor.gray
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let h : CGFloat =  (bounds.height - margin * 2 ) / 2
            let w : CGFloat =  (bounds.width - margin * 2 ) / 2
            number.frame = CGRect(x: margin, y: margin, width: w, height: h)
            carNumber.frame = CGRect(x: margin, y: number.frame.maxY, width: w, height: h)
            
            chaiJieTime.frame = CGRect(x: number.frame.maxX, y: margin, width: w, height: h)
            vin.frame = CGRect(x: chaiJieTime.frame.minX, y: chaiJieTime.frame.maxY, width: w, height: h)
            self.layer.cornerRadius = 6
            self.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
