//
//  ChuangJianVC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/4.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ChuangJianVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

enum CheRowIdentifyType {
    case contactName
    case contactMobile
    case contactAddress
    case taiCi
    case bankName
    case branchBankName
    case bankNumber
    case bankAccountName
    case carNum
    /// 车型
    case carType
    case dealStyle
    case dealDate
    case shouXuHuoQuStyle
    case shouXu
    case tips
}
enum CheRowFunctionType {
    case singleChoose
    case multipleChoose
    case singleInput
    case multipleInput
    case chooseAndInput
    case save
    case sectionSpace
    case rowSpace
    case title
}
class CheYuanOrCheLiangModel {
    var title : String = ""
    /// name of cell
    var stringOfClassName = ""
    var placeHolder = ""
    var value = ""
    var addtionalValue = ""
    var id = ""
    var values : [Any] = []
    var shouXuTypes : [ShouXuTypeModel] = []
    var isValid: Bool = true//是否有效
    var identify : CheRowIdentifyType = .contactName
    
    convenience init(title: String = "", isValid: Bool = true, stringOfClassName : String, placeholder: String = ""){
        self.init()
        self.title = title
        self.isValid = isValid
        self.stringOfClassName = stringOfClassName
        self.placeHolder = placeholder
    }
}

class ShouXuTypeModel {
    var title = ""
    var isSelected = false
    var id : Int = 0
    convenience init(title: String ,_ isSelected: Bool,_ id: Int){
        self.init()
        self.title = title
        self.isSelected = isSelected
        self.id = id
    }
}
extension ChuangJianVC{
    class DDSingleInputRow : UITableViewCell {
        let bottomLine = UIView()
        let title = UILabel()
        let textfield = UITextField()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
                textfield.placeholder = model.placeHolder
                textfield.text = model.value.isEmpty ? nil : model.value
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(textfield)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = mainBgColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            title.frame = CGRect(x: 10, y: 0, width: 100, height: bounds.height)
            textfield.frame = CGRect(x:title.frame.maxX, y: 0, width: bounds.width - title.frame.maxX - 20, height: bounds.height)
            bottomLine.frame  = CGRect(x:0, y: 0, width: bounds.height - 1, height: 1)
        }
        
    }
    class DDSectionHeaderRow : UITableViewCell {
        let blockView = UIView()
        let titleLabel = UILabel()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                titleLabel.text = model.title
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.backgroundColor = UIColor.white
            blockView.backgroundColor = mainColor
            self.contentView.addSubview(blockView)
            self.contentView.addSubview(titleLabel)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            blockView.frame = CGRect(x: 10, y: (bounds.height - 20 ) / 2, width: 4 , height: 20)
            titleLabel.frame = CGRect(x:blockView.frame.maxX + 10, y: 0 , width: bounds.width - blockView.frame.maxX - 30 , height: bounds.height)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    class DDSectionSeparator : UITableViewCell {
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.backgroundColor = mainBgColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDSingleChoose : UITableViewCell{
        let bottomLine = UIView()
        let title = UILabel()
        let arrow = UIImageView(image: UIImage(named:"icon_arrow_right2"))
        let textfield = UITextField()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
                textfield.placeholder = model.placeHolder
                textfield.text = model.value.isEmpty ? nil : model.value
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(arrow)
            self.contentView.addSubview(textfield)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = mainBgColor
            textfield.isEnabled = false
            arrow.contentMode = .scaleAspectFit
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            title.frame = CGRect(x: 10, y: 0, width: 100, height: bounds.height)
            arrow.frame = CGRect(x:bounds.width - 8 - 10, y: 0, width: 8, height: bounds.height)
            textfield.frame = CGRect(x:title.frame.maxX, y: 0, width: arrow.frame.minX - title.frame.maxX - 20, height: bounds.height)
            bottomLine.frame  = CGRect(x:0, y: 0, width: bounds.height - 1, height: 1)
        }
    }
    
    
    
    class DDTips : UITableViewCell , UITextViewDelegate{
        let title = UILabel()
        let textfield = UITextView()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
                if model.value.isEmpty {
                    textfield.text = "请输入..."
                    textfield.textColor = UIColor.lightGray
                }else{
                    textfield.text = model.value
                    textfield.textColor = UIColor.darkGray
                }
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(textfield)
            textfield.delegate = self
            textfield.backgroundColor = UIColor.DDLightGray1
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            title.frame = CGRect(x: 10, y: 0, width: 100, height: 38)
            textfield.frame = CGRect(x:title.frame.maxX, y: 0, width: bounds.width - title.frame.maxX - 20, height: bounds.height - 20)
        }
        
        func textViewDidEndEditing(_ textView: UITextView){
            if textView.text == ""{
                textView.text = "请输入"
                textView.textColor = UIColor.lightGray
            }
            mylog("...")
        }
        func textViewDidBeginEditing(_ textView: UITextView){
            if textView.text == "请输入"{
                textView.text = ""
                textView.textColor = UIColor.darkGray
            }
        }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
            if text == "\n"{
                textView.endEditing(true)
                return false
            }
            //        if textView.text.count > 120 && text.count > 0{
            //            return false
            //        }
            return true
        }
    }
    
    
    
    
    class DDShouxu : UITableViewCell{
        let bottomLine = UIView()
        let title = UILabel()
        lazy var btns: [UIButton] = {
            var index = 0
            return self.model.shouXuTypes.map { (type ) -> UIButton in
                let btn = UIButton()
                btn.setTitle(type.title, for: UIControlState.normal)
                btn.setBackgroundImage(UIImage.ImageWithColor(color: .white, frame: CGRect(origin: .zero, size: CGSize(width: 88, height: 40))), for: UIControlState.normal)
                btn.setBackgroundImage(UIImage.ImageWithColor(color: mainColor, frame: CGRect(origin: .zero, size: CGSize(width: 88, height: 40))), for: UIControlState.selected)
                btn.setTitleColor(.white, for: UIControlState.selected)

                btn.setTitleColor(UIColor.gray, for: UIControlState.normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                self.contentView.addSubview(btn)
                btn.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
                    btn.layer.borderWidth = 1
                btn.layer.cornerRadius = 6
                btn.layer.masksToBounds = true
                btn.tag = index
                index += 1
                return btn
            }
        }()
        /// 状态需要模型控制
        @objc func btnClick(sender:UIButton) {
            model.shouXuTypes[sender.tag].isSelected = !model.shouXuTypes[sender.tag].isSelected
            sender.isSelected = !sender.isSelected
            setNeedsLayout()
        }
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = mainBgColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            var titleW : CGFloat = 100
            if UIScreen.main.bounds.width <= 375{titleW = 52}
            title.frame = CGRect(x: 10, y: 0, width: titleW, height: 38)
            let margin : CGFloat = 8
            let space = margin * 3 + 10
            let firstX = title.frame.maxX
            let firstY = margin
            let oneH = (bounds.height - margin * 3) / 2
            let oneW = (bounds.width - firstX - space) / 3
            for (index , btn) in btns.enumerated(){
                btn.frame = CGRect(x: firstX + CGFloat(index % 3) * (oneW + margin) , y: CGFloat(index / 3) * (oneH + margin), width: oneW, height: oneH)
                btn.isSelected = model.shouXuTypes[index].isSelected
                if btn.isSelected{
                    btn.layer.borderColor = mainColor.cgColor
                }else{
                    btn.layer.borderColor = UIColor.lightGray.cgColor
                }
            }
            bottomLine.frame  = CGRect(x:0, y: 0, width: bounds.height - 1, height: 1)
        }
    }
    
}
