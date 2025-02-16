//
//  ChuJianStep2VC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/5.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ChuJianStep2VC: DDNormalVC {
    
    let addBtn = UIButton()
    let doneBtn = UIButton()
    let info = ChuangJianVC.ChuJianBaseInfoCell()
    let headerTitle = DDDealDetailVC.SectionHeader()
    var carInfoId = ""
    var carBaseInfoModel : DengDaiYuChuLiVC.CheYuanModel = DengDaiYuChuLiVC.CheYuanModel(){didSet{
        info.arrivedTime.text = "入场时间:\(carBaseInfoModel.approach_time ?? "")"
        info.number.text = "编号:\(carBaseInfoModel.car_no ?? "")"
        info.carType.text = "车型:\(carBaseInfoModel.car_name ?? "")"
        info.carNumber.text = "车型:\(carBaseInfoModel.car_code ?? "")"
        }}
    var chaiJieFangShi: UILabel!
    var apiModel = ApiModel<[ItemModel]>()
    lazy var collection: UICollectionView = {
        let c = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        return c
    }()
    lazy var flowLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(info)
        view.addSubview (headerTitle)
        headerTitle.title.text = "车辆基本信息"
        info.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: view.bounds.width, height: 100)
        headerTitle.frame = CGRect(x: 10, y: info.frame.maxY, width: view.bounds.width, height: 30)
        view.backgroundColor = .white
        headerTitle.backgroundColor = .white
        setupBottomBtn()
        setupCollection()
        setLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车辆初检"
        request()
        // Do any additional setup after loading the view.
    }
    func request() {
        DDQueryManager.share.getImagesOfYuChuLi(type: ApiModel<[ItemModel]>.self, carInfoId: carBaseInfoModel.car_info_id ?? "0") { (apiModel) in
            mylog(apiModel.msg)
            if apiModel.ret_code == "0"{
                self.apiModel = apiModel
                self.collection.reloadData()
            }else{
                GDAlertView.alert(apiModel.msg)
            }
        }
    }
    func setupBottomBtn() {
        self.view.addSubview(addBtn)
               self.view.addSubview(doneBtn)
        addBtn.frame = CGRect(x: 20, y: view.frame.height - 60, width: (view.bounds.width - 40 - 20)/2, height: 40)
               addBtn.setTitleColor(mainColor, for: .normal)
               addBtn.setTitle("暂存", for: UIControlState.normal)
               addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
               addBtn.layer.cornerRadius = 8
               addBtn.layer.masksToBounds = true
               addBtn.layer.borderColor = mainColor.cgColor
               addBtn.layer.borderWidth = 1
               doneBtn.frame = CGRect(x:addBtn.frame.maxX + 20, y: addBtn.frame.minY, width: addBtn.frame.width, height: 40)
               doneBtn.backgroundColor = mainColor
               doneBtn.setTitle("初检完成", for: UIControlState.normal)
               doneBtn.addTarget(self , action: #selector(doneBtnClick(sender:)), for: UIControlEvents.touchUpInside)
               doneBtn.layer.cornerRadius = 8
               doneBtn.layer.masksToBounds = true

    }
    func setupCollection() {

        let tableViewFrame = CGRect(x: 0, y: headerTitle.frame.maxY, width: self.view.bounds.width , height: self.addBtn.frame.minY - headerTitle.frame.maxY)
                       
        //               self.tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.plain)
        //               self.view.addSubview(self.tableView!)
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
    }
    @objc func addBtnClick(sender: UIButton){
        mylog("addBtnClick")
        let postModel = ZanCunBaoCunModel(carInfoId: carBaseInfoModel.car_info_id ?? "", status: "1", itemModels: apiModel.data ?? [])
        
        DDQueryManager.share.wanChengChuJianImage(type: ApiModel<String>.self, para: postModel) { (apiModel) in
            if apiModel.ret_code == "0"{
                GDAlertView.alert("暂存成功") {
                    
                }
            }else{
                GDAlertView.alert(apiModel.msg)
            }
        }
    }
    @objc func doneBtnClick(sender: UIButton){
                mylog("addBtnClick")
        let postModel = ZanCunBaoCunModel(carInfoId: carBaseInfoModel.car_info_id ?? "", status: "2", itemModels: apiModel.data ?? [])
        
        DDQueryManager.share.wanChengChuJianImage(type: ApiModel<String>.self, para: postModel) { (apiModel) in
            if apiModel.ret_code == "0"{
                GDAlertView.alert("初检完成") {
                    
                }
            }else{
                GDAlertView.alert(apiModel.msg)
            }
        }
        
    }
    func setLayout () {
        
        let toBorderMargin :CGFloat  = 13
        var itemMargin  : CGFloat = 10
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
//    lazy var types: [ItemModel] = {
//        let url = "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1570261863&di=3933a340bbd7484226e88d074f3c5716&src=http://pic.cn2che.com/Editors/2011-10/14/U5337P33DT20111013075237.jpg"
//        return [
//            ItemModel( "增加照片", "placeholder"),
//            ItemModel(  "发动机", url),
//            ItemModel( "后桥", url),
//            ItemModel( "左前车门", url),
//            ItemModel( "右前车门", url),
//            ItemModel("左后车门", url),
//            ItemModel("右后车门", url),
//            ItemModel("左前大灯", url),
//            ItemModel("右前大灯", url),
//            ItemModel("后保险杠", url),
//            ItemModel("车顶", url),
//            ItemModel("车前脸", url),
//            ItemModel("车后脸", url),
//        ]
//    }()
}
extension ChuJianStep2VC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            mylog("perform take photo")
            self.navigationController?.pushViewController(TakePhotoVC(), animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrintTypeItem", for: indexPath)
        if let t = cell as? InfoItem{t.model = apiModel.data?[indexPath.item]}
        return cell
    }
    class ItemModel : Codable{
        /// 空为展位图,否则就是已经上传图片
        var id : String?
        var file_name : String?
        var first_type : String?
        var two_type : String?
        var file_url : String?
        
    }
    class InfoItem: UICollectionViewCell {
        var model: ItemModel? = ItemModel(){
            didSet{
                self.label.text = model?.file_name
                if let i = model?.file_url , i != "placeholder"{
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
            self.imageView.backgroundColor = UIColor.DDLightGray1
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
extension ChuJianStep2VC{
    ///用来传给服务器
    class ZanCunBaoCunItemModel : Codable{
        var filed_name : String?
        var first_type : String?
        var two_type : String?
        var fileUrl : String?    }
    class ZanCunBaoCunModel: Codable {
        var carInfoId : String = ""
        /// 1暂存, 2 完成
        var status : String = "1"
        var data:[ZanCunBaoCunItemModel] = []
        convenience init(carInfoId: String, status: String, itemModels: [ItemModel]){
            self.init()
            self.carInfoId = carInfoId
            self.status = status
            var temp :[ZanCunBaoCunItemModel] = []
            itemModels.forEach { (itemModel) in
                let t = ZanCunBaoCunItemModel()
                t.filed_name = itemModel.file_name
                t.first_type = itemModel.first_type
                t.two_type = itemModel.two_type
                t.fileUrl = itemModel.file_url
                temp.append(t)
            }
            self.data = temp
        }
        func toJson() -> String  {
            let encoder = JSONEncoder()
            do{
                let data =   try encoder.encode(self)
                let str = String(data: data, encoding: .utf8)
                return str ?? ""
            }
            catch{return ""}
        }
    }
}
