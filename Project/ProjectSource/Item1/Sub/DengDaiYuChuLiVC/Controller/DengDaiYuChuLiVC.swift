//
//  DengDaiYuChuLiVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DengDaiYuChuLiVC: DDNormalVC {
    var collection : UICollectionView!
    let searchBar = DDSearchBar()
    let addBtn = UIButton()
    lazy var categoryBar : UIView = UIView()
    var index: Int = 0
    var apiModel = ApiModel<CheYuanDataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "等待预处理"
        if let index = userInfo as? Int {
            self.index = index
        }
        layoutCategoryBar()
        layoutSearchBar()
        view.addSubview(addBtn)
        addBtn.backgroundColor = .blue
        addBtn.setTitle("扫描车辆二维码", for: UIControlState.normal)
        addBtn.frame = CGRect(x: 20, y: view.bounds.height - DDSliderHeight - 20 - 40, width: view.bounds.width - 40, height: 40)
        addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        layoutCollectionView()
        // Do any additional setup after loading the view.
        self.prepareRequest(index: index)
    }
    @objc func addBtnClick(sender:UIButton){
        
        mylog("扫描车辆二维码")
        let scanner = CarScannerVC()
        scanner.complateHandle = {[weak self] result in
            mylog(result)
        }
        self.present(scanner, animated: true) {}
        //        self.navigationController?.pushViewController(ZengJiaCheLiangeVC(), animated: true)
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
        DDQueryManager.share.heDangJiLu(type: ApiModel<CheYuanDataModel>.self, page: "1",   isVerify: "\(type)", searchInfo: nil) { (result ) in
            mylog(result.msg)
            let test : CheYuanModel = CheYuanModel()
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
        categoryBar.backgroundColor = .white
        categoryBar.frame = CGRect(x: 0, y: DDNavigationBarHeight + 1, width: view.bounds.width, height: 48)
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
        flowLayout.sectionInset = UIEdgeInsetsMake(10, toBorderMargin, 0, toBorderMargin)
        let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow - 1)) / CGFloat(itemCountOneRow)
        var itemH = itemW
        if itemCountOneRow == 1 {
            itemH = 72
        }else if itemCountOneRow == 2 {
            itemH = itemW
        }
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        //        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        //        flowLayout.minimumInteritemSpacing = 3
        //        flowLayout.minimumLineSpacing = 3
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        //        flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 40)
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  categoryBar.frame.maxY , width: self.view.bounds.width, height: addBtn.frame.minY  - categoryBar.frame.maxY  - 10), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.backgroundColor = UIColor.clear
        collection.register(CheYuanItem.self , forCellWithReuseIdentifier: "CheYuanItem")
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
        self.categoryBar.addSubview(searchBar)
        searchBar.frame = CGRect(x: 20, y: 5, width: self.view.bounds.width - 40, height: 38)
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




extension DengDaiYuChuLiVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 self.navigationController?.pushViewController(ChuJianStep2VC(), animated: true)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CheYuanItem", for: indexPath)
        if let itemUnwrap = item as? CheYuanItem{
            itemUnwrap.model = apiModel.data?.list?[indexPath.row]
        }
        //        item.backgroundColor = UIColor.randomColor()
        return item
    }
    
}
extension DengDaiYuChuLiVC{
    class CheYuanDataModel: Codable {
        var pageNum: Int?
        var pageSize:Int?
        var size : Int?
        var startRow : Int?
        var endRow:Int?
        var total:Int?
        var pages: Int?
        var list:[CheYuanModel]?
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
    
    
    
    class CheYuanModel : Codable {
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
    
    
    class CheYuanItem : UICollectionViewCell {
        var model : CheYuanModel?  {
            didSet{
                guard let model = model  else {
                    return
                }
                number.text = "编号:\(model.carCode ?? "")"
                arrivedTime.text = "入场时间: \(model.approachTime ?? "")"
                carNumber.text = "车牌:\(model.carNo ?? "")"
                carType.text = "车型:\(model.vin ?? "")"
            }
        }
        
        let number = UILabel(title: "编号:", font: UIFont.systemFont(ofSize: 15))
        let carNumber = UILabel(title: "车牌号:", font: UIFont.systemFont(ofSize: 15))
        let arrivedTime = UILabel(title: "入场时间:", font: UIFont.systemFont(ofSize: 15))
        let carType  = UILabel(title: "车型:", font: UIFont.systemFont(ofSize: 15))
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(number )
            self.contentView.addSubview(carNumber)
            self.contentView.addSubview(arrivedTime)
            self.contentView.addSubview(carType)
            self.backgroundColor = .white
            number.textColor = UIColor.gray
            carNumber.textColor = UIColor.gray
            arrivedTime.textColor = UIColor.gray
            carType.textColor = UIColor.gray
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let h : CGFloat =  (bounds.height - margin * 2 ) / 2
            let w : CGFloat =  (bounds.width - margin * 2 ) / 2
            number.frame = CGRect(x: margin, y: margin, width: w, height: h)
            carType.frame = CGRect(x: margin, y: number.frame.maxY, width: w, height: h)
            
            carNumber.frame = CGRect(x: number.frame.maxX, y: margin, width: w, height: h)
            arrivedTime.frame = CGRect(x: carNumber.frame.minX, y: carNumber.frame.maxY, width: w, height: h)
            self.layer.cornerRadius = 6
            self.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
