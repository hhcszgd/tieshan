//
//  ChaiCheRuKuVC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/2.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ChaiCheRuKuVC: DDNormalVC {
    @IBOutlet weak var headerBG: UIView!
    @IBOutlet weak var bianhao: UILabel!
    @IBOutlet weak var chexing: UILabel!
    @IBOutlet weak var chepai: UILabel!
    @IBOutlet weak var vin: UILabel!
    @IBOutlet weak var chaiJieFangShi: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var printAllBtn: UIButton!
    @IBOutlet weak var printMoreBtn: UIButton!
    
    var baseInfoModel = ChaiGuoDeCheVC.ItemModel()
    var apiModel = ApiModel<[PrintItemModel]>()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bianhao.text = "\(baseInfoModel.vin)"
        chexing.text = "che xing"
        chepai.text = "\(baseInfoModel.carCode)"
        vin.text = "\(baseInfoModel.vin)"
        chaiJieFangShi.text = "chai jie fang shi "
        
        headerBG.layer.cornerRadius = 8
        headerBG.layer.masksToBounds = true
        setLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "拆车入库"
        request()
        // Do any additional setup after loading the view.
    }
    func setLayout () {
        
        let toBorderMargin :CGFloat  = 13
        var itemMargin  : CGFloat = 10
        let itemCountOneRow = 3
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.minimumInteritemSpacing = itemMargin
        let itemW = (self.collection.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow - 1)) / CGFloat(itemCountOneRow)
        var itemH : CGFloat = 34
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        collection.backgroundColor = UIColor.clear
        collection.register(PrintTypeItem.self , forCellWithReuseIdentifier: "PrintTypeItem")
        collection.delegate = self
        collection.dataSource = self
    }
    
    
    @IBAction func printAllAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.apiModel.data?.forEach { (itemModel) in
                itemModel.isSelected = sender.isSelected
            }
        collection.reloadData()
    }
    
    @IBAction func printMoreAction(_ sender: UIButton) {
    }
    @IBAction func printAction(_ sender: UIButton) {
        var actions = [DDAlertAction]()
         let sure = DDAlertAction(title: "确定",textColor:mainColor, style: UIAlertActionStyle.default, handler: { (action ) in
             print("打印")
         })
         
         let cancel = DDAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action ) in
             print("cancel")
         })
         actions.append(cancel)
         actions.append(sure)
         
        let alertView = DDAlertOrSheet(title: "确定打印全部?", message: "● 打印的同时,就会进入库存",messageColor:.gray , preferredStyle: UIAlertControllerStyle.alert, actions: actions)
         alertView.isHideWhenWhitespaceClick = false
         UIApplication.shared.keyWindow?.alert(alertView)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func request()  {
        DDQueryManager.share.getPrintItems(type: ApiModel<[PrintItemModel]>.self) { (apiModel) in
            self.apiModel = apiModel
            self.collection.reloadData()
        }
    }
}
extension ChaiCheRuKuVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let m = apiModel.data?[indexPath.item]
        guard let cell = collectionView.cellForItem(at: indexPath) as? PrintTypeItem else {return}
        m?.isSelected = !(m?.isSelected ?? false)
        var temp = true
        self.apiModel.data?.forEach { (itemModel) in
            if !(itemModel.isSelected ?? false){temp = false}
        }
        printAllBtn.isSelected = temp
        cell.model = m
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrintTypeItem", for: indexPath)
        if let t = cell as? PrintTypeItem{t.model = apiModel.data?[indexPath.item]}
        return cell
    }
    class PrintItemModel : Codable{
        var partsCode : String?
        var filed_name : String?
        var isSelected : Bool? = false
        convenience init(title: String = "", isSelected: Bool = false){
            self.init()
            self.filed_name = title
            self.isSelected = isSelected
        }
    }
    class PrintTypeItem: UICollectionViewCell {
        var model: PrintItemModel? = PrintItemModel(){
            didSet{
                self.label.text = model?.filed_name
                if model?.isSelected ?? false  {
                    self.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
                    self.label.textColor = mainColor
                }else{
                    self.backgroundColor = UIColor.white
                    self.label.textColor = UIColor.darkGray
                }
                layoutIfNeeded()
                setNeedsLayout()
            }
        }
        let label = UILabel(title: "", font: UIFont.systemFont(ofSize: 14), color: UIColor.darkGray, align: NSTextAlignment.center, adjustSize: true)
        override init(frame: CGRect) {
            super.init(frame:frame)
            backgroundColor = .white
            self.addSubview(label)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            label.frame = bounds
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
