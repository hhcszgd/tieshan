//
//  ChaiCheRuKu2VC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/14.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ChaiCheRuKu2VC: DDNormalVC {
    let header = Bundle.main.loadNibNamed("DealDetailHeader", owner: "DealDetailHeader", options: nil)?.first as! DealDetailHeader
    var baseInfoModel = ChaiGuoDeCheVC.ItemModel()
    let chooseTitle = Bundle.main.loadNibNamed("TSSectionHeader", owner: "TSSectionHeader", options: nil)?.first as!  TSSectionHeader
    let choose11 = Bundle.main.loadNibNamed("ChooseType1", owner: "ChooseType1", options: nil)?.first as!  ChooseType1
    let choose12 = Bundle.main.loadNibNamed("ChooseType1", owner: "ChooseType1", options: nil)?.first as!  ChooseType1
    let tipsLabel = UILabel()
    let printButton = UIButton()
    
    var part1ApiModel = ApiModel<[ChoosePartModel]>()
    var part2ApiModel = ApiModel<[ChoosePartModel]>()
    var part1SelectedModel : ChoosePartModel?
    var part2SelectedModel : ChoosePartModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(header)
        view.addSubview(chooseTitle)
        view.addSubview(choose11)
        view.addSubview(choose12)
        view.addSubview(tipsLabel)
        view.addSubview(printButton)
        printButton.layer.cornerRadius = 4
        printButton.layer.masksToBounds = true
        printButton.backgroundColor = mainColor
        printButton.addTarget(self , action: #selector(printAction(_:)), for: UIControlEvents.touchUpInside)
        printButton.setTitle("打印", for: UIControlState.normal)
        tipsLabel.text = "● 打印的同时,就会进入库存"
        tipsLabel.textAlignment = .center
        tipsLabel.backgroundColor = .clear
        tipsLabel.frame = CGRect(x: 0, y: view.bounds.height - DDSliderHeight - 24, width: view.bounds.width, height: 40)
        printButton.frame = CGRect(x: 14, y: tipsLabel.frame.minY - 48, width: view.bounds.width - 14 * 2, height: 40)
        header.frame = CGRect(x: 10, y: DDNavigationBarHeight + 32, width: view.bounds.width - 20, height: 144)
        header.number.text = "编号: \(baseInfoModel.carNo ?? "")"
        header.carType.text = "车型: \(baseInfoModel.carName ?? "")"
        header.carNumber.text = "车牌号: \(baseInfoModel.carCode ?? "")"
        header.engineNumber.text = "VIN: \(baseInfoModel.vin ?? "")"
        header.arrivedTime.text = "拆解方式: \(baseInfoModel.dismantleWay ?? "")"
        chooseTitle.titleLabel.text = "选择打印的配件"
        chooseTitle.frame = CGRect(x: header.frame.minX + 10, y: header.frame.maxY, width: header.bounds.width, height: 44)
        choose11.frame = CGRect(x: header.frame.minX , y: chooseTitle.frame.maxY, width: header.bounds.width/2 - 10, height: 40)
        choose12.frame = CGRect(x: choose11.frame.maxX + 10, y: chooseTitle.frame.maxY, width: header.bounds.width/2 - 10, height: 40)
        
        let tap11 = UITapGestureRecognizer(target: self, action: #selector(tap11Event))
        choose11.addGestureRecognizer(tap11)
        
        let tap12 = UITapGestureRecognizer(target: self, action: #selector(tap12Event))
        choose12.addGestureRecognizer(tap12)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tap11Event(){
        mylog(#function)
        if part1ApiModel.data?.isEmpty ?? true {
            
            DDQueryManager.share.huoYiJiQuDaShuju(type: ApiModel<[ChoosePartModel]>.self) { (apiModel) in
                if apiModel.ret_code == "0"{
                    let alertModels = apiModel.data?.map({ (m) -> ChooseModel in
                        ChooseModel(title: m.parts_name ?? "", m.parts_code ?? "", id: m.id ?? "")
                    }) ?? []
                    let a = DDChooseAlert(models: alertModels )
                    a.confirmHandler = {[weak self] model in
                        mylog(model.title)
                        self?.part1SelectedModel = ChoosePartModel()
                        self?.part1SelectedModel?.id = model.id
                        self?.part1SelectedModel?.parts_code = model.subTitle
                        self?.part1SelectedModel?.parts_name = model.title
                        self?.choose11.textField.text = model.title
                        self?.choose12.textField.text = nil
                        self?.part2SelectedModel = nil
                    }
                    self.view.alert(a) { (alert) in
                        alert.subContainer.frame.origin.y = a.bounds.height + 10
                        UIView.animate(withDuration: 0.2) {
                            alert.subContainer.frame.origin.y = a.bounds.height * 0.7
                        }
                    }
                }
            }
        }else{
            let alertModels = part1ApiModel.data?.map({ (m) -> ChooseModel in
                ChooseModel(title: m.parts_name ?? "", m.parts_code ?? "", id: m.id ?? "")
            }) ?? []
            let a = DDChooseAlert(models: alertModels )
            a.confirmHandler = {[weak self] model in
                      self?.part1SelectedModel = ChoosePartModel()
                      self?.part1SelectedModel?.id = model.id
                      self?.part1SelectedModel?.parts_code = model.subTitle
                      self?.part1SelectedModel?.parts_name = model.title
                self?.choose11.textField.text = model.title
                self?.choose12.textField.text = nil
                self?.part2SelectedModel = nil
            }
            self.view.alert(a) { (alert) in
                alert.subContainer.frame.origin.y = a.bounds.height + 10
                UIView.animate(withDuration: 0.2) {
                    alert.subContainer.frame.origin.y = a.bounds.height * 0.7
                }
            }
        }
        
        
    }
    @objc func tap12Event(){
        mylog(#function)
        if part2ApiModel.data?.isEmpty ?? true {
            
            DDQueryManager.share.huoErJiQuDaShuju(type: ApiModel<[ChoosePartModel]>.self, id: self.part1SelectedModel?.id ?? "") { (apiModel) in
                if apiModel.ret_code == "0"{
                    let alertModels = apiModel.data?.map({ (m) -> ChooseModel in
                        ChooseModel(title: m.parts_name ?? "", m.parts_code ?? "", id: m.id ?? "")
                    }) ?? []
                    let a = DDChooseAlert(models: alertModels )
                    a.confirmHandler = {[weak self] model in
                        mylog(model.title)
                        self?.part2SelectedModel = ChoosePartModel()
                        self?.part2SelectedModel?.id = model.id
                        self?.part2SelectedModel?.parts_code = model.subTitle
                        self?.part2SelectedModel?.parts_name = model.title
                        self?.choose12.textField.text = model.title
                    }
                    self.view.alert(a) { (alert) in
                        alert.subContainer.frame.origin.y = a.bounds.height + 10
                        UIView.animate(withDuration: 0.2) {
                            alert.subContainer.frame.origin.y = a.bounds.height * 0.7
                        }
                    }
                }
            }
        }else{
            let alertModels = part2ApiModel.data?.map({ (m) -> ChooseModel in
                ChooseModel(title: m.parts_name ?? "", m.parts_code ?? "", id: m.id ?? "")
            }) ?? []
            let a = DDChooseAlert(models: alertModels )
            a.confirmHandler = {[weak self] model in
                      self?.part2SelectedModel = ChoosePartModel()
                      self?.part2SelectedModel?.id = model.id
                      self?.part2SelectedModel?.parts_code = model.subTitle
                      self?.part2SelectedModel?.parts_name = model.title
                self?.choose12.textField.text = model.title
            }
            self.view.alert(a) { (alert) in
                alert.subContainer.frame.origin.y = a.bounds.height + 10
                UIView.animate(withDuration: 0.2) {
                    alert.subContainer.frame.origin.y = a.bounds.height * 0.7
                }
            }
        }
        
    }
    func postPrintInfo()  {
           let para =
            ["partsName":self.part2SelectedModel?.parts_name ?? "","partsCode": part2SelectedModel?.parts_code ?? ""]
           
           DDQueryManager.share.printAndRuKu(type: ApiModel<String>.self, carInfoId: baseInfoModel.id ?? "", carCode: baseInfoModel.carCode ?? "", printInfo: [para]  ?? []) { (result ) in
               mylog(result.msg)
               if result.ret_code == "0"{
                   GDAlertView.alert(result.msg){self.navigationController?.popViewController(animated: true)}
               }else{
                   GDAlertView.alert(result.msg)
               }
           }
       }
    
    @objc func printAction(_ sender: UIButton) {
        if part2SelectedModel == nil {
            GDAlertView.alert("请选择")
            return
        }
        var actions = [DDAlertAction]()
         let sure = DDAlertAction(title: "确定",textColor:mainColor, style: UIAlertActionStyle.default, handler: { (action ) in
             print("打印")
            self.postPrintInfo()
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
    class ChoosePartModel:Codable {
        var parts_name : String?
        var parts_code : String?
        var id : String?
    }
}
