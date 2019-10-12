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
    var identify : String = ""
    var futureModel: Any?
    convenience init(identify: String = "", title: String = "",value:String = "", isValid: Bool = true, stringOfClassName : String, placeholder: String = "" , futureModel:Any? = nil){
        self.init()
        self.title = title
        self.isValid = isValid
        self.stringOfClassName = stringOfClassName
        self.placeHolder = placeholder
        self.value = value
        self.identify = identify
        self.futureModel = futureModel
    }
}

class ShouXuTypeModel {
    var title = ""
    var isSelected = false
    var id : Int = 0
    var identify = ""
    var status : Int{return isSelected ? 2 : 1}
    
    convenience init(title: String ,_ isSelected: Bool,_ id: Int , identify : String){
        self.init()
        self.title = title
        self.isSelected = isSelected
        self.id = id
    }
}
extension ChuangJianVC{
    class ChuJianBaseInfoCell: DDTableViewCell {
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
                guard let infoModel = model.futureModel as? DengDaiChuJianVC.CheYuanModel else{
                    return
                }
                number.text = "编号: \(infoModel.carCode ?? "null")"
                carNumber.text =  "车牌号: \(infoModel.carNo ?? "null")"
                arrivedTime.text =  "入场时间: \(infoModel.approachTime ?? "0")"
                carType.text  =  "车型: \(infoModel.carName ?? "null")"
                
            }
        }
        lazy var infoModel : DengDaiChuJianVC.CheYuanModel = {
            guard let m = model.futureModel as? DengDaiChuJianVC.CheYuanModel else{
                return DengDaiChuJianVC.CheYuanModel()
            }
            return m
        }()
        let bgView = UIView()
        let blockView = UIView()
        lazy var title = UILabel(title: "车辆基本信息", font: UIFont.systemFont(ofSize: 15), color: UIColor.white)
        lazy var number = UILabel(title: "编号: \(infoModel.carCode)",font: UIFont.systemFont(ofSize: 15), color: .white)
        lazy var carNumber = UILabel(title: "车牌号: \(infoModel.carNo)", font: UIFont.systemFont(ofSize: 15), color: .white)
        lazy var arrivedTime = UILabel(title: "入场时间: \(infoModel.approachTime)", font: UIFont.systemFont(ofSize: 15), color: .white)
        lazy var carType  = UILabel(title: "车型: \(infoModel.carName)", font: UIFont.systemFont(ofSize: 15), color: .white)
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(bgView)
            self.bgView.addSubview(blockView )
            self.bgView.addSubview(title)
            self.bgView.addSubview(number )
            self.bgView.addSubview(carNumber)
            self.bgView.addSubview(arrivedTime)
            self.bgView.addSubview(carType)
            blockView.backgroundColor = .white
            bgView.backgroundColor = mainColor
            layer.cornerRadius = 8
            layer.masksToBounds = true
            backgroundColor = .white
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            bgView.frame = CGRect(x: 10, y: 10, width: bounds.width - 20, height: bounds.height - 20)
            let margin : CGFloat = 10
            let h : CGFloat =  (bgView.bounds.height - margin * 2 ) / 3
            let w : CGFloat =  (bgView.bounds.width - margin * 2 ) / 2
            blockView.bounds =  CGRect(x: 10, y: 10 , width: 4, height: title.font.lineHeight)
            title.frame =  CGRect(x: blockView.bounds.width + 20, y: 10, width: 222, height: h)
            blockView.center = CGPoint(x: 10 + blockView.bounds.width/2, y: title.frame.midY)
            number.frame = CGRect(x: margin, y: title.frame.maxY, width: w, height: h)
            carNumber.frame = CGRect(x: margin, y: number.frame.maxY, width: w, height: h)
            
            carType.frame = CGRect(x: number.frame.maxX, y: number.frame.minY, width: w, height: h)
            arrivedTime.frame = CGRect(x: carType.frame.minX, y: carType.frame.maxY, width: w, height: h)
            self.bgView.layer.cornerRadius = 6
            self.bgView.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class DDSingleInputRow : DDTableViewCell ,UITextFieldDelegate{
        let bottomLine = UIView()
        let title = UILabel()
        let textfield = UITextField()
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                title.text = model.title
                textfield.placeholder = model.placeHolder
                if  !model.value.isEmpty{
                    if model.value == "0"{
                            textfield.text = nil
                    }else{
                        textfield.text = model.value
                    }
                }else{ textfield.text = nil }
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(title)
            self.contentView.addSubview(textfield)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = mainBgColor
            textfield.delegate = self
            textfield.returnKeyType = .done
//            textfield.textAlignment = .right
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textfield.endEditing(true)
            return true
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
             let textt = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
             mylog(textt)
            self.model.value = textt
             return true
         }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            title.frame = CGRect(x: 10, y: 0, width: 100, height: bounds.height)
            textfield.frame = CGRect(x:title.frame.maxX, y: 0, width: bounds.width - title.frame.maxX - 20, height: bounds.height)
            bottomLine.frame  = CGRect(x:0, y: 0, width: bounds.width , height: 1)
        }
        
    }
    
    class DDSectionHeaderRow : DDTableViewCell {
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
    
    
    class DDSectionSeparator : DDTableViewCell {
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
    class DDSingleChoose : DDTableViewCell{
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
    
    
    
    class DDTips : DDTableViewCell , UITextViewDelegate{
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
            }else{
                let textt = NSString(string: textView.text ?? "").replacingCharacters(in: range, with: text)
                 mylog(textt)
                self.model.value = textt
            }
            //        if textView.text.count > 120 && text.count > 0{
            //            return false
            //        }
            return true
        }
    }
    
    
    
    
    class DDShouxu : DDTableViewCell{
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
    class OldLevelRow: DDTableViewCell {
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                carColorTitle.text = model.title
                /// 新旧程度 1:正常 ,2:火灾 , 3:碰撞 ,4:水淹
                switch model.value {
                case "1":
                    self.btnClick(sender: blue)
                case "2":
                    self.btnClick(sender: yellow)
                case "3":
                    self.btnClick(sender: white)
                case "4":
                    self.btnClick(sender: black)
                    
                default:
                    break
                }
            }
        }
        lazy var carColorTitle:UILabel  =  {
            let l = UILabel(title: "新旧程度:", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
            contentView.addSubview(l)
            l.sizeToFit()
            l.frame = CGRect(x: 10, y: 0, width: l.bounds.width , height: bounds.height)
            return l
        }()
        private lazy var colorBtnW : CGFloat = {
            let left = (bounds.width - firstBtnX - 10)/4
            return left
        }()
        private lazy var firstBtnX : CGFloat = {
            let x = carColorTitle.frame.maxX + 10
            return x
        }()

        var btns : [UIButton]{return [blue,yellow , white , black]}
        lazy var blue : UIButton = {
            let b = UIButton(title: "正常")
            b.frame = CGRect(x: firstBtnX, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
            contentView.addSubview(b)
            b.tag = 0
            return b
        }()
        
        lazy var yellow: UIButton  =  {
            let b = UIButton(title: "火灾")
            contentView.addSubview(b)
            b.tag = 1
            b.frame = CGRect(x: blue.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
            return b
        }()
        lazy var white: UIButton  =  {
            let b = UIButton(title: "碰撞")
            b.frame = CGRect(x: yellow.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            contentView.addSubview(b)
            b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
            b.tag = 2
            return b
        }()
        lazy var black: UIButton =  {
            let b = UIButton(title: "水淹")
            contentView.addSubview(b)
            b.tag = 3
            b.frame = CGRect(x: white.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
            return b
        }()
        var selectColorIndex = -1
        
        @objc func btnClick(sender:UIButton){
            mylog(sender.title(for: UIControlState.normal))
            sender.isSelected = !sender.isSelected
            btns.forEach { (b) in
                if b != sender{b.isSelected = false }
            }
            if sender.isSelected {
                selectColorIndex = sender.tag
                model.value = "\(selectColorIndex + 1)"
            }else{selectColorIndex = -1}
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            carColorTitle.frame = CGRect(x: 10, y: 0, width: carColorTitle.bounds.width , height: bounds.height)
            firstBtnX = carColorTitle.frame.maxX + 10
            colorBtnW  =  (bounds.width - firstBtnX - 10)/4
            blue.frame = CGRect(x: firstBtnX, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            yellow.frame = CGRect(x: blue.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            white.frame = CGRect(x: yellow.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            black.frame = CGRect(x: white.frame.maxX, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
        }
    }
    class YesOrNoRow : DDTableViewCell{
        var model : CheYuanOrCheLiangModel = CheYuanOrCheLiangModel() {
            didSet{
                carColorTitle.text = model.title
                ///是否是铝圈，1.是，2.不是
                switch model.value {
                  case "1":
                      self.btnClick(sender: blue)
                  case "2":
                      self.btnClick(sender: yellow)
                  default:
                      break
                  }
            }
        }
        lazy var carColorTitle:UILabel  =  {
            let l = UILabel(title: "新旧程度:", font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
            contentView.addSubview(l)
            l.sizeToFit()
            l.frame = CGRect(x: 10, y: 0, width: l.bounds.width , height: bounds.height)
            return l
        }()
        private lazy var colorBtnW : CGFloat = {
            let left = (bounds.width - firstBtnX - 10)/4
            return left
        }()
        private lazy var firstBtnX : CGFloat = {
            let x = carColorTitle.frame.maxX + 10
            return x
        }()

        lazy var blue : UIButton = {
            let b = UIButton(title: "是")
            b.frame = CGRect(x: yellow.frame.minX - colorBtnW, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
            contentView.addSubview(b)
            b.tag = 0
            return b
        }()
        
        lazy var yellow: UIButton  =  {
            let b = UIButton(title: "不是")
            contentView.addSubview(b)
            b.tag = 1
            b.frame = CGRect(x: bounds.width - 10 - colorBtnW, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            b.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
            return b
        }()
        var btns : [UIButton]{return [blue,yellow ]}

        var selectColorIndex = -1
        
        @objc func btnClick(sender:UIButton){
            mylog(sender.title(for: UIControlState.normal))
            sender.isSelected = !sender.isSelected
            btns.forEach { (b) in
                if b != sender{b.isSelected = false }
            }
            if sender.isSelected {
                selectColorIndex = sender.tag
                model.value = "\(selectColorIndex + 1)"
            }else{selectColorIndex = -1}
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            yellow.frame = CGRect(x: bounds.width - 10 - colorBtnW, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            blue.frame = CGRect(x: yellow.frame.minX - colorBtnW, y: carColorTitle.frame.minY, width: colorBtnW, height: bounds.height)
            mylog(blue.title(for: UIControlState.normal))
        }
    }
}
