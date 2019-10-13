//
//  DengDaiTuoHaoStep2.swift
//  Project
//
//  Created by JohnConnor on 2019/10/5.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class DengDaiTuoHaoStep2: DDNormalVC {
    var baseInfoModel = DengDaiTuoHaoVC.CheYuanModel(){didSet{
        info.arrivedTime.text = "入场时间:\(baseInfoModel.approach_time ?? "")"
        info.number.text = "编号:\(baseInfoModel.car_no ?? "")"
        info.carType.text = "车型:\(baseInfoModel.car_name ?? "")"
        info.carNumber.text = "车型:\(baseInfoModel.car_code ?? "")"
        }
    }
    let addBtn = UIButton()
    let doneBtn = UIButton()
    let info = ChuangJianVC.ChuJianBaseInfoCell()
    let headerTitle = DDDealDetailVC.SectionHeader()
    var chaiJieFangShi: UILabel!
    var apiModel = ApiModel<[ItemModel]>() //= {
//        let m = ApiModel<String>()
//
//    }()
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
        DDQueryManager.share.getImagesOfTuoHao(type: ApiModel<[ItemModel]>.self, carInfoId: baseInfoModel.car_info_id ?? "0") { (apiModel) in
            mylog(apiModel.msg)
            // test
            
            let testReShow = ItemModel()
            testReShow.file_name = "拓号图"
            testReShow.file_url = self.testImg
            testReShow.first_type = "tuo_pic"
            testReShow.two_type = "tuopic"
            apiModel.data = [testReShow]
            //
            
            let m = ItemModel()
            m.file_name = "拍摄拓号图"
            m.file_url = "placeholder"
            if apiModel.ret_code == "0"{
                if (apiModel.data ?? []).isEmpty{
                    apiModel.data = [m]
                }else{
                    apiModel.data?.insert(m, at: 0)
                }
                self.apiModel = apiModel
                self.collection.reloadData()
            }else{
//                self.apiModel.data = [m]
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
               doneBtn.setTitle("拓号完成", for: UIControlState.normal)
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
    let testImg = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493962239167&di=c5619e5047afc37c28beaf04eb2937bd&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F120423%2F107913-12042323220753.jpg"
    @objc func addBtnClick(sender: UIButton){
        mylog("addBtnClick")
        if apiModel.data?.count ?? 0 > 1 {
            let m = apiModel.data![1]
                
                DDQueryManager.share.wanChengTuoHaoImage(type: ApiModel<String>.self, carInfoId: baseInfoModel.car_info_id ?? "", status: "1", img: m) { (apiModel) in
                    if apiModel.ret_code == "0"{
                        GDAlertView.alert("暂存成功")
                    }else{GDAlertView.alert(apiModel.msg)}
                }
            
        }
    }
    @objc func doneBtnClick(sender: UIButton){
        mylog("doneBtnClick")
        mylog("addBtnClick")
        if apiModel.data?.count ?? 0 > 1 {
            let m = apiModel.data![1]
                
                DDQueryManager.share.wanChengTuoHaoImage(type: ApiModel<String>.self, carInfoId: baseInfoModel.car_info_id ?? "", status: "2", img: m) { (apiModel) in
                    if apiModel.ret_code == "0"{
                        GDAlertView.alert(apiModel.msg)
                    }else{GDAlertView.alert(apiModel.msg)}
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

}
extension DengDaiTuoHaoStep2 : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            mylog("perform take photo")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrintTypeItem", for: indexPath)
        if let t = cell as? InfoItem{t.model = apiModel.data?[indexPath.item] ?? ItemModel()}
        return cell
    }
    class ItemModel : Codable{
        var file_url  : String? //": "www.yyyyyyyyyyyyy",
        var first_type  : String? //": "tuo_pic",
        var two_type : String? //": "tuopic",
        var file_name : String? // ": "拓号图1",
        var id : String?

    }
    class InfoItem: UICollectionViewCell {
        var model: ItemModel = ItemModel(){
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
