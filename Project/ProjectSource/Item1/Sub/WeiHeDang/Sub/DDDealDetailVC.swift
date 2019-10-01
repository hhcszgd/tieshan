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
    
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        // Do any additional setup after loading the view.
    }
    
        func configTableView() {
        tableView.frame = CGRect(x:10 , y : DDNavigationBarHeight , width : self.view.bounds.width - 20 , height : self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            header.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.bounds.width - 20, height: 138))
            tableView.tableHeaderView = header
            tableView.sectionHeaderHeight = 52
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
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
        let h = SectionHeader(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: 72))
        h.backgroundColor = .clear
        return h
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
//        self.searchBox.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") {
            cell.textLabel?.text = "xxxxxx"
            cell.backgroundColor = .white
            return cell
        }else{
            
            let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCell")
            cell.textLabel?.text = "xxxxxx"
            cell.backgroundColor = .white
            return cell
        }
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
            let H : CGFloat = 20
            blockView.frame = CGRect(x: 10, y: (bounds.height - H)/2, width: 4, height: H)
            title.frame = CGRect(x: blockView.frame.maxX + 10, y: (bounds.height - H)/2, width: bounds.width - blockView.frame.maxX - 20, height: H)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
