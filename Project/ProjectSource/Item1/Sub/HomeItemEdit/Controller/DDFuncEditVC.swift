//
//  DDFuncEditVC.swift
//  Project
//
//  Created by WY on 2019/9/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
protocol EditItemDelegate : NSObjectProtocol {
    func buttonClick(indexPath:IndexPath)
    func buttonClick(cell : DDFuncEditVC.EditItem)
}
import SDWebImage
private let EditPathReuseIdentifier = "EditPathReuseIdentifier"
class DDFuncEditVC: UICollectionViewController , EditItemDelegate {

    let sectionHeaderH : CGFloat = 40
    let sectionFooterH : CGFloat = 40
    var apiModel = DDFucnEditApiModel()
    var dataSource  : [[DDFuncItemModel]] = [[DDFuncItemModel](),[DDFuncItemModel]()]
  
    /// core method about moveing item
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("invoke after moved , deal dataSource at here ")
        mylog("sourceIndexPath: \(sourceIndexPath) , sourceIndexPath: \(destinationIndexPath)")
        if sourceIndexPath.section == 0  {
            if destinationIndexPath.section == 0{
                let sourceItemModel = self.dataSource[0].remove(at: sourceIndexPath.item)
                self.dataSource[0].insert(sourceItemModel, at: destinationIndexPath.item)
                
                //                self.dataSource[0].swapAt(sourceIndexPath.item, destinationIndexPath.item)
            }else{
                let sourceItemModel = self.dataSource[0].remove(at: sourceIndexPath.item)
                self.dataSource[1].insert(sourceItemModel, at: destinationIndexPath.item)
            }
        }else{
            if destinationIndexPath.section == 0{
                let sourceItemModel = self.dataSource[1].remove(at: sourceIndexPath.item)
                self.dataSource[0].insert(sourceItemModel, at: destinationIndexPath.item)
            }else{
                let sourceItemModel = self.dataSource[1].remove(at: sourceIndexPath.item)
                self.dataSource[1].insert(sourceItemModel, at: destinationIndexPath.item)
                
                //                self.dataSource[1].swapAt(sourceIndexPath.item, destinationIndexPath.item)
            }
        }
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.hidesBottomBarWhenPushed = true 
        let saveButtonItem =   UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveBtnClick(sender:)))
        saveButtonItem.tintColor = UIColor.DDSubTitleColor
        self.navigationItem.rightBarButtonItem = saveButtonItem
//        self.view.backgroundColor = UIColor.green
        self.collectionView?.backgroundColor = UIColor.DDLightGray
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false 
        //        UITableViewDataSource
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.view.width, height: 64)
            flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
            flowLayout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionFooterH)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView?.register(EditItem.self, forCellWithReuseIdentifier: EditPathReuseIdentifier)
        
        collectionView?.register(EditHeader.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EditHeader")
        collectionView?.register(EditFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "EditFooter")
        self.title = "我的工作台"
        DDRequestManager.share.funcEditPage(true )?.responseJSON(completionHandler: { (response ) in
            mylog(response.result)
            let jsonDecoder = JSONDecoder.init()
            do{
                let apiModel = try jsonDecoder.decode(DDFucnEditApiModel.self , from: response.data ?? Data())
                self.apiModel = apiModel
//                self.dataSource.removeAll()
                if let upArr = apiModel.data.member_function , upArr.count > 0{
                    self.dataSource[0].append(contentsOf: upArr)
                }
                if let downArr = apiModel.data.system_function , downArr.count > 0{
                    self.dataSource[1].append(contentsOf: downArr)
                }
                self.collectionView?.reloadData()
            }catch{
                mylog(error )
            }
        })
        // Do any additional setup after loading the view.
    }
    @objc func saveBtnClick(sender:UIBarButtonItem) {
        mylog("save")
        if let arr = self.dataSource.first{
            let jsonEncoder = JSONEncoder.init()
            jsonEncoder.outputFormatting = .prettyPrinted
            do{
               let jsonData = try  jsonEncoder.encode(arr)
                if let jsonStr = String.init(data: jsonData, encoding: String.Encoding.utf8){
                    mylog(jsonStr)
                    DDRequestManager.share.changeSquence(json: jsonStr)?.responseJSON(completionHandler: { (response ) in
                        mylog(response.result)
                        switch response.result{
                        case .success :
                            GDAlertView.alert("保存成功", image: nil , time: 2 , complateBlock: nil)
                            NotificationCenter.default.post(Notification.init(name: Notification.Name.init("ChangeSquenceSuccess")))
                        case .failure :
                            GDAlertView.alert("保存失败", image: nil , time: 2 , complateBlock: nil)
                        }
                    })
                }
            }catch{
                GDAlertView.alert("unknown error", image: nil , time: 2 , complateBlock: nil)
            }
        }else{
            GDAlertView.alert("unknown error", image: nil , time: 2 , complateBlock: nil)
        }
    }
    func buttonClick(cell : EditItem){
        if let indexPath = self.collectionView?.indexPath(for: cell){
            mylog(indexPath)
            var destinationIndexpath  : IndexPath!
            if indexPath.section == 0 {
                destinationIndexpath = IndexPath.init(item: 0, section: 1)
                mylog("把数据从已选择的\(indexPath) ,移动到未选择的\(destinationIndexpath)")
                mylog("此时的dataSource \(dataSource)")
                let a = dataSource[indexPath.section].remove(at: indexPath.item)
                dataSource[1].insert(a, at: destinationIndexpath.item)
            }else{
                let item = dataSource.first?.count ?? 0
                destinationIndexpath = IndexPath.init(item: item, section: 0)
                
                
                mylog("把数据从未选择的\(indexPath) ,移动到已选择的\(destinationIndexpath)")
                mylog("此时的dataSource \(dataSource)")
                let a = dataSource[indexPath.section].remove(at: indexPath.item)
                dataSource[0].insert(a, at: destinationIndexpath.item)
            }
            self.collectionView?.moveItem(at: indexPath, to: destinationIndexpath)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.collectionView?.reloadData()
            }
        }
    }
    func buttonClick(indexPath: IndexPath) {
        mylog(indexPath)
        var destinationIndexpath  : IndexPath!
        if indexPath.section == 0 {
            destinationIndexpath = IndexPath.init(item: 0, section: 1)
            mylog("把数据从已选择的\(indexPath) ,移动到未选择的\(destinationIndexpath)")
            mylog("此时的dataSource \(dataSource)")
            let a = dataSource[indexPath.section].remove(at: indexPath.item)
            dataSource[1].insert(a, at: destinationIndexpath.item)
        }else{
            let item = dataSource.first?.count ?? 0
            destinationIndexpath = IndexPath.init(item: item, section: 0)
            
            
            mylog("把数据从未选择的\(indexPath) ,移动到已选择的\(destinationIndexpath)")
            mylog("此时的dataSource \(dataSource)")
            let a = dataSource[indexPath.section].remove(at: indexPath.item)
            dataSource[0].insert(a, at: destinationIndexpath.item)
        }
            self.collectionView?.moveItem(at: indexPath, to: destinationIndexpath)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.collectionView?.reloadData()
        }
            
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.dataSource.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dataSource[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPathReuseIdentifier, for: indexPath)
        if let cellUnwrap = cell as? EditItem {
            cellUnwrap.delegate = self
            cellUnwrap.indexPath = indexPath
            cellUnwrap.model = self.dataSource[indexPath.section][indexPath.item]
            
        }
        
        // Configure the cell
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind ==  UICollectionElementKindSectionHeader{
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EditHeader", for: indexPath) as? EditHeader{
                header.backgroundColor = UIColor.DDLightGray
                if indexPath.section == 0 {
                    header.label.text = "   已添加工作"
                }else{
                    header.label.text = "   未添加工作"
                }
                
                //                header.frame = CGRect(x: 0, y: 660, width: collectionView.bounds.width, height: self.sectionHeaderH)
                return header
                
            }
        }else if kind == UICollectionElementKindSectionFooter  {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "EditFooter", for: indexPath)
            //            footer.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: sectionFooterH)
            footer.backgroundColor = UIColor.DDLightGray
            if let footerUnwrap = footer as? EditFooter{
                if indexPath.section == 0 {footerUnwrap.label.isHidden = false }else{footerUnwrap.label.isHidden = true }
            }
            return footer
        }
        return UICollectionReusableView.init()
    }

    class EditItem: UICollectionViewCell {
        var indexPath  = IndexPath(){
            didSet{
                if indexPath.section == 0 {
//                    self.button.setTitle("-", for: UIControlState.normal)
                    self.button.setImage(UIImage(named:"subtractingicons"), for: UIControlState.normal)
                }else{
                    self.button.setImage(UIImage(named:"addicon"), for: UIControlState.normal)
//                    self.button.setTitle("+", for: UIControlState.normal)
                }
            }
        }
        
        var model : DDFuncItemModel? = DDFuncItemModel(){
            didSet{
                if model == nil  {return}
                label.text = model!.name
                if let url  = URL(string:model!.image_url) {
                    imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
                }else{
                    imageView.image = DDPlaceholderImage
                }
            }
        }
        weak var delegate : EditItemDelegate?
        let label  = UILabel()
        let imageView = UIImageView()
        let button = UIButton()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(label)
            self.contentView.addSubview(imageView)
            self.contentView.addSubview(button )
//            self.button.setTitle("-", for: UIControlState.normal)
            self.button.setTitleColor(.black, for: UIControlState.normal)
            self.button.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
            label.textColor = UIColor.DDSubTitleColor
        }
        @objc func buttonClick(sender:UIButton){
//            func buttonClick(cell : EditItem)
            self.delegate?.buttonClick(cell: self)
//            self.delegate?.buttonClick(indexPath: indexPath)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let imgLeftToBorderMargin : CGFloat = 10
            let imgTopToBorderMargin : CGFloat = 10
            imageView.frame = CGRect(x: imgLeftToBorderMargin, y: imgTopToBorderMargin, width: self.bounds.height - imgTopToBorderMargin * 2, height: self.bounds.height - imgTopToBorderMargin * 2)
            let btnWH : CGFloat = self.bounds.height
            button.frame = CGRect(x: self.bounds.width - btnWH , y: 0, width:  btnWH, height: btnWH)
            let margin : CGFloat = 10
            label.frame = CGRect(x: imageView.frame.maxX + margin, y: 0, width: button.frame.minX - imageView.bounds.maxX - margin * 2, height: self.bounds.height)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class EditHeader: UICollectionReusableView {
        let label = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame )
            self.addSubview(label)
            label.textColor = UIColor.DDSubTitleColor
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.label.frame = self.bounds
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class EditFooter: UICollectionReusableView {
        let label = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame )
            self.addSubview(label)
            label.textAlignment = .center
            label.textColor = UIColor.DDSubTitleColor
            label.font = GDFont.systemFont(ofSize: 13)
            label.text = "长按拖动可调整工作显示顺序"
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.label.frame = self.bounds
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
