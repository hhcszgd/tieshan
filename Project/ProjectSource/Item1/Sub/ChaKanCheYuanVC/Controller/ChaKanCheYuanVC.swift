//
//  ChaKanCheYuanVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//
class CheYuanModel: Codable {
    var carLocation : String?
    var phone : String?
    var count : String?
    var bankName : String?
    var id : String?
    var contacts : String?
    var account : String?
}
class CheYuanDataModel: Codable {
    var list : [CheYuanModel]?
    var navigatepageNums : [Int]?
    var pageNum : Int?
    var  pageSize : Int?
    var  size : Int?
    var  startRow : Int?
    var  endRow : Int?
    var  total : Int?
    var  pages : Int?
    var  prePage : Int?
    var  nextPage : Int?
    var  isFirstPage : Bool?
    var  isLastPage : Bool?
    var  hasPreviousPage : Bool?
    var  hasNextPage : Bool?
    var  navigatePages : Int?
    var  navigateFirstPage : Int?
    var  navigateLastPage : Int?
    var  lastPage : Int?
    var  firstPage : Int?
}
import UIKit

class ChaKanCheYuanVC: DDNormalVC {
    
    let topBar = ViewTopBar(title: "车源数量")
    var collection : UICollectionView!
    var index: Int = 0
    var apiModel = ApiModel<CheYuanDataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车源列表"
        layoutSearchBar()
        layoutCollectionView()
        // Do any additional setup after loading the view.
        self.prepareRequest(index: index)
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
        DDQueryManager.share.cheYuanList(type: ApiModel<CheYuanDataModel>.self, page: "1", searchInfo: nil) { (result) in
            dump(result)
//            if result.data?.list?.count ?? 0 == 0 {result.data?.list = [test]}
            self.apiModel = result
            self.topBar.titleLabel.text = "车源数量\(result.data?.total ?? 0)"
            self.collection.reloadData()
        }
//        DDQueryManager.share.heDangJiLu(type: ApiModel<CheYuanDataModel>.self, page: "1",   isVerify: "\(type)", searchInfo: nil) { (result ) in
//            mylog(result.msg)
//            let test : CheYuanModel = CheYuanModel()
//            test.approachTime = "1999-09-09"
//            test.carNo = "京A 8888"
//            test.isVerify = 1
//            test.carCode = "ssssssseed"
//            test.vin = "laslsadlfserrsrr"
//            if result.data?.list?.count ?? 0 == 0 {result.data?.list = [test]}
//            self.apiModel = result
//            self.collection.reloadData()
//        }
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
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  topBar.frame.maxY , width: self.view.bounds.width, height: self.view.bounds.height - topBar.frame.maxY - DDTabBarHeight), collectionViewLayout: flowLayout)
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
        self.view.addSubview(topBar)
        self.topBar.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 15)
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




extension ChaKanCheYuanVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CarListOfCheYuan()
        vc.userInfo = self.apiModel.data?.list?[indexPath.item].id
        self.navigationController?.pushViewController(vc, animated: true)
        
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
extension ChaKanCheYuanVC{
//    class CheYuanDataModel: Codable {
//        var pageNum: Int?
//        var pageSize:Int?
//        var size : Int?
//        var startRow : Int?
//        var endRow:Int?
//        var total:Int?
//        var pages: Int?
//        var list:[CheYuanModel]?
//        var prePage:Int?
//        var nextPage:Int?
//        var isFirstPage:Bool?
//        var isLastPage : Bool?
//        var hasPreviousPage : Bool?
//        var hasNextPage: Bool?
//        var navigatePages: Int?
//        var navigatepageNums : [Int]?
//        var navigateFirstPage: Int?
//        var navigateLastPage: Int?
//        var firstPage : Int?
//        var lastPage : Int?
//    }
//
//
//
//    class CheYuanModel : Codable {
//        var carInfoId : Int? // 1176367626889334786,
//        var carCode:String? // "TSXXX19092225",
//        var approachTime : String?// null,
//        var carNo: String? // "晋A88884",
//        var vin: String? // "33333",
//        /// 1：未核档(暂存)，2：已核档，3：核档不通过
//        var isVerify: Int = 0// 2,
//        var carProcessingId: Int = 0 // 1176367626889336667,
//        var verificationResult:String? // null
//    }
    
    class CheYuanItem : UICollectionViewCell {
        var model : CheYuanModel?  {
            didSet{
                guard let model = model  else {
                    return
                }
                name.text = model.contacts
                address.text = "地址: \(model.carLocation ?? "")"
                mobile.text = "电话:\(model.phone ?? "")"
                bankname.text = "银行:\(model.bankName ?? "")"
//                address.text = "银行账号:\(model.carLocation ?? "")"
                bankCardNum.text = "银行账号:\(model.account ?? "")"
                carNum.text = "\(model.count ?? "")辆车"
                
            }
        }
        
        let name = UILabel(title: "name", font: UIFont.systemFont(ofSize: 15))
        let mobile = UILabel(title: "电话:", font: UIFont.systemFont(ofSize: 15))
        let address = UILabel(title: "地址:", font: UIFont.systemFont(ofSize: 15))
        let bankname  = UILabel(title: "银行:", font: UIFont.systemFont(ofSize: 15))
        let bankCardNum = UILabel(title: "银行账号:", font: UIFont.systemFont(ofSize:15))
        let carNum  = UILabel(title: "30辆车:",font: UIFont.systemFont(ofSize:15), color: mainColor, align: .right)
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(name )
            self.contentView.addSubview(mobile)
            self.contentView.addSubview(address)
            self.contentView.addSubview(bankname)
            self.contentView.addSubview(bankCardNum)
            self.contentView.addSubview(carNum)
            self.backgroundColor = .white
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let h : CGFloat =  (bounds.height - margin * 5 ) / 4
            let w : CGFloat =  (bounds.width - margin * 2 )
            let halfW : CGFloat =  (bounds.width - margin * 2 ) / 2
            name.frame = CGRect(x: margin, y: margin, width: halfW, height: h)
            mobile.frame = CGRect(x: name.frame.maxX, y: name.frame.minY, width: halfW, height: h)
            
            address.frame = CGRect(x: name.frame.minX, y: name.frame.maxY + margin, width: w, height: h)
            bankname.frame = CGRect(x: address.frame.minX, y: address.frame.maxY + margin, width: w, height: h)
            carNum.sizeToFit()
            carNum.frame = CGRect(origin: CGPoint(x: bounds.width - carNum.bounds.width - 10, y: bankname.frame.maxY + margin), size: carNum.size)
            bankCardNum.frame = CGRect(x: margin, y: bankname.frame.maxY + margin, width: carNum.frame.minX - margin, height: h)
            self.layer.cornerRadius = 6
            self.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

class ViewTopBar: UIView{
    let titleLabel = UILabel(font: UIFont.systemFont(ofSize: 12), color: .white, align: .center)
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(title: String = ""){
        self.init(frame: CGRect.zero)
        self.titleLabel.text = title
        self.addSubview(titleLabel)
        backgroundColor = .orange
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
