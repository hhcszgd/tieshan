//
//  CarListOfCheYuan.swift
//  Project
//
//  Created by JohnConnor on 2019/10/4.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit
///state： 1-待入场状态 2-待核档状态 3-待商委注销状态 4-待领取残值状态 5-待报废状态 6-报废成功 7-核档未通过 查全部的状态不用传状态码，就是查全部状态的
class CarListOfCheYuan: DDNormalVC {
    let topBar = ViewTopBar(title: "车源数量")
    let titleCategory =  ChooseCheyuanCateGory(frame: CGRect(x: 0, y: 0, width: 220, height: 40))
    var categoryIndex = 0
    lazy var choostAlert: ChoostCarTypeAlert = {
        let alert = ChoostCarTypeAlert(datas: [
            ChoostCarTypeAlert.ChoostCarTypeModel(title: "全部", true),
            ChoostCarTypeAlert.ChoostCarTypeModel(title: "未入场", false),
            ChoostCarTypeAlert.ChoostCarTypeModel(title: "待核档", false),
            ChoostCarTypeAlert.ChoostCarTypeModel(title: "待商委注销", false),
            ChoostCarTypeAlert.ChoostCarTypeModel(title: "待领取残值", false),
            ChoostCarTypeAlert.ChoostCarTypeModel(title: "待报废", false),
            ChoostCarTypeAlert.ChoostCarTypeModel(title: "报废成功", false),
            ChoostCarTypeAlert.ChoostCarTypeModel(title: "核档不通过", false)
            
        ])
        alert.didSelected = {[weak self] index in
            mylog(index )
            self?.categoryIndex = index
            self?.titleCategory.title = self?.choostAlert.datas[index].title ?? ""
            if let s = self{
                s.titleCategory.btnClick(sender: s.titleCategory)
                
            }
            self?.requestServer(type:self?.categoryIndex ?? 0)
        }
        return alert
    }()
    var collection : UICollectionView!
    let searchBar = DDSearchBar()
    let addBtn = UIButton()
    lazy var categoryBar : UIView = UIView()
//    var index: Int = 0
    var apiModel = ApiModel<CheYuanDataModel>()
    var cheYuanID : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车源列表"
        if let id = self.userInfo as? String{self.cheYuanID = id}
        self.navigationItem.titleView = titleCategory
        layoutCategoryBar()
        layoutSearchBar()
        titleCategory.clickHandler = { [weak self] isSelected in
            mylog(isSelected)
            if isSelected{
                if let s = self{
                    s.view.alert(s.choostAlert)
                }
                
            }else{
                self?.choostAlert.remove()
            }
        }
        view.addSubview(addBtn)
        addBtn.backgroundColor = .blue
        addBtn.setTitle("增加车源", for: UIControlState.normal)
        addBtn.frame = CGRect(x: 20, y: view.bounds.height - DDSliderHeight - 20 - 40, width: view.bounds.width - 40, height: 40)
        addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        layoutCollectionView()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestServer(type:self.categoryIndex)
    }
    @objc func addBtnClick(sender:UIButton){
        let vc = ZengJiaCheLiangeVC()
        vc.userInfo = self.cheYuanID
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    func prepareRequest(index:Int) {
//        switch index {
//        case  0 :
//            self.requestServer(type:1)
//        case 1 :
//            self.requestServer(type:3)
//        default:
//            self.requestServer(type:2)
//        }
//
//        self.requestServer(type:index)
//    }
    /// 1：未核档(暂存)，2：已核档，3：核档不通过
    func requestServer(type:Int)  {
        let state = self.categoryIndex == 0 ? nil : "\(self.categoryIndex)"
        DDQueryManager.share.carListOfCheYuan(type: ApiModel<CheYuanDataModel>.self, id: self.cheYuanID, page: "1",state: state, findMsg: nil) { (apiModel) in
            self.apiModel = apiModel
            self.collection.reloadData()
            mylog(apiModel.msg)
        }
    }
    func layoutCategoryBar(){
        self.view.addSubview(categoryBar)
        categoryBar.backgroundColor = .white
        categoryBar.frame = CGRect(x: 0, y: DDNavigationBarHeight + 1, width: view.bounds.width, height: 48)
        self.view.addSubview(topBar)
        topBar.frame = CGRect(x: 0, y: categoryBar.frame.maxY, width: view.bounds.width, height: 16)
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
        flowLayout.sectionInset = UIEdgeInsetsMake(0, toBorderMargin, 0, toBorderMargin)
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
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  topBar.frame.maxY , width: self.view.bounds.width, height: addBtn.frame.minY  - topBar.frame.maxY  - 10), collectionViewLayout: flowLayout)
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




extension CarListOfCheYuan : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if categoryIndex == 0 {
//            UIApplication.shared.keyWindow?.alert(Bundle.main.loadNibNamed("LookForResultAlert", owner: "LookForResultAlert" , options: nil )?.first as! LookForResultAlert)
//        }else {
//            self.navigationController?.pushViewController(DDDealDetailVC(), animated: true)
//        }
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
extension CarListOfCheYuan{
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
        var status : String?
        var carCode:String? // "TSXXX19092225",
        var carNo: String? // "晋A88884",
        var vin: String? // "33333",
        var approachTime : String?// null,
        var carInfoId : String? // 1176367626889334786,
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
                vin.text = "VIN:\(model.vin ?? "")"
                reason.setTitle(model.status, for: UIControlState.normal)

            }
        }
        
        let number = UILabel(title: "编号:", font: UIFont.systemFont(ofSize: 15))
        let carNumber = UILabel(title: "车牌号:", font: UIFont.systemFont(ofSize: 15))
        let arrivedTime = UILabel(title: "入场时间:", font: UIFont.systemFont(ofSize: 15))
        let vin  = UILabel(title: "VIN:", font: UIFont.systemFont(ofSize: 15))
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

class ChooseCheyuanCateGory: UIControl {
    var clickHandler : ((Bool) -> ())?
    var title = ""{
        didSet{
            self.titleLabel.text = title
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    private let titleLabel = UILabel(title: "xxxc的车", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray, align: .center)
    private let arrow = UIImageView(image: UIImage(named:"icon_xuanze_sel_SB"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(arrow)
        arrow.contentMode = .scaleAspectFit
        self.addTarget(self, action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        //        let normalImg = UIImage(named: "icon_xuanze_sel")
        //        let selImg = UIImage(named: "icon_xuanze_nor")
        
    }
    @objc func btnClick(sender:UIControl){
        sender.isSelected = !sender.isSelected
        self.transform()
        clickHandler?(sender.isSelected)
    }
    func transform() {
        UIView.animate(withDuration: 0.1) {
            self.arrow.transform = self.isSelected ? CGAffineTransform(rotationAngle: CGFloat.pi) : .identity
            //            if self.isSelected{
            //                self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            //            }else{
            //                self.arrow.transform = .identity
            //            }
        }
    }
    override func layoutSubviews() {
        titleLabel.sizeToFit()
        titleLabel.center = self.center
        arrow.bounds = CGRect(x: 0, y: 0, width: 14, height: 30)
        arrow.center = CGPoint(x: titleLabel.frame.maxX + 14, y: titleLabel.center.y)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class ChoostCarTypeAlert: DDAlertContainer {
    var datas : [ChoostCarTypeModel] = []
    var didSelected : ((Int) -> ())?
    
    let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    convenience init(datas:[ChoostCarTypeModel]){
        self.init()
        self.datas = datas
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.tableView.reloadData()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = self.bounds
    }
    override func remove() {
        self.removeFromSuperview()
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

/// user-interface setup
extension ChoostCarTypeAlert : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for (index ,model) in self.datas.enumerated(){
            model.isSelected = index == indexPath.row ? true : false
        }
        tableView.reloadData()
        didSelected?(indexPath.row)
        self.remove()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryCell(style: UITableViewCellStyle.default, reuseIdentifier: "CategoryCell")
        cell.model = datas[indexPath.row]
        return cell
    }
    class CategoryCell: UITableViewCell {
        var model: ChoostCarTypeModel = ChoostCarTypeModel(){
            didSet{
                textLabel?.textColor = model.isSelected ? mainColor : UIColor.black
                textLabel?.text = model.title
            }
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.textLabel?.textAlignment = .center
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class ChoostCarTypeModel{
        var title = ""
        var isSelected = false
        var id = ""
        convenience init(title:String,_ isSelected:Bool = false ,_ id:String = ""){
            self.init()
            self.title = title
            self.isSelected = isSelected
            self.id = id
        }
    }
    func _addSubviews() {
        
        _layoutSubviews()
    }
    
    func _layoutSubviews() {
        
    }
}
