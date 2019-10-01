
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

enum DomainType : String  {
//    case release  = "http://api.bjyltf.com/"
case release  = "http://tpi.bjyltf.com/"
    case api = "http://39.106.225.64:8002/"

//    case release = "https://api.bjyltf.com/"
//    case wap = "https://tap.bjyltf.com/"
    case wap = "https://tap.bjyltf.com/"
}

extension DDQueryManager{
    /// write your api here 👇
    
    
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
        let para = ["username" : userName , "password": passWord]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para  , needToken : false , success: success, failure: failure, complate: complate)
    }
    @discardableResult
    func getProfileInfo<T>(type : ApiModel<T>.Type, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "user/getUserInfo"//TODO 1 要改成真是的memberID
        let para = ["token" : DDAccount.share.token ?? ""]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,headerParas : para , success: success, failure: failure, complate: complate)
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

class DDQueryManager: NSObject {
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
        header["APPID"] = "2"
        header["VERSIONMINI"] = "20160501"
        header["DID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header["VERSIONID"] = "2.0"
        header["language"] = language
        header[ "token"] = DDAccount.share.token ?? ""
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
        header["APPID"] = "2"
        header["VERSIONMINI"] = "20160501"
        header["DID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header["VERSIONID"] = "2.0"
        header["language"] = language
        
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
