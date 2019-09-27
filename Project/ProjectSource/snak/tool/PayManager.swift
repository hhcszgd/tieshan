//
//  PayManager.swift
//  Project
//
//  Created by WY on 2019/9/22.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
enum PayMentType: String {
    ///支付宝支付
    case Alipay = "AliPay"
    ///微信支付
    case WeiChatpay = "WeiChatPay"
    ///银联支付
    case UnionPay = "UnionPay"
    ///线下支付
    case under = "underPay"
    
}

class PayManager: NSObject, WXApiDelegate{
    static let share = PayManager.init()
    func pay(paremete: AnyObject, payMentType: PayMentType) {
        
        switch payMentType {
        case .Alipay:
            self.performAliPayWithParamete(paramete: paremete)
        case .WeiChatpay:
            self.performWeiChatPayWithParamete(paramete: paremete)
        case .UnionPay:
            self.performUnionPayWithParamete(paramete: paremete)
        case .under:
            self.performUnderPayWithParamete(paramete: paremete)
        }
    }
    ///支付宝支付
    func performAliPayWithParamete(paramete: AnyObject) {
        self.serverRSAWithParamete(paramete: paramete)
    }
    ///服务器加密
    
    var alipaySuccess: ((Any?) -> ())?
    
    func serverRSAWithParamete(paramete: AnyObject)  {
        /*
        let token: String = DDAccount.share.token ?? ""
        guard let order_code  = paramete as? String else {
            
            GDAlertView.alert("订单号不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        let paramete = ["token": token, "order_code": order_code]
        NetWork.manager.requestData(router: Router.post("payment/alipay", .api, paramete)).subscribe(onNext: { (dict) in
            if let model = BaseModel<SignModel>.deserialize(from: dict) {
                if model.status == 200 {
                    if let tokenstr = model.data?.token, tokenstr.count > 0 {
                        //1订单id
                        //2从服务器端获取加密签名
                        //想apliay请求支付
                        let sign = tokenstr
                        let appScheme = "com.16lao.ylmedia"
                        AlipaySDK.defaultService().payOrder(sign, fromScheme: appScheme) { (resultDict) in
                            mylog(resultDict)
                            if let subDict = resultDict as? [String: AnyObject], let resultStatus = subDict["resultStatus"] as? String {
                                self.alipaySuccess?(subDict)
                            }
                            ///支付宝成功的回调
                        }
                    }
                }
            }
            
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        
        */
    }
    ///银联支付
    func performUnionPayWithParamete(paramete: AnyObject) {
        
    }
    ///线下支付
    func performUnderPayWithParamete(paramete: AnyObject) {
        
    }
    
    ///微信支付
    func performWeiChatPayWithParamete(paramete: AnyObject) {
        self.jumpToBizPayWith(paramete: paramete)
    }
    func jumpToBizPayWith(paramete: AnyObject) {
        //判断是否安装微信客户端
        guard let router = paramete as? Router else {
            GDAlertView.alert("请求参数不对", image: nil, time: 2, complateBlock: nil)
            return
        }
        NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            guard let status = dict["status"] as? Int, let data = dict["data"] as? [String: AnyObject] else {
                GDAlertView.alert("返回信息输入格式不对", image: nil, time: 2, complateBlock: nil)
                return
            }
            if status == 200 {
                
            }
            guard let partnerId = data["mch_id"] as? String else {
                return
            }
            guard let prepayid = data["prepay_id"] as? String else {
                return
            }
            guard let nonce = data["nonce_str"] as? String else {
                return
            }
            guard let sign = data["sign"] as? String else {
                return
            }
            
            guard let timeStamp = data["timestamp"] as? String, let time = Int(timeStamp) else {
                return
            }
            
            
            if WXApi.isWXAppInstalled() {
                //获取微信支付需要的信息
                let req = PayReq()
                req.partnerId = partnerId
                
                req.prepayId = prepayid
                req.nonceStr = nonce
                req.timeStamp = UInt32(time)
                req.package = "Sign=WXPay"
                req.sign = sign
                WXApi.send(req)
                
            }else {
                GDAlertView.alert("您没有安装微信", image: nil, time: 1, complateBlock: nil)
            }
            
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }, onDisposed: {
            mylog("回收")
        })
        
        
        
        
    }
    ///微信支付返回的结果
    func onReq(_ req: BaseReq!) {
        
        
    }
    var weixinResult: (([String: AnyObject]) -> ())?
    func onResp(_ resp: BaseResp!) {
        
        let code = resp.errCode
        switch code {
        case WXSuccess.rawValue:
            self.weixinResult!(["result": "success" as AnyObject])
        case WXErrCodeCommon.rawValue:
            self.weixinResult!(["result": "failure" as AnyObject])
            mylog("错误    可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。")
        case WXErrCodeUserCancel.rawValue:
            self.weixinResult!(["result": "failure" as AnyObject])
            mylog("用户取消    无需处理。发生场景：用户不支付了，点击取消，返回APP")
        case WXErrCodeSentFail.rawValue:
            self.weixinResult!(["result": "failure" as AnyObject])
            mylog("发送失败 ")
        case WXErrCodeAuthDeny.rawValue:
            mylog("授权失败")
            self.weixinResult!(["result": "failure" as AnyObject])
        case WXErrCodeUnsupport.rawValue:
            self.weixinResult!(["result": "failure" as AnyObject])
            mylog("微信不支持")
        default:
            break
        }
    }
    class SignModel: Codable {
        var token: String = ""
    }
    
}

