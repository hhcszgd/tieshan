//
//  DDChooseAlert.swift
//  Project
//
//  Created by JohnConnor on 2019/10/14.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit
class ChooseModel {
    var title : String?
    var subTitle : String?
    var id : String?
    var para : String?
    init(title:String, _ subTitle: String? = nil, id: String? = nil, para: String? = nil ) {
        self.title = title
        self.subTitle = subTitle
        self.id = id
        self.para = para 
    }
}
class DDChooseAlert: DDMaskBaseView {
    var models : [ChooseModel] = []
    let subContainer = UIView()
//    let cancel = UIButton()
//    let confirm = UIButton()
    var confirmHandler : ((ChooseModel) -> ())?
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
    convenience init(models:[ChooseModel] ){
        self.init(frame: .zero)
        self.models = models
        self.backgroundColor = .black
        self.addSubview(subContainer)
        self.subContainer.addSubview(tableView)
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        subContainer.frame = CGRect(x: 0, y: bounds.height * 0.7, width: bounds.width, height: bounds.height * 0.3)
        tableView.frame = CGRect(x: 0, y: 10, width: subContainer.bounds.width, height: subContainer.bounds.height - 10)
        tableView.separatorStyle = .none
    }
}

extension DDChooseAlert : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.models[indexPath.row]
        self.confirmHandler?(model)
        self.remove()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c : AlertCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell") as? AlertCell{
            c = cell
        }else{
            let cell = AlertCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "AlertCell")
            c = cell
        }
        c.textLabel?.textAlignment = .center
        c.textLabel?.textColor = .gray
        c.textLabel?.text = models[indexPath.row].title
//        returnCell.textLabel?.textColor = UIColor.DDSubTitleColor
        c.selectionStyle = .none
        return c
    }
    
    class AlertCell: UITableViewCell {
        let bottomLine = UIView()
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = UIColor.DDLightGray1
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            bottomLine.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
