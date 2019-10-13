//
//  ChaiJieFangShi-ShouXuBuVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
///拆解方式(手续部)
class ChaiJieFangShiShouXuBuVC: DDNormalVC {
    var collection : UICollectionView!
    let searchBar = DDSearchBar()
    let addBtn = UIButton()
    lazy var categoryBar : UIView = UIView()
    var index: Int = 0
    var apiModel = ApiModel<CheYuanDataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车辆拆解"
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
        let scanner = CarScannerVC()
        scanner.complateHandle = {[weak self] result in
            mylog(result)
        }
        self.present(scanner, animated: true) {}
        mylog("扫描车辆二维码")
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
    func requestServer(type:Int)  {
        DDQueryManager.share.chaiJieLiebiao(type: ApiModel<CheYuanDataModel>.self, page: "1", findMsg: nil) { (result ) in
            mylog(result.msg)
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




extension ChaiJieFangShiShouXuBuVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChaiJieFangShiStep2()
        vc.carInfoId = self.apiModel.data?.list?[indexPath.item].car_info_id ?? ""
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
extension ChaiJieFangShiShouXuBuVC{
    class CheYuanDataModel: Codable {
        var pageNum: String?
        var pageSize:String?
        var size : String?
        var startRow : String?
        var endRow:String?
        var total:String?
        var pages: String?
        var list:[CheYuanModel]?
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
    
    
    
    class CheYuanModel : Codable {
        /*
         [{\"car_name\":\"科鲁兹滋滋滋滋\",\"car_info_id\":\"1183047045422911488\",\"approach_time\":\"2019-10-12 23:52:13\",\"car_no\":\"苏a2396v\",\"car_code\":\"TSXXX191000061\"},
         
         */
        var car_name : String? // 1176367626889334786,
        var car_info_id:String? // "TSXXX19092225",
        var approach_time : String?// null,
        var car_no: String? // "晋A88884",
        var car_code: String? // "33333",

    }
    
    
    class CheYuanItem : UICollectionViewCell {
        var model : CheYuanModel?  {
            didSet{
                guard let model = model  else {
                    return
                }
                number.text = "编号:\(model.car_code ?? "")"
                arrivedTime.text = "入场时间: \(model.approach_time ?? "")"
                carNumber.text = "车牌:\(model.car_no ?? "")"
                carType.text = "车型:\(model.car_name ?? "")"
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
