//
//  DDDealDetailVC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/1.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class DDDealDetailVC:  DDNormalVC {
    let header = Bundle.main.loadNibNamed("DealDetailHeader", owner: "DealDetailHeader", options: nil)?.first as! DealDetailHeader
    
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        // Do any additional setup after loading the view.
    }
    
    func configTableView() {
        tableView.frame = CGRect(x:10 , y : DDNavigationBarHeight , width : self.view.bounds.width - 20 , height : self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        header.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.bounds.width - 20, height: 138))
        tableView.tableHeaderView = header
        tableView.sectionHeaderHeight = 52
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 111
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "DealDetailCell", bundle: nil), forCellReuseIdentifier: "DealDetailCell")
        //        tableView.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        tableView.gdLoadControl?.loadHeight = 40
        //       requestApi(loadType: LoadDataType.initialize)
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


extension DDDealDetailVC : UITableViewDelegate , UITableViewDataSource {
    //    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        return ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
    //    }
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 9
    //    }
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let titles =  ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
    //        let label = UILabel()
    //        label.text = "  " +  titles[section]
    //        label.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
    //        return label
    //    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = SectionHeader()
        h.backgroundColor = .clear
        return h
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        //        self.searchBox.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealDetailCell")!
        if let c = cell as? DealDetailCell{
            if indexPath.row % 2 == 0{
                c.tips.text = "你哈撒暗示领导会计法啊;老师的会计法;卡时代峰峻; 拉开手机;打了快放假啊;路上看到房价;科技撒;打开了房间啊;数量的咖啡机;"
            }else{
                c.tips.text = "暗示领导好伐啦科技撒阿萨德开房间爱搜IE;嗷呜我和你分手的结合法拉克沙发论文复活拉手的会计法哈里斯抠脚大汉法拉盛款到发货拉开手机都会发链接 科技哈受到法律卡上的分离案件受到法律安可设计好地方凉快圣诞节和法律奥斯卡等级划分拉是的金凤凰离开是的金凤凰拉萨肯德基发生的环境离开"
            }
            
        }
        return cell
    }
    class SectionHeader: UIView {
        let blockView = UIView()
        let title = UILabel(title: "核档记录", font: UIFont.systemFont(ofSize: 16))
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(blockView)
            self.addSubview(title)
            title.backgroundColor = .clear
            self.backgroundColor = .clear
            blockView.backgroundColor = .blue
        }
        //        override init(frame: CGRect) {
        //            super.init(frame: frame)
        
        //        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let H : CGFloat = title.font.lineHeight
            blockView.bounds = CGRect(x: 0, y: (bounds.height - H)/2, width: 4, height: title.font.lineHeight)
            title.frame = CGRect(x: blockView.bounds.width + 20, y: (bounds.height - H)/2, width: bounds.width - blockView.frame.maxX - 20, height: H)
            blockView.center = CGPoint(x: 10 + blockView.bounds.width/2, y: title.frame.midY)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
