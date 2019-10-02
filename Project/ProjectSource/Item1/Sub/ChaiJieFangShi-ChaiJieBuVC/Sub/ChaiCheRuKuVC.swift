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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerBG.layer.cornerRadius = 8
        headerBG.layer.masksToBounds = true
        setLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func printMoreAction(_ sender: UIButton) {
    }
    @IBAction func printAction(_ sender: UIButton) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    lazy var types: [PrintItemModel] = {
        return [
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
            PrintItemModel(title: "title"),
        ]
    }()
}
extension ChaiCheRuKuVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let m = types[indexPath.item]
        guard let cell = collectionView.cellForItem(at: indexPath) as? PrintTypeItem else {return}
        m.isSelected = !m.isSelected
        cell.model = m
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrintTypeItem", for: indexPath)
        if let t = cell as? PrintTypeItem{t.model = types[indexPath.item]}
        return cell
    }
    class PrintItemModel {
        var title = ""
        var isSelected = false
        convenience init(title: String = "", isSelected: Bool = false){
            self.init()
            self.title = title
            self.isSelected = isSelected
        }
    }
    class PrintTypeItem: UICollectionViewCell {
        var model: PrintItemModel = PrintItemModel(){
            didSet{
                self.label.text = model.title
                if model.isSelected {
                    self.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
                }else{
                    self.backgroundColor = UIColor.white
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
