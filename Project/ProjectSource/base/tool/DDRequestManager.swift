
//  DDRequestManager.swift
//  ZDLao
//
//  Created by WY on 2019/9/17.
//  Copyright © 2019年 com.16lao. All rights reserved.
//app address : https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8
/*
 status = 1;
 id = 4;
 name = JohnLock;
 token = 5ebfcf173717960b25b270f06c401d20;
 avatar = http://f0.ugshop.cn/FilF9WGuUGZW5eX-WtfvpFoeTsaY;
 */

import UIKit
import Alamofire
import CoreLocation
import AliyunOSSiOS
enum DomainType : String  {
    //    case release  = "http://api.bjyltf.com/"
    case release  = "http://tpi.bjyltf.com/"
    case api = "http://39.106.225.64:8002/"
    
    //    case release = "https://api.bjyltf.com/"
    //    case wap = "https://tap.bjyltf.com/"
    case wap = "https://tap.bjyltf.com/"
}

extension DDQueryManager{
    // write your api here 👇
    //请求银行列表
    func getBankList<T>(type : ApiModel<T>.Type, failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "carSource/findBankNameList"
     
           return self.requestServer(type: type , method: HTTPMethod.get, url: url , encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    
    
    // 选择一级打印
    func huoYiJiQuDaShuju<T>(type : ApiModel<T>.Type, failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
          let url  =  "doCarsQuery/findFirstPartsName"
    
          return self.requestServer(type: type , method: HTTPMethod.get, url: url , encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
      }
    func huoErJiQuDaShuju<T>(type : ApiModel<T>.Type, id : String ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
          let url  =  "doCarsQuery/findSecondPartsName"
           let para = ["id" : id]
    
          return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
      }
    // 打印并入库
    func printAndRuKu<T>(type : ApiModel<T>.Type, carInfoId : String,carCode: String ,printInfo:[[String:String]] ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "doCarsQuery/addCarParts"
        let p : [String: Codable] = [
            "carInfoId":carInfoId,
            "carCode": carCode ,
            "partsStatus":"1",
            "data": printInfo
        ]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:p, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    
    //确定拆解
    //
    func queDingChaiJie<T>(type : ApiModel<T>.Type, carInfoId: String ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "doCarsQuery/updateDismantle"
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters: ["carInfoId":carInfoId], encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
    }
    // 获取打印名称
    func getPrintItems<T>(type : ApiModel<T>.Type ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "doCarsQuery/findPartsNameList"
        return self.requestServer(type: type , method: HTTPMethod.get, url: url, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    
    //拆过的件 doCarsQuery/selectCarPartsList
    func chaiGuoDeJian<T>(type : ApiModel<T>.Type , page : String? , pageSize : String? = "10",findMsg : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "doCarsQuery/selectCarPartsList"
        var para : [String : String] =  [ : ]
        if let p = page{para["page"] = p}
        if let p = pageSize{para["pageSize"] = p}
        if let p = findMsg{para["findMsg"] = p}
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
    }
    //待拆和已拆
    ///   1-待拆解，2-已拆解
    func daiChaiYiChai<T>(type : ApiModel<T>.Type , page : String? , pageSize : String? = "10", isDismantle:String = "1",searchInfo : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "doCarsQuery/selectIsDismantle"
        var para : [String : String] =  ["isDismantle":isDismantle]
        if let p = page{para["page"] = p}
        if let p = pageSize{para["pageSize"] = p}
        if let p = searchInfo{para["searchInfo"] = p}
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    
    ///isSuperviseSale : 1-监销，2-不监销
    func yiJianXiaoWeiJianXiao<T>(type : ApiModel<T>.Type,isSuperviseSale : String , page : String? , pageSize : String? = "10",findMsg : String?  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "doCarsQuery/findPreBreakCars"
         var para : [String : String] =  ["isSuperviseSale":isSuperviseSale]
              if let p = page{para["page"] = p}
              if let p = pageSize{para["pageSize"] = p}
              if let p = findMsg{para["findMsg"] = p}
        return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
    }
       ///返显已毁形图片
       ///
           func getImagesOfYiHuiXing<T>(type : ApiModel<T>.Type, carInfoId : String ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
              let url  =  "doCarsQuery/findPreBreakCarsById"
                var para : [String : Codable] =  ["carInfoId":carInfoId]
              return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
          }
    ///已毁形车辆列表
        func listOfYiHuiXing<T>(type : ApiModel<T>.Type, page : String? , pageSize : String? = "10",findMsg : String?  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/findBreakSuccessCars"
            var para : [String : String] =  [:]
                 if let p = page{para["page"] = p}
                 if let p = pageSize{para["pageSize"] = p}
                 if let p = findMsg{para["findMsg"] = p}
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    
    
    
    
    
    
    
    //
    ///完成毁形
       func wanChengTuoHuiXingImage<T>(type : ApiModel<T>.Type, carInfoId : String,status: String ,img: DaiHuiXingCheLiangStep2VC.ItemModel ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/addBreakPic"
               var d = [String:String]()
               d["filed_name"] = img.file_name ?? ""
               d["fileUrl"] = img.file_url ?? ""
               d["first_type"] = img.first_type ?? ""
               d["two_type"] = img.two_type ?? ""
             
               let p : [String: Codable] = [
                   "carInfoId":carInfoId,
                   "status":status,
                   "data": [d]
           ]
           return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:p, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
       }
       ///返显huixing图片
       ///
           func getImagesOfHuiXing<T>(type : ApiModel<T>.Type, carInfoId : String ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
              let url  =  "doCarsQuery/findPreBreakCarsById"
                var para : [String : Codable] =  ["carInfoId":carInfoId]
              return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
          }
    ///等待毁形
        func daiHuiXing<T>(type : ApiModel<T>.Type, page : String? , pageSize : String? = "10",findMsg : String?  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/findPreBreakCars"
            var para : [String : String] =  [:]
                 if let p = page{para["page"] = p}
                 if let p = pageSize{para["pageSize"] = p}
                 if let p = findMsg{para["findMsg"] = p}
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    
    
    
    
    //确定存放位置
    func confirmCunFangWeiZhi<T>(type : ApiModel<T>.Type, id  : String,carLocationArea: String = "1" ,carLocationRow: String = "1" ,  carLocationColumn : String = "1" ,carLocationNumber : String = "1" ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "carSource/editCarInfoLocation"
            var d = [String:String]()
            d["id"] = id
            d["carLocationArea"] = carLocationArea
            d["carLocationRow"] = carLocationRow
            d["carLocationColumn"] = carLocationColumn
          d["carLocationNumber"] = carLocationNumber
    
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:d, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    /// 获取区 排 个数 层数
    func huoQuCunFangWeiZhiXinXi<T>(type : ApiModel<T>.Type, id : String ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
          let url  =  "carSource/selectLocationListByPid"
           let para = ["id" : id]
    
          return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
      }
    //确定拆解方式
    func confirmChaiJieFangShi<T>(type : ApiModel<T>.Type, carInfoId : String, dismantleWay: String  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
              let url  =  "doCarsQuery/dismantleWay"
               let para = ["carInfoId" : carInfoId,"dismantleWay":dismantleWay]
        
              return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
          }
    ///获取车辆初检图片(拆解时)
    func getCarImageWhenChaiJie<T>(type : ApiModel<T>.Type, carInfoId : String  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/findPrePicById"
            let para = ["carInfoId" : carInfoId]
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    ///获取车辆初检信息(拆解时)
    func getCarInfoWhenChaiJie<T>(type : ApiModel<T>.Type, carInfoId : String  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/findSurveyById"
            let para = ["carInfoId" : carInfoId]
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    ///存放列表
    //
    func cunFangWeiZhiLiebiao<T>(type : ApiModel<T>.Type, page : String? , pageSize : String? = "10",findMsg : String?  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "carSource/selectCarInfoListByDisintegratePlantId"
            var para : [String : String] =  [:]
                 if let p = page{para["page"] = p}
                 if let p = pageSize{para["pageSize"] = p}
                 if let p = findMsg{para["findMsg"] = p}
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    ///拆解列表
    //
    func chaiJieLiebiao<T>(type : ApiModel<T>.Type, page : String? , pageSize : String? = "10",findMsg : String?  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/findDismantleCars"
            var para : [String : String] =  [:]
                 if let p = page{para["page"] = p}
                 if let p = pageSize{para["pageSize"] = p}
                 if let p = findMsg{para["findMsg"] = p}
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    ///暂存或完成拓号doCarsQuery/addTuoPic
    func wanChengTuoHaoImage<T>(type : ApiModel<T>.Type, carInfoId : String,status: String ,img: DengDaiTuoHaoStep2.ItemModel ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "doCarsQuery/addTuoPic"
            var d = [String:String]()
            d["filed_name"] = img.file_name ?? ""
            d["fileUrl"] = img.file_url ?? ""
            d["first_type"] = img.first_type ?? ""
            d["two_type"] = img.two_type ?? ""
          
            let p : [String: Codable] = [
                "carInfoId":carInfoId,
                "status":status,
                "data": [d]
        ]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:p, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
    }
    ///返显拓号图片
    ///
        func getImagesOfTuoHao<T>(type : ApiModel<T>.Type, carInfoId : String ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/findCpTuoPic"
             var para : [String : Codable] =  ["carInfoId":carInfoId]
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    ///等待拓号
        func dengDaiTuoHao<T>(type : ApiModel<T>.Type, page : String? , pageSize : String? = "10",findMsg : String?  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/findCopyNumberCars"
            var para : [String : String] =  [:]
                 if let p = page{para["page"] = p}
                 if let p = pageSize{para["pageSize"] = p}
                 if let p = findMsg{para["findMsg"] = p}
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    ///
    /// 车辆预处理图片暂存于完成
    func wanChengChuJianImage<T>(type : ApiModel<T>.Type, para : ChuJianStep2VC.ZanCunBaoCunModel ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
            let url  =  "doCarsQuery/addPrePic"
        var a = para.data.map { (m ) -> [String:String] in
            var d = [String:String]()
            d["filed_name"] = m.filed_name ?? ""
            d["fileUrl"] = m.fileUrl ?? ""
            d["first_type"] = m.first_type ?? ""
            d["two_type"] = m.two_type ?? ""
            return d
        }
            let p : [String: Codable] = [
                "carInfoId":para.carInfoId,
                "status":para.status,
                "data":a
        ]
            return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:p, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
        }
    
    /// ///获取车辆预处理车辆图片
    ///
    func getImagesOfYuChuLi<T>(type : ApiModel<T>.Type, carInfoId : String ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/doFindCars"
             var para : [String : Codable] =  ["carInfoId":carInfoId]
           return self.requestServer(type: type , method: HTTPMethod.get, url: url, parameters: para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    
    // doCarsQuery/findPretreatmentCars 等待预处理
    func dengDaiYuChuLi<T>(type : ApiModel<T>.Type, page : String? , pageSize : String? = "10", state:String? = nil,findMsg : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "doCarsQuery/findPretreatmentCars"
            var para : [String : String] =  [:]
           if let p = page{para["page"] = p}
           if let p = pageSize{para["pageSize"] = p}
           if let p = findMsg{para["findMsg"] = p}
           return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    
    /*
    车辆初检完成
    /carSource/editCarSurveyComplete*/
        func wanChengChuJianInfo<T>(type : ApiModel<T>.Type, para : [String:Codable] ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
            let url  =  "carSource/editCarSurveyComplete"
    //        let para : [String: Codable] = [:]
            return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
        }
    
    
    
  /*车辆初检的暂存
  请求URL：

  /carSource/editCarSurvey
  请求方式：

  POST （json格式传参）*/
    ///暂存初检信息,有值则返显
    func zanCunChuJianInfo<T>(type : ApiModel<T>.Type, para : [String:Codable] ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "carSource/editCarSurvey"
//        let para : [String: Codable] = [:]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    
    
    ///初检信息,有值则返显
    func chuJianInfo<T>(type : ApiModel<T>.Type, id : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "carSource/selectCarSurveyByCarInfoId"
        let para = ["id" : Int(id ?? "0") ]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
    }
    //暂时未用到
    func cheLiangJiBenXinXi<T>(type : ApiModel<T>.Type, id : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "carSource/selectCarInfoByIdAndCarEnter"
            let para = ["id" : id]
           return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    func dengDaiChuJian<T>(type : ApiModel<T>.Type, page : String? , pageSize : String? = "10", state:String? = nil,findMsg : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
           let url  =  "carSource/selectCarInfoByIsInitialSurvey"
            var para : [String : String] =  [:]
           if let p = page{para["page"] = p}
           if let p = pageSize{para["pageSize"] = p}
           if let p = findMsg{para["findMsg"] = p}
           return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
       }
    
    func ruChang<T>(type : ApiModel<T>.Type,carNo : String , cardColor : String , selfWeight: String ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "carSource/insertCarSurveyPart"
        let para =  [
            "carNo":carNo,
            "cardColor": cardColor,
            "selfWeight" : selfWeight
        ]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    
    func addCar<T>(type : ApiModel<T>.Type,para : [String:Codable],failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "carSource/addCar"
//        var para : [String : String] =  [:]
//        if let p = page{para["page"] = p}
//        if let p = pageSize{para["pageSize"] = p}
//        if let p = state{para["state"] = p}
//        if let p = findMsg{para["findMsg"] = p}
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
    }
    
            @discardableResult
        /// 后勤部
        /// state： 1-待入场状态 2-待核档状态 3-待商委注销状态 4-待领取残值状态 5-待报废状态 6-报废成功 7-核档未通过 查全部的状态不用传状态码，就是查全部状态的
    func carListOfCheYuan<T>(type : ApiModel<T>.Type,id : String , page : String? , pageSize : String? = "10", state:String? = nil,findMsg : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
            let url  =  "carSource/selectCarInfoListApp"
            var para : [String : String] =  ["id":id]
            if let p = page{para["page"] = p}
            if let p = pageSize{para["pageSize"] = p}
            if let p = state{para["state"] = p}
            if let p = findMsg{para["findMsg"] = p}
            return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
        }
    
    
        @discardableResult
    /// 后勤部
    ///     int    1：未核档(暂存)，2：已核档，3：核档不通过
    func cheYuanList<T>(type : ApiModel<T>.Type , page : String? , pageSize : String? = "10", isVerify:String? = "1",searchInfo : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "carSource/selectCarSourceList"
        var para : [String : String] =  [:]
        if let p = page{para["page"] = p}
        if let p = pageSize{para["pageSize"] = p}
//        if let p = isVerify{para["isVerify"] = p}
        if let p = searchInfo{para["searchInfo"] = p}
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para, encoding: URLEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    /// 创建车源
    func chuangJianCheYuan<T>(type : ApiModel<T>.Type , para : [String : String] ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "carSource/addCarSource"
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    /// 后勤部
    ///     int    1：未核档(暂存)，2：已核档，3：核档不通过
    func heDangJiLu<T>(type : ApiModel<T>.Type , page : String? , pageSize : String? = "10", isVerify:String? = "1",searchInfo : String? ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "procedures/queryAppVerificationList"
        var para : [String : String] =  [:]
        if let p = page{para["page"] = p}
        if let p = pageSize{para["pageSize"] = p}
        if let p = isVerify{para["isVerify"] = p}
        if let p = searchInfo{para["searchInfo"] = p}
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para, encoding: JSONEncoding.default , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    func login<T>(type : ApiModel<T>.Type , userName : String , passWord : String, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "auth/login"
        let para = ["username" : userName , "password": passWord,"type":"1"]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para  , needToken : false , success: success, failure: failure, complate: complate)
    }
    @discardableResult
    func getProfileInfo<T>(type : ApiModel<T>.Type, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "user/getUserInfo"//TODO 1 要改成真是的memberID
        let para = ["token" : DDAccount.share.token ?? ""]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,headerParas : para , success: success, failure: failure, complate: complate)
    }
    @discardableResult
    func modifyAvatar<T>(type : ApiModel<T>.Type,head_url: String,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "user/upHeadUrl"
        let para = ["head_url" : head_url]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters: para , success: success, failure: failure, complate: complate)
        
    }
    @discardableResult
    func modifyPassword<T>(type : ApiModel<T>.Type, old: String , new: String,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "auth/uppssword"//TODO 1 要改成真是的memberID
        let para = ["password" : new , "oldPassword": old]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters: para , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    func modifyName<T>(type : ApiModel<T>.Type,name: String,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil , success:@escaping (ApiModel<T>)->() ) -> DataRequest? {
        let url  =  "user/upName"
        let para = ["user_name" : name]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters: para , success: success, failure: failure, complate: complate)
        
    }
    
}
extension DDQueryManager {
    /// https://help.aliyun.com/document_detail/32058.html?spm=a2c4g.11186623.2.16.36764352bmTrH9
    
    //https://ts-ios-bucket.oss-cn-beijing.aliyuncs.com/landscape-painting.jpeg
    func uploadImageToAliyun(image:UIImage, process : OSSNetworkingUploadProgressBlock? = nil ,failure:( (_ error:Error)->Void)? = nil , success:@escaping (String)->() ) ->  OSSTask<AnyObject> {
        let data = UIImagePNGRepresentation(image)!
        let put = OSSPutObjectRequest()
        put.bucketName = bucket
        let imgName = createImgName()
        put.objectKey = imgName
        put.uploadingData = data
        if let p = process{
            put.uploadProgress = p
        }else{
            put.uploadProgress = {(bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                print("bytesSent:\(bytesSent),totalBytesSent:\(totalBytesSent),totalBytesExpectedToSend:\(totalBytesExpectedToSend)");
            }
        }
        let task = aliyunclient.putObject(put)
        task.continue({ (t) -> Any? in
            //            self.showResult(task: t)
            if (t.error != nil) {
                failure?(t.error!)
                mylog(t.error!)
                //                self.ossAlert(title: "error", message: error.description)
            }else
            {
//                OSSPutObjectResult: OSSResult
//                if let result = t.result as? OSSPutObjectResult{
//                    mylog(result.serverReturnJsonString)
//                }
                let imgUrl = "https://\(self.bucket).oss-cn-beijing.aliyuncs.com/\(imgName)"
                mylog("😃 \(imgUrl)")
                success(imgUrl)
            }
            return nil
        })//.waitUntilFinished()
        return task
    }
    func createImgName() -> String {
        var fileNameInServer = "\(Date().timeIntervalSince1970 )"
        if fileNameInServer.contains("."){
            if let index = fileNameInServer.index(of: "."){
                fileNameInServer.remove(at: index)
            }
        }
        return fileNameInServer + ".jpeg"
    }
    func createBukets() {
        
        let create = OSSCreateBucketRequest()
        create.bucketName = "ts-ios-bucket";
        create.xOssACL = "public-read-write";
        create.location = "oss-cn-beijing";
        
        let createTask = aliyunclient.createBucket(create)
        createTask.continue ({ (task ) -> Any? in
            if (task.error == nil) {
                NSLog("create bucket success!");
            } else {
                mylog("create bucket failed, error:😂 \(task.error)" );
            }
            return nil
        })
        
    }
    func showFileOf(bucket:String = "ts-ios-bucket"){
        let getBucket = OSSGetBucketRequest()
        getBucket.bucketName = bucket
        // getBucket.marker = @"";
        // getBucket.prefix = @"";
        // getBucket.delimiter = @"";
        let getBucketTask = aliyunclient.getBucket(getBucket)
        getBucketTask.continue ({ (task ) -> Any? in
            if (task.error == nil ) {
                let result = task.result;
                mylog("get bucket success!😃 \(result)");
                //                for  objectInfo in result.contents {
                //                    mylog("list object: \(bojectInfo)");
                //                }
            } else {
                mylog("get bucket failed, error:😂\(task.error)" );
            }
            return nil;
        })
    }
    
    func getBukets() {
        
        let getService = OSSGetServiceRequest()
        let getservicetask = aliyunclient.getService(getService)
        getservicetask.continue ({ (t) -> Any? in
            if t.error != nil {mylog(t.error)}else{
                let result = t.result
                mylog(result)
                mylog(t)
            }
            return nil
        })
        
        
    }
}
class DDQueryManager: NSObject {
    lazy var endpoint = "https://oss-cn-beijing.aliyuncs.com"
    lazy var accessKey = "LTAIfjRRZiTek2Cp"
    //    lazy var bucket = "ts－disintegrate"
    //    lazy var bucket = "ssbbctalk"
    lazy var bucket = "ts-ios-bucket"
    lazy var secretKey = "PsdzkH2zJVAVQu1iBuMnuPNkKgnAo0"
    lazy var provider = OSSStsTokenCredentialProvider(accessKeyId: accessKey, secretKeyId: secretKey, securityToken: "")
    lazy var aliyunclient = OSSClient(endpoint: endpoint, credentialProvider: provider)
    
    
    
    let version = ""
    var sessionManager : SessionManager!
    var token : String? = "token"
    let client = COSClient.init(appId: "1255626690", withRegion: "hk")
    static let share : DDQueryManager = {
        
        let man = DDQueryManager()
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval.init(10)
        let sessionDelegate = SessionDelegate()
        let urlSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
        man.sessionManager = SessionManager.init(session: urlSession, delegate: sessionDelegate)
        let time = man.sessionManager.session.configuration.timeoutIntervalForRequest
        mylog(time )
        return man
    }()
    var networkStatus : (oldStatus : Bool , newStatus : Bool ) =  (oldStatus : false , newStatus : false )
    lazy var networkReachabilityManager: NetworkReachabilityManager? = {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = {status in
            self.networkStatus.oldStatus = self.networkStatus.newStatus
            switch status {
            case .notReachable:
                mylog("1")
                GDAlertView.alert("network_error_try_again" , image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .unknown :
                mylog("2")
                GDAlertView.alert("network_error_try_again" , image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                mylog("3")
                self.networkStatus.newStatus = true
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                self.networkStatus.newStatus = true
                mylog("4")
                break
            }
            NotificationCenter.default.post(name: NSNotification.Name("DDNetworkChanged"), object: nil, userInfo: ["status":self.networkStatus])
        }
        return reachabilityManager
    }()
    
}



extension DDQueryManager{
    
    
    
    
    //    @discardableResult
    //    private func requestApi<T:Codable>(type : ApiModel<T>.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil  , needToken: Bool  = true,autoAlertWhileFailure : Bool = true  , success: @escaping (T)->(),failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
    //        self.request(type: type, method: method, url: url, parameters: parameters, needToken: needToken, autoAlertWhileFailure: autoAlertWhileFailure, success: success, failure: failure, complate: complate)
    //    }
    //
    
    
    /// request server api
    ///
    /// - Parameters:
    ///   - type: model type
    ///   - method: request method
    ///   - url: url
    ///   - parameters: parameters
    ///   - failure: invoke when mistakes
    ///   - success: invoke when success
    ///   - complate: invoke always (failure or success)
    
    private func requestServer<T>(type : ApiModel<T>.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil ,headerParas:HTTPHeaders? = nil , needToken: Bool  = true,autoAlertWhileFailure : Bool = true, encoding: ParameterEncoding = URLEncoding.default  , success:@escaping (ApiModel<T>)->(),failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
        //        let result = networkReachabilityManager?.startListening()
        //        mylog("是否  监听  成功  \(result)")
        mylog("\(networkReachabilityManager?.networkReachabilityStatus)")
        if let status = networkReachabilityManager?.isReachable , !status {
            ////            GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
            failure?(DDError.networkError)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("network_error_try_again" , image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
        
        let urlFull = DomainType.api.rawValue + version + url
        var para = Parameters()
        var header = [String : String]()
        if let h = headerParas{header = h}
        if let parametersUnwrap = parameters{para = parametersUnwrap}
        //        para["l"] = DDLanguageManager.languageIdentifier
        //        para["c"] = DDLanguageManager.countryCode
//        para["l"] = "110"
        //        if urlFull != DomainType.api.rawValue + "Initkey/rest"{//初始化接口不需要token
        if needToken {
            if let tokenReal = DDAccount.share.token {
                header[ "token"] =  tokenReal
            }else{
                
                
                mylog("token is nil")
                failure?(DDError.noToken)
                complate?()
                if autoAlertWhileFailure {
                    GDAlertView.alert("token为空,请退出并重新登录", image: nil, time: 2, complateBlock: nil)
                }
                return nil
            }
        }
        
        //            if let tokenReal = DDAccount.share.token {
        //                para["token"] = tokenReal
        //            }else{
        //
        //
        //                mylog("token is nil")
        //                failure?(DDError.noToken)
        //                complate?()
        //                return nil
        //            }
        //        }
        
        //        let language = DDLanguageManager.countryCode
//        let language = "110"
//        header["APPID"] = "2"
//        header["VERSIONMINI"] = "20160501"
//        header["DID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        header["VERSIONID"] = "2.0"
//        header["language"] = language
//        header[ "token"] = DDAccount.share.token ?? ""
        //        header["Content-Type"] = "application/json"
        //        header["Accept"] = "application/json"
        if let url  = URL(string: urlFull){
            let task = DDQueryManager.share.sessionManager.request(url , method: method , parameters: para ,encoding: encoding , headers:header).responseJSON(completionHandler: { (response) in
                //                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    
                    if let a = DDJsonCode.decodeAlamofireResponse(ApiModel<T>.self, from: response){
                        success(a)
                        complate?()
                    }else{
                        failure?(DDError.modelUnconvertable)
                        complate?()
                        if autoAlertWhileFailure {
                            GDAlertView.alert("server_data_type_error" , image: nil, time: 2, complateBlock: nil)
                        }
                    }
                    //                    if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
                    //                        success(a)
                    //                        complate?()
                    //                    }else{
                    //                        failure?(DDError.modelUnconvertable)
                    //                        complate?()
                //                    }
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    mylog(response.result.error?.localizedDescription)
                    if let error = response.result.error as? NSError{
                        if error.code == -1001{
                            failure?(DDError.serverError("request_time_out" ))
                            if autoAlertWhileFailure {
                                GDAlertView.alert("request_time_out" , image: nil, time: 2, complateBlock: nil)
                            }
                        }else if error.code == -999{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("cancle_request" , image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError("cancle_request" ))
                        }else{
                            if let errorMsg = response.result.error?.localizedDescription {
                                failure?(DDError.serverError(errorMsg))
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("server_side_error" , image: nil, time: 2, complateBlock: nil)
                                }
                            }else{
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("server_side_error" , image: nil, time: 2, complateBlock: nil)
                                }
                                failure?(DDError.otherError(nil))
                            }
                        }
                    }else{
                        if let errorMsg = response.result.error?.localizedDescription {
                            if autoAlertWhileFailure {
                                GDAlertView.alert("server_side_error" , image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError(errorMsg))
                        }else{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("server_side_error" , image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.otherError(nil))
                        }
                    }
                    complate?()
                }
            })
            return task
        }else{
            failure?(DDError.urlUnconvertable)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("url不合法", image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    @discardableResult
    private func request<T:Codable>(type : T.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil  , needToken: Bool  = true,autoAlertWhileFailure : Bool = true  , success:@escaping (T)->() ,failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
        //        let result = networkReachabilityManager?.startListening()
        //        mylog("是否  监听  成功  \(result)")
        mylog("\(networkReachabilityManager?.networkReachabilityStatus)")
        if let status = networkReachabilityManager?.isReachable , !status {
            ////            GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
            failure?(DDError.networkError)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("network_error_try_again" , image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
        
        let urlFull = DomainType.api.rawValue + version + url
        var para = Parameters()
        if let parametersUnwrap = parameters{para = parametersUnwrap}
        //        para["l"] = DDLanguageManager.languageIdentifier
        //        para["c"] = DDLanguageManager.countryCode
        para["l"] = "110"
        //        if urlFull != DomainType.api.rawValue + "Initkey/rest"{//初始化接口不需要token
        if needToken {
            if let tokenReal = DDAccount.share.token {
                para["token"] = tokenReal
            }else{
                
                
                mylog("token is nil")
                failure?(DDError.noToken)
                complate?()
                if autoAlertWhileFailure {
                    GDAlertView.alert("token为空,请退出并重新登录", image: nil, time: 2, complateBlock: nil)
                }
                return nil
            }
        }
        
        //            if let tokenReal = DDAccount.share.token {
        //                para["token"] = tokenReal
        //            }else{
        //
        //
        //                mylog("token is nil")
        //                failure?(DDError.noToken)
        //                complate?()
        //                return nil
        //            }
        //        }
        
        //        let language = DDLanguageManager.countryCode
        let language = "110"
        var header = [String : String]()
//        header["APPID"] = "2"
//        header["VERSIONMINI"] = "20160501"
//        header["DID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        header["VERSIONID"] = "2.0"
//        header["language"] = language
        
        if let url  = URL(string: urlFull){
            let task = DDQueryManager.share.sessionManager.request(url , method: method , parameters: para , headers:header).responseJSON(completionHandler: { (response) in
                //                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    if let a = DDJsonCode.decode(T.self, from: response.data){
                        //                    if let a = DDJsonCode.decodeAlamofireResponse(T.self, from: response){
                        success(a)
                        complate?()
                    }else{
                        failure?(DDError.modelUnconvertable)
                        complate?()
                        if autoAlertWhileFailure {
                            GDAlertView.alert("server_data_type_error" , image: nil, time: 2, complateBlock: nil)
                        }
                    }
                    //                    if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
                    //                        success(a)
                    //                        complate?()
                    //                    }else{
                    //                        failure?(DDError.modelUnconvertable)
                    //                        complate?()
                //                    }
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    mylog(response.result.error?.localizedDescription)
                    if let error = response.result.error as? NSError{
                        if error.code == -1001{
                            failure?(DDError.serverError("request_time_out" ))
                            if autoAlertWhileFailure {
                                GDAlertView.alert("request_time_out" , image: nil, time: 2, complateBlock: nil)
                            }
                        }else if error.code == -999{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("cancle_request" , image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError("cancle_request" ))
                        }else{
                            if let errorMsg = response.result.error?.localizedDescription {
                                failure?(DDError.serverError(errorMsg))
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("server_side_error" , image: nil, time: 2, complateBlock: nil)
                                }
                            }else{
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("server_side_error" , image: nil, time: 2, complateBlock: nil)
                                }
                                failure?(DDError.otherError(nil))
                            }
                        }
                    }else{
                        if let errorMsg = response.result.error?.localizedDescription {
                            if autoAlertWhileFailure {
                                GDAlertView.alert("server_side_error" , image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError(errorMsg))
                        }else{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("server_side_error" , image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.otherError(nil))
                        }
                    }
                    complate?()
                }
            })
            return task
        }else{
            failure?(DDError.urlUnconvertable)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("url不合法", image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
    }
    
    func convertTime(time:String) -> String{
        if time.contains("date_year" ){
            let dataFormate = DateFormatter()
            dataFormate.dateFormat = "yyyy\("date_year" )MM\("date_month" )dd\("date_day" )"
            let rempDate = dataFormate.date(from: time)
            dataFormate.dateFormat = "yyyy-MM-dd"
            let string = dataFormate.string(from: rempDate ?? Date())
            return string
        }else{
            return time
        }
    }
    
    
}



























































class DDRequestManager: NSObject {
    let version = "v1/"
    //    let version = "v\(DDCurrentAppVersion)/"
    
    let client = COSClient.init(appId: "1255626690", withRegion: "sh")
    var token : String? = "token"
    static let share : DDRequestManager = {
        
        
        let mgr = DDRequestManager()
        //        mgr.result.session.configuration.timeoutIntervalForRequest = 10
        return mgr
    }()
    var networkStatus : (oldStatus : Bool , newStatus : Bool ) =  (oldStatus : false , newStatus : false )
    
    lazy var networkReachabilityManager: NetworkReachabilityManager? = {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = {status in
            self.networkStatus.oldStatus = self.networkStatus.newStatus
            switch status {
            case .notReachable:
                mylog("1")
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .unknown :
                mylog("2")
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                mylog("3")
                self.networkStatus.newStatus = true
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                self.networkStatus.newStatus = true
                mylog("4")
                break
            }
            NotificationCenter.default.post(name: NSNotification.Name("DDNetworkChanged"), object: nil, userInfo: ["status":self.networkStatus])
        }
        return reachabilityManager
    }()
    //    let result = SessionManager.default
    private func performRequest(url : String,method:HTTPMethod , parameters: Parameters? ,  print : Bool = false  ) -> DataRequest? {
        
        if let status = networkReachabilityManager?.networkReachabilityStatus{
            switch status {
            case .notReachable:
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .unknown :
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                break
            }
        }
        
        
        var parameters = parameters == nil ? Parameters() : parameters!
        parameters["l"] = DDLanguageManager.languageIdentifier
        parameters["c"] = DDLanguageManager.countryCode
        //        let url = replaceHostSurfix(urlStr: url, surfix: hostSurfix)
        let url = (DomainType.release.rawValue + version) + url
        if let url  = URL(string: url){
            let result = Alamofire.request(url , method: method , parameters: parameters ).responseJSON(completionHandler: { (response) in
                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    break
                    
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    GDAlertView.alert("请求失败,请重试", image: nil , time: 2, complateBlock: nil )//请求超时处理
                    break
                }
            })
            return result
            
            //                .responseJSON(completionHandler: { (response) in
            //                mylog(String.init(data: response.data ?? Data(), encoding: String.Encoding.utf8))
            //                mylog("print request result -->:\(response.result)")
            //                "xx".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            //                let testOriginalStr = "http://www.hailao.com/你好世界"
            //                let urlEncode = testOriginalStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            //                let urlDecodeStr = urlEncode?.removingPercentEncoding
            //                mylog("encode : \(urlEncode)")
            //                mylog("decode : \(urlDecodeStr)")
            //
            //                let tt = "\\U751f\\U6210key\\U6210\\U529f"
            ////                mylog("tttt\(tt.u)")
            //            })
        }else{return nil }
    }
    private  func replaceHostSurfix( urlStr : String , surfix : String = "cn") -> String {
        //        var urlStr = "http://www.baidu.com/fould/tindex.html?name=name"
        var urlStr  = urlStr
        if let url = URL(string: urlStr) {
            var host = url.host ?? ""
            let http = url.scheme ?? "" //http or https
            let index = host.index(host.endIndex, offsetBy: -3)
            let willReplaceStr = "\(http)://\(host)"
            let willReplaceRange = willReplaceStr.startIndex..<willReplaceStr.endIndex
            host.removeSubrange(index..<host.endIndex)
            if !host.hasSuffix("."){host = "\(host)."}
            host.append(contentsOf: surfix)
            let destinationStr  = "\(http)://\(host)"
            urlStr.replaceSubrange(willReplaceRange, with: destinationStr)
            mylog("converted:\(urlStr)")
        }
        return urlStr
    }
    
    
    /// getDianGongInfo
    @discardableResult
    func getDianGongInfo( _ print : Bool = false ) -> DataRequest? {
        dump(DDAccount.share)
        let url  =  "member/\(DDAccount.share.id ?? "0")/cert"//TODO 1 要改成真是的memberID
        var para = ["token" : DDAccount.share.token ?? ""]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// changeDianGongInfo
    @discardableResult
    func changeDianGongInfo(parameters : (electrician_certificate_number : String , electrician_certificate_level : String , electrician_certificate_front_image : String , electrician_certificate_back_image : String , professional_name : String) ,  _ print : Bool = false ) -> DataRequest? {
        dump(DDAccount.share)
        let url  =  "member/\(DDAccount.share.id ?? "0")/cert"//TODO 1 要改成真是的memberID
        var para = ["token" : DDAccount.share.token ?? ""]
        para["electrician_certificate_number"] = parameters.electrician_certificate_number
        para["electrician_certificate_level"] = parameters.electrician_certificate_level
        para["electrician_certificate_front_image"] = parameters.electrician_certificate_front_image
        para["electrician_certificate_back_image"] = parameters.electrician_certificate_number
        para["professional_name"] = parameters.professional_name
        return  performRequest(url: url , method: HTTPMethod.put, parameters: para , print : print )
    }
    /*
     getPublicKey
     */
    @discardableResult
    private func getPublicKey(_ print : Bool = false ) -> DataRequest? {
        let url  =  "system/public-key"
        //        "40d1783fbb98f6ed3b17c661786d5edf"
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let para = ["device_number" : deviceID  , "type" : "ios"] as [String : Any]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    func getPublickKey(publicKey :@escaping (String?) -> Void)  {
        if let tempPublicKey = UserDefaults.standard.value(forKey: "Public_Key") as? String{
            publicKey(tempPublicKey)
        }else{
            DDRequestManager.share.getPublicKey()?.responseJSON(completionHandler: { (response ) in
                //                dump(response.value)
                if let result = DDJsonCode.decodeAlamofireResponse(ApiModel<PublickKeyModel>.self, from: response), let tempPublicKey = result.data?.public_key{
                    let salt = "1sA5d1gPPms8Oolos"
                    let headerToken = ( tempPublicKey + salt).md5()
                    UserDefaults.standard.setValue(headerToken, forKey: "Public_Key")
                    print("get public key success\(headerToken)")
                    publicKey(headerToken)
                }else{
                    print("get public key failure")
                    publicKey(nil)
                }
                //            dump(response)
            })
        }
        
    }
    
    /*
     check version
     */
    @discardableResult
    func checkLatestAppVersion(_ print : Bool = false ) -> DataRequest? {
        let url  =  "version"
        //        "40d1783fbb98f6ed3b17c661786d5edf"
        let para = ["token" : DDAccount.share.token ?? "" , "app_type" : "2"]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /*
     home page api
     */
    @discardableResult
    func homePage(_ print : Bool = false ) -> DataRequest? {
        let url  =  "index"
        //        "40d1783fbb98f6ed3b17c661786d5edf"
        let para = ["token" : DDAccount.share.token ?? ""]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    /*
     func edit page  api
     */
    @discardableResult
    func funcEditPage(_ print : Bool = false ) -> DataRequest? {
        let url  =  "function"
        let para = ["token" : DDAccount.share.token ?? ""]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /// ad view
    @discardableResult
    func advertApi( _ print : Bool = false ) -> DataRequest? {
        let url  =  "system/startup"//
        let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2.1"
        let para = ["token" : DDAccount.share.token ?? "","version":currentAppVersion] as [String : Any]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /// message page api
    @discardableResult
    func messagePage(keyword:String? = nil  , page : Int = 1, _ print : Bool = false ) -> DataRequest? {
        dump(DDAccount.share)
        let url  =  "member/\(DDAccount.share.id ?? "0")/message"//TODO 1 要改成真是的memberID
        var para = ["token" : DDAccount.share.token ?? "","page":page] as [String : Any]
        if let  keywordUnwrap = keyword{ para["keyword"] = keywordUnwrap }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// message page api
    @discardableResult
    func changeSquence(json:String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "function"
        let para = ["token" : DDAccount.share.token ?? "","function_content":json]
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    /// partnerPageApi
    @discardableResult
    func partnerPage(keyword : String? , level : String?,page : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/lower"//TODO 1 替换成真实memberID
        var para = ["token" : DDAccount.share.token ?? "","page":page ] as [String : Any]
        if let keyWord =  keyword {para["keyword"] = keyWord}
        if let level =  level {
            para["level"] = (level)
        }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    /// getPeixunInfo
    @discardableResult
    func getPeixunInfo(print : Bool = false ) -> DataRequest? {
        let url  =  "business-trainning"
        let para = ["token" : DDAccount.share.token ?? ""] as [String : Any]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    
    func downFile(complate:@escaping (String?) -> Void) {
        var fullPath = ""
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("xxx.pdf")
            //            let fileURL = documentsURL.appendPathComponent("pig.png")
            fullPath = fileURL.absoluteString
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\(documentsURL)")
        }
        let urlString = "http://i1.bjyltf.com/agreement/48.pdf"
        Alamofire.download(urlString, to: destination).response { response in
            print(response)
            print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\(response.destinationURL)")
            if response.error == nil, let filePath = response.destinationURL?.path {
                //                let image = UIImage(contentsOfFile: imagePath)
                complate(fullPath)
                print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\(filePath)")
                
            }else{
                complate(nil)
            }
        }
        
    }
    
    
    
    /// messageDetail
    @discardableResult
    func messageDetail(messageID:String, _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/message/\(messageID)"//TODO 1 替换成真实memberID
        let para = ["token" : DDAccount.share.token ?? "" ]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /// partnerDetail
    @discardableResult
    func partnerDetail(targetMemberID:String = "7" , page  : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/lower/\(targetMemberID)"//TODO 1 替换成真实memberID
        let para = ["token" : DDAccount.share.token ?? "" , "page" : "\(page)"]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// Achievement statistic page
    
    @discardableResult
    func achievementStatistic(create_at:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/account"//TODO 1 替换成真实memberID
        var  para = ["token" : DDAccount.share.token ?? ""]
        if let create_at_unwrap = create_at{
            para["create_at"] = create_at_unwrap
        }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// Achievement statistic page
    
    @discardableResult
    func newAchievementStatistic(create_at:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/account"//TODO 1 替换成真实memberID
        var  para = ["token" : DDAccount.share.token ?? ""]
        if let create_at_unwrap = create_at{
            para["create_at"] = create_at_unwrap
        }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// band bank card
    /// http://123.207.141.131/v1/member/<member_id>/bank
    
    @discardableResult
    func bandBankCard(ownName : String , cardNum:String , mobile:String , bankID : String , verify : String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/bank"//TODO 1 替换成真实memberID
        let  para = ["token" : DDAccount.share.token ?? "" , "bank_id" : bankID , "number" : cardNum , "mobile" : mobile ,"verify" : verify , "name":ownName]
        
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    /// get has banded bank card list
    @discardableResult
    func getBandkCard( _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/bank"//TODO 1 替换成真实memberID
        let  para = ["token" : DDAccount.share.token ?? "" ]
        
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// untie bank card
    @discardableResult
    func untieBankCard(bankID : String ,  print : Bool = false  ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/bank/\(bankID)"
        let  para = ["token" : DDAccount.share.token ?? "" ]
        return  performRequest(url: url , method: HTTPMethod.delete, parameters: para , print : print )
    }
    
    /// get bank brand name list
    @discardableResult
    func getBankBrandList( _ print : Bool = false ) -> DataRequest? {
        let url  =  "bank"//TODO 1 替换成真实memberID
        let  para = ["token" : DDAccount.share.token ?? "" ]
        
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /// get cash page
    @discardableResult
    func getCashPage( _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/withdraw"
        let  para = ["token" : DDAccount.share.token ?? "" ]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /// get cash action
    @discardableResult
    func getCashAction(bank_id :String , price:String , payment_password:String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/withdraw"
        let nsStr  = NSString.init(string: price)
        let priceFloat = nsStr.floatValue
        let  para = [
            "token" : DDAccount.share.token ?? "",
            "bank_id" :bank_id ,
            "price":"\(priceFloat)" ,
            "payment_password":payment_password
        ]
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    /// get jpush notification status
    @discardableResult
    func getNotificationStatus( _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/status"
        let  para = [
            "token" : DDAccount.share.token ?? ""
        ]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    /// set jpush notification status
    
    @discardableResult
    func setNotificationStatus(push_status:String? ,push_shock:String?,push_voice:String? , _ print : Bool = false ) -> DataRequest? {
        //        let url  =  "member/\(DDAccount.share.id ?? "")"
        let url  =  "member/\(DDAccount.share.id ?? "")/push"
        var  para = [
            "token" : DDAccount.share.token ?? ""
        ]
        if let pushStatus = push_status{para["push_status"] = pushStatus}
        if let pushShake = push_shock{para["push_shock"] = pushShake}
        if let pushVoice = push_voice{para["push_voice"] = pushVoice}
        return  performRequest(url: url , method: HTTPMethod.put, parameters: para , print : print )
    }
    /// get auth code
    /// type (1、注册 2、找回密码 3、其他)
    ///http://123.207.141.131/v1/verify
    @discardableResult
    func getAuthCode(type : String = "3" , mobile : String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "verify"//
        let  para = ["token" : DDAccount.share.token ?? "" , "type" : type , "mobile" : mobile]
        
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// getOrderList
    ///
    /// - Parameters:
    ///   - type: 订单状态(-1放弃支付 0待支付 1待补交 2预付款已逾期 3已完成) 为空全部订单
    ///   - page: 页码
    ///   - print: whether print responst data
    /// - Returns: return value
    @discardableResult
    func getOrderList(type : String? , page : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order"
        var  para = ["token" : DDAccount.share.token ?? "" , "page" : "\(page)"]
        //        var  para = ["token" : "e97d7946bb7ae016632ecdff7310262f" , "page" : "\(page)"]
        
        if let typeReal = type {para["type"] = typeReal}
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    @discardableResult
    func orderDetail(order_id : String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/\(order_id)"
        var  para = ["token" : DDAccount.share.token ?? ""]
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    @discardableResult
    func tousuDuijieren(order_id : String ,complain_level: String , complain_content:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/fcomplaint2"
        var  para = ["token" : DDAccount.share.token ?? "","complain_level":complain_level, "id" : order_id]
        if let content = complain_content{
            para["complain_content"] = content
        }
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    
    
    
    
    
    
    
    /// getOrderList
    ///
    /// - Parameters:
    ///   - type: 订单状态(-1放弃支付 0待支付 1待补交 2预付款已逾期 3已完成) 为空全部订单
    ///   - page: 页码
    ///   - print: whether print responst data
    /// - Returns: return value
    @discardableResult
    func saleManGetOrderList(type : String? , page : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order"
        var  para = ["token" : DDAccount.share.token ?? "" , "page" : "\(page)" , "order_list" : "1"]
        //        var  para = ["token" : "e97d7946bb7ae016632ecdff7310262f" , "page" : "\(page)"]
        
        if let typeReal = type {para["type"] = typeReal}
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    @discardableResult
    func saleManOrderDetail(order_id : String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/\(order_id)"
        var  para = ["token" : DDAccount.share.token ?? "", "order_list" : "1"]
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    @discardableResult
    func saleManTousuDuijieren(order_id : String ,complain_level: String , complain_content:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/fcomplaint"
        var  para = ["token" : DDAccount.share.token ?? "","complain_level":complain_level, "id" : order_id]
        if let content = complain_content{
            para["complain_content"] = content
        }
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    @discardableResult
    func changeSentTime(order_id : String ,start_at: String , end_at:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/orderdata/\(order_id)"
        var  para = ["token" : DDAccount.share.token ?? "","start_at":start_at, "order_id" : order_id]
        if let end = end_at{
            para["end_at"] = end
        }
        return  performRequest(url: url , method: HTTPMethod.put, parameters: para , print : print )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @discardableResult
    func tousuHezuoren(order_id : String ,complain_level: String , complain_content:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/fcomplaint3"
        var  para = ["token" : DDAccount.share.token ?? "","complain_level":complain_level, "id" : order_id]
        if let content = complain_content{
            para["complain_content"] = content
        }
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    @discardableResult
    func canclePay(order_id : String ,cancleRease: String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/ordercannel"
        var  para = ["token" : DDAccount.share.token ?? "","cancel_cause":cancleRease, "order_id" : order_id]
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.put, parameters: para , print : print )
    }
    
    
    
    @discardableResult
    func orderSelectedArea(order_id : String ,parent_id : String? , _ print : Bool = false, type: String? = "") -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/\(order_id)/area"
        var  para = ["token" : DDAccount.share.token ?? "" ]
        if let parentID = parent_id {
            para["parent_id"] = parentID
        }
        if (type != nil) && (type != "") {
            para["type"] = "1"
        }
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// request sign
    private func requestTencentSign( _ print : Bool = false ) -> DataRequest? {
        let url  =  "qcloud"
        let  para = [ "token": DDAccount.share.token ?? "" ]
        return performRequest(url: url , method: HTTPMethod.get, parameters: para, print : print )
    }
    
    
    /*
     let tenxunAppid = "1252043302"
     let tenxunAppKey = "2ae4806abe0f1ae393564456ff1130b5"
     let bukey: String = "hilao"
     let regin: String = "bj"
     http://api.hilao.cc/index/getTencentObjectStorageSignature
     post
     */
    func uploadMediaToTencentYun(image:UIImage ,progressHandler:@escaping ( Int,  Int, Int)->(),compateHandler : @escaping (_ imageUrl:String?)->())  {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath = docuPath  {
            var fileNameInServer = "\(Date().timeIntervalSince1970 )"
            if fileNameInServer.contains("."){
                if let index = fileNameInServer.index(of: "."){
                    fileNameInServer.remove(at: index)
                }
            }
            let filePath = realDocuPath + "/\(fileNameInServer).JPEG"
            let filePathUrl = URL(fileURLWithPath: filePath, isDirectory: true )
            mylog(filePath)
            do{
                let _ = try UIImageJPEGRepresentation(image, 0.5)?.write(to: filePathUrl)
                self.requestTencentSign(true)?.responseJSON(completionHandler: { (response) in
                    guard  let dict =  response.value as? [String:String] else{
                        compateHandler(nil); return}
                    let signStr = dict["token"]
                    let id = DDAccount.share.id ?? "0"
                    let uploadTask = COSObjectPutTask.init(path: filePath, sign: signStr, bucket: "yulongchuanmei", fileName: fileNameInServer + ".JPEG", customAttribute: "temp", uploadDirectory: "member/\(id)", insertOnly: true)
                    
                    self.client?.completionHandler = {(/*COSTaskRsp **/resp, /*NSDictionary */context) in
                        try? FileManager.default.removeItem(atPath: filePath)
                        if let  resp = resp as? COSObjectUploadTaskRsp{
                            //                            mylog(context)
                            //                            mylog(resp.descMsg)
                            //                            mylog(resp.fileData)
                            //
                            mylog(resp.data)
                            dump(resp)
                            mylog(resp.sourceURL)//发给服务器
                            mylog(resp.httpsURL)
                            mylog(resp.objectURL)
                            mylog(resp.retCode)
                            if (resp.retCode == 0) {
                                //sucess
                                compateHandler(resp.sourceURL)
                            }else{
                                
                                compateHandler("failure")
                                GDAlertView.alert("图片上传失败", image: nil, time: 1, complateBlock: nil)
                            }
                        }
                    };
                    self.client?.progressHandler = {( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        progressHandler(Int(bytesWritten), Int(totalBytesWritten), Int(totalBytesExpectedToWrite))
                        mylog("\(bytesWritten)---\(totalBytesWritten)---\(totalBytesExpectedToWrite)")
                        //progress
                    }
                    self.client?.putObject(uploadTask)
                    
                    
                })
                
                
                
                
            }catch{
                mylog(error)
                compateHandler(nil)
            }
            
            //            let filePath = realDocuPath.append//appendingPathComponent("Account.data")
        }
    }
    
    
    
    
    
    
    /// untie bank card
    func untieBankCard2(bankID : String ,  print : Bool = false  ) -> DataRequest? {
        if let status = NetworkReachabilityManager(host: "www.baidu.com")?.networkReachabilityStatus{
            switch status {
            case .notReachable:
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .unknown :
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                break
            }
        }
        
        
        let parameters = ["token" : DDAccount.share.token ?? "" ]
        let url = (DomainType.release.rawValue + version) + "member/\(DDAccount.share.id ?? "")/bank/\(bankID)"
        if let url  = URL(string: url){
            let result = Alamofire.request(url , method: HTTPMethod.delete , parameters: parameters ).responseJSON(completionHandler: { (response) in
                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    break
                    
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    GDAlertView.alert("请求超时,请重试", image: nil , time: 2, complateBlock: nil )//请求超时处理
                    break
                }
            })
            return result
            
            //                .responseJSON(completionHandler: { (response) in
            //                mylog(String.init(data: response.data ?? Data(), encoding: String.Encoding.utf8))
            //                mylog("print request result -->:\(response.result)")
            //                "xx".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            //                let testOriginalStr = "http://www.hailao.com/你好世界"
            //                let urlEncode = testOriginalStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            //                let urlDecodeStr = urlEncode?.removingPercentEncoding
            //                mylog("encode : \(urlEncode)")
            //                mylog("decode : \(urlDecodeStr)")
            //
            //                let tt = "\\U751f\\U6210key\\U6210\\U529f"
            ////                mylog("tttt\(tt.u)")
            //            })
        }else{return nil }
    }
    
    
    
    
}


extension DDRequestManager{
    func test () {
        
        //        result.session.configuration.timeoutIntervalForRequest = 5
        //        result.request(URL(string:"http://api.hailao.cc/index/index")!, method: HTTPMethod.post, parameters: ["hi":"lao"] , headers: HTTPHeaders()).responseJSON { (response) in
        //            switch response.result{
        //            case .success :
        //                break
        //
        //            case .failure :
        //                GDAlertView.alert("error", image: nil , time: 2, complateBlock: nil )//请求超时处理
        //                dump(response)
        //                break
        //            }
        //
        //        }
        
    }
}







class PHPRequestManager : NSObject, URLSessionDelegate{
    static let share = PHPRequestManager()
    var sessiono : URLSession?
    func test() {
        let url = URL(string: "https://wy.local/test1.php?key1=2&key2=4")!
        let request = NSMutableURLRequest(url: url )
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        let params
        
        var  session1 = URLSession(configuration: URLSessionConfiguration.default, delegate: self , delegateQueue: OperationQueue.main)
        self.sessiono = session1
        let dataTask = session1.dataTask(with: url) { (data , response , error ) in
            let result = String.init(data: data! , encoding:
                String.Encoding.utf8)
            mylog(result )
            mylog("\(data )--\(response)--\(error )")
        }
        //        let dataTask = session1.dataTask(with: request){ (data , response , error ) in
        //            mylog("\(data )--\(response)--\(error )")
        //        }
        dataTask.resume()
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential , card )
        }
    }
}
/*
 上传文件
 假设您在控制台有已创建的 Bucket。SDK 的所有操作都会返回一个OSSTask，您可以为这个 Task 设置一个延续动作，等待其异步完成，也可以通过调用waitUntilFinished阻塞等待其完成。
 OSSPutObjectRequest * put = [OSSPutObjectRequest new];
 put.bucketName = @"<bucketName>";
 put.objectKey = @"<objectKey>";
 put.uploadingData = <NSData *>; // 直接上传NSData
 put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
 NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
 };
 OSSTask * putTask = [client putObject:put];
 [putTask continueWithBlock:^id(OSSTask *task) {
 if (!task.error) {
 NSLog(@"upload object success!");
 } else {
 NSLog(@"upload object failed, error: %@" , task.error);
 }
 return nil;
 }];
 // 可以等待任务完成
 // [putTask waitUntilFinished];
 下载指定文件
 以下代码用于下载指定 Object 为NSData：
 OSSGetObjectRequest * request = [OSSGetObjectRequest new];
 request.bucketName = @"<bucketName>";
 request.objectKey = @"<objectKey>";
 request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
 NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
 };
 OSSTask * getTask = [client getObject:request];
 [getTask continueWithBlock:^id(OSSTask *task) {
 if (!task.error) {
 NSLog(@"download object success!");
 OSSGetObjectResult * getResult = task.result;
 NSLog(@"download result: %@", getResult.downloadedData);
 } else {
 NSLog(@"download object failed, error: %@" ,task.error);
 }
 return nil;
 }];
 // 如果需要阻塞等待任务完成
 // [task waitUntilFinished];
 
 */
