//
//  DDHomeFuncEditVC.swift
//  Project
//
//  Created by WY on 2019/9/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
private let EditPathReuseIdentifier = "EditPathReuseIdentifier"
class DDHomeFuncEditVC: DDNormalVC , UICollectionViewDataSource , UICollectionViewDelegate  {
    let sectionHeaderH : CGFloat = 40
    let sectionFooterH : CGFloat = 40
    var apiModel = DDFucnEditApiModel()
    var dataSource  : [[DDFuncItemModel]] = [[DDFuncItemModel]]()
    
    let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: DDNavigationBarHeight, width: UIScreen.main.bounds.width, height: SCREENHEIGHT - DDNavigationBarHeight), collectionViewLayout: UICollectionViewFlowLayout())
    /// core method about moveing item
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
        self.view.backgroundColor = UIColor.green
        self.view.addSubview(collectionView)
        self.collectionView.backgroundColor = UIColor.DDLightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        self.congitGesture()
        //        UITableViewDataSource
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.view.width, height: 64)
            flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
            flowLayout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionFooterH)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView.register(EditItem.self, forCellWithReuseIdentifier: EditPathReuseIdentifier)
        
        collectionView.register(EditHeader.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EditHeader")
        collectionView.register(EditFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "EditFooter")
        DDRequestManager.share.funcEditPage(true )?.responseJSON(completionHandler: { (response ) in
            mylog(response.result)
            let jsonDecoder = JSONDecoder.init()
            do{
                let apiModel = try jsonDecoder.decode(DDFucnEditApiModel.self , from: response.data ?? Data())
                self.apiModel = apiModel
                self.dataSource.removeAll()
                if let upArr = apiModel.data.member_function , upArr.count > 0{
                    self.dataSource.append(upArr)
                }
                if let downArr = apiModel.data.system_function , downArr.count > 0{
                    self.dataSource.append(downArr)
                }
                self.collectionView.reloadData()
            }catch{
                mylog(error )
            }
        })
        // Do any additional setup after loading the view.
    }
    func congitGesture()  {
        let longPress = UILongPressGestureRecognizer.init(target: self , action: #selector(handleGesture(gesture:)))
        collectionView.addGestureRecognizer(longPress)
    }
    //    installsStandardGestureForInteractiveMovement
    @objc func handleGesture(gesture :  UILongPressGestureRecognizer)  {
//        print(gesture.state.rawValue)
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath =  self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {break}
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
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
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
//    func indexTitles(for collectionView: UICollectionView) -> [String]?{
//        return ["1" , "2", "3" , "4"]
//    }
//    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath{
//
//        return IndexPath.init(item: 0, section: index   )
//    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.dataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPathReuseIdentifier, for: indexPath)
        if let cellUnwrap = cell as? EditItem {
                cellUnwrap.model = self.dataSource[indexPath.section][indexPath.item]
        }
        // Configure the cell
        cell.backgroundColor = UIColor.white
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind ==  UICollectionElementKindSectionHeader{
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EditHeader", for: indexPath) as? EditHeader{
                header.backgroundColor = UIColor.green
                if indexPath.section == 0 {
                    header.label.text = "已添加工作"
                }else{
                    header.label.text = "未添加工作"
                }
               
//                header.frame = CGRect(x: 0, y: 660, width: collectionView.bounds.width, height: self.sectionHeaderH)
                return header
                
            }
        }else if kind == UICollectionElementKindSectionFooter  {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "EditFooter", for: indexPath)
//            footer.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: sectionFooterH)
            footer.backgroundColor = UIColor.purple
            return footer
        }
        return UICollectionReusableView.init()
    }
    
    class EditItem: UICollectionViewCell {
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
        
        let label  = UILabel()
        let imageView = UIImageView()
        let button = UIButton()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(label)
            self.contentView.addSubview(imageView)
            self.contentView.addSubview(button )
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let imgLeftToBorderMargin : CGFloat = 10
            let imgTopToBorderMargin : CGFloat = 10
            
            imageView.frame = CGRect(x: imgLeftToBorderMargin, y: imgTopToBorderMargin, width: self.bounds.height - imgTopToBorderMargin * 2, height: self.bounds.height - imgTopToBorderMargin * 2)
            let btnToRight : CGFloat = 10
            let btnToTop : CGFloat = 10
            button.frame = CGRect(x: self.bounds.width - btnToRight -  self.bounds.height - btnToTop * 2 , y: btnToTop, width:   self.bounds.height - btnToTop * 2, height: self.bounds.height - btnToTop * 2)
            let margin : CGFloat = 10
            label.frame = CGRect(x: imageView.bounds.maxX + margin, y: 0, width: button.frame.minX - imageView.bounds.maxX - margin * 2, height: self.bounds.height)
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
