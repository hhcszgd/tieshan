//
//  ChaiJieFangShiStep2.swift
//  Project
//
//  Created by JohnConnor on 2019/10/5.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ChaiJieFangShiStep2: DDNormalVC {
    
    let cuchai = UIButton()
    let dianchai = UIButton()
    let baochai = UIButton()
    let jingchai = UIButton()
    var carInfoId = ""
    lazy var collection: UICollectionView = {
        let c = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        return c
    }()
    var baseInfoModel = ApiModel<[BaseInfo]>(){didSet{
        
        flowLayout.headerReferenceSize = CGSize(width: collection.bounds.width, height: headerView.totalH)
        collection.reloadData()
        }}
    var imageInfoModel = ApiModel<[ImageInfo]>(){didSet{
        collection.reloadData()
    }}
    lazy var flowLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    lazy var headerView = HeaderView()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .white
        setupBottomBtn()
        setupCollection()
        setLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "拆解方式"
        requestBaseInfo()
        requestImageInfo()
        // Do any additional setup after loading the view.
    }
    func requestBaseInfo() {
        DDQueryManager.share.getCarInfoWhenChaiJie(type: ApiModel<[BaseInfo]>.self, carInfoId: carInfoId) { (apiModel) in
            self.baseInfoModel = apiModel
        }
    }
    func requestImageInfo() {
        DDQueryManager.share.getCarImageWhenChaiJie(type: ApiModel<[ImageInfo]>.self, carInfoId: carInfoId) { (apiModel) in
            self.imageInfoModel = apiModel
        }
    }
    
    func setupBottomBtn() {
        
        self.view.addSubview(cuchai)
        self.view.addSubview(dianchai)
        self.view.addSubview(baochai)
        self.view.addSubview(jingchai)
        baochai.frame = CGRect(x: 20, y: view.frame.height - 60, width: (view.bounds.width - 40 - 20)/2, height: 40)
        baochai.setTitleColor(mainColor, for: .normal)
        baochai.setTitle("包拆", for: UIControlState.normal)
        baochai.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        jingchai.frame = CGRect(x:baochai.frame.maxX + 20, y: baochai.frame.minY, width: baochai.frame.width, height: 40)
        jingchai.setTitle("精拆", for: UIControlState.normal)
        jingchai.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        dianchai.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        dianchai.setTitle("点拆", for: UIControlState.normal)
        cuchai.setTitle("粗拆", for: UIControlState.normal)
        cuchai.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        cuchai.frame = CGRect(x: 20, y: baochai.frame.minY - 54, width: (view.bounds.width - 40 - 20)/2, height: 40)
        dianchai.frame = CGRect(x:baochai.frame.maxX + 20, y: jingchai.frame.minY - 54, width: baochai.frame.width, height: 40)
        setCornerRadius(sender: jingchai)
        setCornerRadius(sender: baochai)
        setCornerRadius(sender: cuchai)
        setCornerRadius(sender: dianchai)
        
    }
    func setCornerRadius(sender:UIButton){
        sender.layer.cornerRadius = 8
        sender.layer.masksToBounds = true
        sender.layer.borderColor = mainColor.cgColor
        sender.layer.borderWidth = 1
        sender.setTitleColor(mainColor, for: UIControlState.normal)
    }
    func setupCollection() {
        
        let tableViewFrame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width , height: self.cuchai.frame.minY - DDNavigationBarHeight - 10)
        view.addSubview(collection)
        collection.frame = tableViewFrame
        collection.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        collection.register(HeaderView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    @objc func btnClick(sender: UIButton){
        mylog("btnClick")
        
        DDQueryManager.share.confirmChaiJieFangShi(type: ApiModel<String>.self, carInfoId: carInfoId, dismantleWay: "2") { (apiModel) in
            if apiModel.ret_code == "0"{
                GDAlertView.alert("确定拆解方式成功")
            }else{
                GDAlertView.alert(apiModel.msg)
            }
        }
        
    }
    func setLayout () {
        
//        let toBorderMargin :CGFloat  = 13
        let itemMargin  : CGFloat = 10
        let itemCountOneRow = 3
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        let itemW = (self.collection.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow - 1)) / CGFloat(itemCountOneRow)
        let itemH  = itemW + 30
        flowLayout.itemSize = CGSize(width: itemW - 1, height: itemH)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        collection.backgroundColor = UIColor.clear
        collection.register(InfoItem.self , forCellWithReuseIdentifier: "PrintTypeItem")
//        flowLayout.headerReferenceSize = CGSize(width: collection.bounds.width, height: headerView.totalH)
        collection.delegate = self
        collection.dataSource = self
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    lazy var types: [ItemModel] = {
        let url = "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1570261863&di=3933a340bbd7484226e88d074f3c5716&src=http://pic.cn2che.com/Editors/2011-10/14/U5337P33DT20111013075237.jpg"
        return [
            ItemModel(  "左前45度", url),
            ItemModel( "右前45度", url),
            ItemModel( "正前", url),
            ItemModel( "左后45度", url),
            ItemModel("右后45度", url),
            ItemModel("正后方", url)
        ]
    }()
}
extension ChaiJieFangShiStep2 : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            mylog("perform take photo")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfoModel.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrintTypeItem", for: indexPath)
        if let t = cell as? InfoItem{t.model = imageInfoModel.data?[indexPath.item] ?? ImageInfo()}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let h = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView{
            h.model = baseInfoModel.data?.first
            return h
        }
        
        if kind == UICollectionElementKindSectionHeader{
            return UICollectionReusableView()
        }
        return HeaderView()
    }
    class ItemModel {
        var title = ""
        var image : UIImage?
        var imageUrl : String?
        convenience init(_ title: String = "",_ imageUrl: String? = nil){
            self.init()
            self.title = title
            self.imageUrl = imageUrl
        }
    }
    class InfoItem: UICollectionViewCell {
        var model: ImageInfo = ImageInfo(){
            didSet{
                self.label.text = model.file_name
                
                if let i = model.file_url , i != "placeholder"{
                    self.imageView.setImageUrl(url: i)
                }else{
                    imageView.image = UIImage(named: "tianjiazhaopian")
                }
                layoutIfNeeded()
                setNeedsLayout()
            }
        }
        let label = UILabel(title: "", font: UIFont.systemFont(ofSize: 14), color: UIColor.darkGray, align: NSTextAlignment.center, adjustSize: true)
        let imageView = UIImageView( )
        override init(frame: CGRect) {
            super.init(frame:frame)
            backgroundColor = .white
            self.contentView.addSubview(label)
            self.contentView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            self.imageView.clipsToBounds = true
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            imageView.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.width))
            label.frame = CGRect(origin: CGPoint(x: 0, y: imageView.frame.maxY), size: CGSize(width: bounds.width, height: bounds.height - bounds.width))
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}


extension ChaiJieFangShiStep2{
    
    class HeaderView: UICollectionReusableView {
        var model : BaseInfo? = BaseInfo() {
            didSet{
                guard let model = model  else {
                    return
                }
                self.setValueToUI()
                
            }
        }
        lazy var headerTitle = DDDealDetailVC.SectionHeader()
        lazy var headerTitle2 = DDDealDetailVC.SectionHeader()
        lazy var bgView = UIView()
        lazy var blockView = UIView()
        lazy var number = UILabel(title:"编号: \(self.model?.car_no)",font: UIFont.systemFont(ofSize: 15), color: .white)
        lazy var carNumber = UILabel(title: "车牌号:", font: UIFont.systemFont(ofSize: 15), color: .white)
//        let arrivedTime = UILabel(title: "入场时间:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let carType  = UILabel(title: "车型:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let shengChanDate = UILabel(title: "生产日期:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let paiLiang = UILabel(title: "排量:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let cheJiaHao = UILabel(title: "车架号:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let faDongJiHao = UILabel(title: "发动机号:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let kongTiaoBeng = UILabel(title: "空调泵:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let xinJiu = UILabel(title: "新旧程度:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let maDa = UILabel(title: "马达:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let cheMen = UILabel(title: "车门:", font: UIFont.systemFont(ofSize: 15), color: .white)

       let lvQuanShuLiang = UILabel(title: "铝圈数量:", font: UIFont.systemFont(ofSize: 15), color: .white)
       let dianji = UILabel(title: "电机:", font: UIFont.systemFont(ofSize: 15), color: .white)
      let lvQuan = UILabel(title: "铝圈:", font: UIFont.systemFont(ofSize: 15), color: .white)
      let shuiXiang = UILabel(title: "水箱:", font: UIFont.systemFont(ofSize: 15), color: .white)
              
         let lunTai = UILabel(title: "轮胎:", font: UIFont.systemFont(ofSize: 15), color: .white)
         let zuoYi = UILabel(title: "座椅:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let kongTiao = UILabel(title: "空调:", font: UIFont.systemFont(ofSize: 15), color: .white)
        let sanYuan = UILabel(title: "三元催化器:", font: UIFont.systemFont(ofSize: 15), color: .white)
        
        let tips  = UILabel(title: "备注: 开始的;of爱好为了克服哈萨克多久恢复卡时", font: UIFont.systemFont(ofSize: 15), color: .white)
        lazy var leftLabels: [UILabel] = [
            number,carType,shengChanDate,cheJiaHao,kongTiaoBeng,maDa,lvQuanShuLiang,lvQuan,lunTai,kongTiao
        ]
        lazy var rightLabels: [UILabel] = [
            carNumber,paiLiang,faDongJiHao,xinJiu,cheMen,dianji,shuiXiang,zuoYi,sanYuan
            
        ]
        override init(frame:CGRect) {
            super.init(frame:frame)
            if bgView.superview == nil {setupSubviews()}
        }
        func setupSubviews() {
            self.addSubview(bgView)
            self.bgView.addSubview(blockView )
            self.bgView.addSubview(number )
            self.bgView.addSubview(carNumber)
//            self.bgView.addSubview(arrivedTime)
            self.bgView.addSubview(carType)
            bgView.addSubview(shengChanDate)
            bgView.addSubview(cheJiaHao)
            bgView.addSubview(kongTiaoBeng)
            bgView.addSubview(maDa)
            bgView.addSubview(lvQuanShuLiang)
            bgView.addSubview(lvQuan)
            bgView.addSubview(lunTai)
            bgView.addSubview(kongTiao)
            bgView.addSubview(paiLiang)
            bgView.addSubview(faDongJiHao)
            bgView.addSubview(xinJiu)
            bgView.addSubview(cheMen)
            bgView.addSubview(dianji)
            bgView.addSubview(shuiXiang)
            bgView.addSubview(zuoYi)
            bgView.addSubview(sanYuan)
            
            bgView.addSubview(tips)
            tips.numberOfLines = 0
            self.bgView.addSubview (headerTitle)
            headerTitle.blockView.backgroundColor = .white
            headerTitle.title.textColor = .white
            headerTitle.title.text = "车辆基本信息"
            self.addSubview(headerTitle2)
            headerTitle2.title.text = "车辆基本信息"
            blockView.backgroundColor = .white
            bgView.backgroundColor = mainColor
            layer.cornerRadius = 8
            layer.masksToBounds = true
            backgroundColor = .white
        }
        lazy var totalH: CGFloat = {return _layoutAndGetHeight()}()
        
        func _layoutAndGetHeight() -> CGFloat{
            setValueToUI()
            let rowH: CGFloat = 24
            let bgViewX: CGFloat =  10
            let bgViewY: CGFloat =  10
            let bgViewW =  bounds.width - bgViewX * 2
            let leftX : CGFloat = 10
            let rightX : CGFloat = bgViewW/2
            let rowW =  (bgViewW - leftX * 2)/2
            headerTitle.frame = CGRect(x: 0, y: 10, width: rowW * 2, height: 30)
            var leftMaxY = headerTitle.frame.maxY
            var rightMaxY = headerTitle.frame.maxY
            leftLabels.forEach { (label) in
                label.frame = CGRect(x: leftX, y: leftMaxY, width:label == carType ? rowW * 2 : rowW, height: rowH)
                leftMaxY = label.frame.maxY
            }
            rightLabels.forEach { (label) in
                label.frame = CGRect(x: rightX, y: rightMaxY, width: rowW, height: rowH)
                rightMaxY = label == carNumber ? label.frame.maxY + rowH :  label.frame.maxY
            }
            let tipsY = max(leftMaxY, rightMaxY)
            let tipsH = (tips.text ?? "备注: 无").sizeWith(font: tips.font, maxWidth: rowW * 2).height
            tips.frame = CGRect(x: leftX, y: tipsY, width: rowW * 2, height: tipsH )
            bgView.frame = CGRect(x: bgViewX, y: bgViewY, width:bgViewW, height: tips.frame.maxY + 10)
            headerTitle2.frame = CGRect(x: 10, y: bgView.frame.maxY + 10, width: rowW * 2, height: 30)
            return headerTitle2.frame.maxY + 10 + 58
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            
            _layoutAndGetHeight()
//            bgView.frame = CGRect(x: 10, y: 10, width: bounds.width - 20, height: bounds.height - 20)
//            let margin : CGFloat = 10
//            let h : CGFloat =  (bgView.bounds.height - margin * 2 ) / 4
//            let w : CGFloat =  (bgView.bounds.width - margin * 2 ) / 2
//            blockView.bounds =  CGRect(x: 10, y: 10 , width: 4, height: title.font.lineHeight)
//            title.frame =  CGRect(x: blockView.bounds.width + 20, y: 10, width: 222, height: h)
//            blockView.center = CGPoint(x: 10 + blockView.bounds.width/2, y: title.frame.midY)
//            number.frame = CGRect(x: margin, y: title.frame.maxY, width: w, height: h)
//            carNumber.frame = CGRect(x: margin, y: number.frame.maxY, width: w, height: h)
//
//            carType.frame = CGRect(x: number.frame.maxX, y: number.frame.minY, width: w, height: h)
//            arrivedTime.frame = CGRect(x: carType.frame.minX, y: carType.frame.maxY, width: w, height: h)
//
//            headerTitle.frame = CGRect(x: carType.frame.minX, y: carType.frame.maxY, width: w, height: h)
            self.bgView.layer.cornerRadius = 6
            self.bgView.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setValueToUI() {
            guard let model = self.model else {
                return
            }
            number.text = "编号: \(model.car_no ?? "")"
              carNumber.text  = "车牌号: \(model.car_no ?? "")"
//              arrivedTime.text  = "入场时间: \(model.approach_time ?? "")"
              carType.text   = "车型: \(model.car_name ?? "x")"
              shengChanDate.text  = "生成日期: \(model.car_no ?? "x")"
              paiLiang.text  = "排量: \(model.car_displacement ?? "")"
              cheJiaHao.text  = "车架号: \(model.vin ?? "")"
              faDongJiHao.text  = "发动机号: \(model.engine ?? "")"
              kongTiaoBeng.text  = "空调泵: \(model.condition_pump_count ?? "")"
              xinJiu.text  = "新旧程度: \(model.car_degree ?? "x")"
              maDa.text  = "马达: \(model.motor_count ?? "x")"
              cheMen.text  = "车门: \(model.door_count ?? "")"

             lvQuanShuLiang.text  = "铝圈数量: \(model.alloy_rim_count ?? "")"
             dianji.text  = "电机: \(model.electrical_machinery_count ?? "")"
            lvQuan.text  = "铝圈: \(model.is_alloy_rim ?? "")"
            shuiXiang.text  = "水箱: \(model.cistern_count ?? "")"
                    
               lunTai.text  = "轮胎: \(model.tyre_count ?? "")"
               zuoYi.text  = "座椅: \(model.chair_count ?? "")"
              kongTiao.text  =  "空调: \(model.conditioner_count ?? "")"
              sanYuan.text  = "三元催化器: \(model.catalytic_converter_count ?? "")"
              tips.text   = "备注:  \(model.remark ?? "")"
        }
    }
    
    
}
extension ChaiJieFangShiStep2{
    class BaseInfo: Codable {
        
        var motor_count : String?
        var is_alloy_rim : String?
        var battery_count : String?
        var cistern_count : String?
        var alloy_rim_count : String?
        var remark : String?
        var chair_count : String?
        var car_name : String?
        var approach_time : String?
        var door_count : String?
        var tyre_count : String?
        var catalytic_converter_count : String?
        var car_no : String?
        var car_degree : String?
        var car_code : String?
        var conditioner_count : String?
        var condition_pump_count : String?
        var electrical_machinery_count : String?
        var car_displacement : String?
        var vin : String?
        var engine : String?
    }
    
    class ImageInfo : Codable{
        var file_url : String?
        var first_type : String?
        var two_type : String?
        var file_name : String?
        var id : String?
    }
    
    class CheBaseInfoDataModel: Codable {
         var pageNum: String?
         var pageSize:String?
         var size : String?
         var startRow : String?
         var endRow:String?
         var total:String?
         var pages: String?
         var list:[BaseInfo]?
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
     
}
