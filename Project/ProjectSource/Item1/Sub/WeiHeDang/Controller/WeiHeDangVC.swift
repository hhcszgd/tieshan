//
//  WeiHeDangVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class WeiHeDangVC: DDNormalVC {
    var collection : UICollectionView!
    let searchBar = DDSearchBar()
    lazy var categoryBar : CategoryBarView = {
            let bar = CategoryBarView(defaultIndex:0)
        bar.selectHandler = { [weak self] index in
            mylog(index)
            self?.requestServer(type:index)
        }
        return bar
    }()
    
    var apiModel = ApiModel<HeDangDataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSearchBar()
        layoutCategoryBar()
        layoutCollectionView()
        // Do any additional setup after loading the view.
        requestServer(type:1)
    }
    /// 1：未核档(暂存)，2：已核档，3：核档不通过
    func requestServer(type:Int)  {
        DDQueryManager.share.heDangJiLu(type: ApiModel<HeDangDataModel>.self, page: "1",   isVerify: "\(type)", searchInfo: nil) { (result ) in
            mylog(result.msg)
            let test : HeDangModel = HeDangModel()
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
            ("待核档" , "100" ),
            ("核档未通过" , "100" ),
            ("核档完成" , "100" )
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
            itemH = 112
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
        collection.register(HeDangItem.self , forCellWithReuseIdentifier: "HeDangItem")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




extension WeiHeDangVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HeDangItem", for: indexPath)
        if let itemUnwrap = item as? HeDangItem{
            itemUnwrap.model = apiModel.data?.list?[indexPath.row]
        }
        //        item.backgroundColor = UIColor.randomColor()
        return item
    }
    
}
extension WeiHeDangVC{
    class HeDangDataModel: Codable {
    var pageNum: Int?
    var pageSize:Int?
    var size : Int?
    var startRow : Int?
    var endRow:Int?
    var total:Int?
    var pages: Int?
    var list:[HeDangModel]?
    var prePage:Int?
    var nextPage:Int?
    var isFirstPage:Bool?
    var isLastPage : Bool?
    var hasPreviousPage : Bool?
    var hasNextPage: Bool?
    var navigatePages: Int?
    var navigatepageNums : [Int]?
    var navigateFirstPage: Int?
    var navigateLastPage: Int?
    var firstPage : Int?
    var lastPage : Int?
    }
    
    
    
    class HeDangModel : Codable {
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
    
    class HeDangItem : UICollectionViewCell {
        var model : HeDangModel?  {
            didSet{
                guard let model = model  else {
                    return
                }
                number.text = "编号:\(model.carCode ?? "")"
                arrivedTime.text = "入场时间: \(model.approachTime ?? "")"
                carNumber.text = "车牌:\(model.carNo ?? "")"
                vin.text = "VIN:\(model.vin ?? "")"
                if model.isVerify == 1{
                    reason.setTitleColor(UIColor.orange.withAlphaComponent(0.8), for: UIControlState.normal)
                    reason.setTitle("待核档", for: UIControlState.normal)
                }else if model.isVerify == 2{
                    reason.setTitleColor(mainColor, for: UIControlState.normal)
                    reason.setTitle("已核档", for: UIControlState.normal)
                }else if model.isVerify == 3{
                    reason.setTitleColor(UIColor.red, for: UIControlState.normal)
                    reason.setTitle("核档未通过  查看原因 >>", for: UIControlState.normal)
                }
            }
        }
        
        let number = UILabel()
        let carNumber = UILabel()
        let arrivedTime = UILabel()
        let vin  = UILabel()
        let reason = UIButton()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(number )
            self.contentView.addSubview(carNumber)
            self.contentView.addSubview(arrivedTime)
            self.contentView.addSubview(vin)
            self.contentView.addSubview(reason)
            reason.contentHorizontalAlignment = .left
            reason.setTitle("审核未通过   查看原因", for: UIControlState.normal)
            self.backgroundColor = .white
            reason.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            number.textColor = UIColor.gray
            carNumber.textColor = UIColor.gray
            arrivedTime.textColor = UIColor.gray
            vin.textColor = UIColor.gray
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let h : CGFloat =  (bounds.height - margin * 2 ) / 3
            let w : CGFloat =  (bounds.width - margin * 2 ) / 2
            number.frame = CGRect(x: margin, y: margin, width: w, height: h)
            carNumber.frame = CGRect(x: margin, y: number.frame.maxY, width: w, height: h)
            reason.frame = CGRect(x: margin, y: carNumber.frame.maxY, width: w, height: h)
            
            arrivedTime.frame = CGRect(x: number.frame.maxX, y: margin, width: w, height: h)
            vin.frame = CGRect(x: arrivedTime.frame.minX, y: arrivedTime.frame.maxY, width: w, height: h)
            self.layer.cornerRadius = 6
            self.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
