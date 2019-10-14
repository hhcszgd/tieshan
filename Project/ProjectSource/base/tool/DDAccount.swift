//
//  DDAccount.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//

import UIKit
//import HandyJSON
enum DepartmentType : String  {
    case kuGuanBu = "kuGuanBu"
    case chaiJieBu = "chaiJieBu"
    case shouXuBu = "shouXuBu"
    case waiQinBu = "waiQinBu"
    case yeWuBu = "yeWuBu"
    case admin = "admin"
}


/*
 var token : String = ""
 var login_name:String?
 var head_url : String?
 var phone: String?
 var user_name: String?
 var department_name:String?
 var depart_code:String?
 var id : Int?
 */
class DDAccount:NSObject , Codable , NSCoding{
    private enum CodingKeys: String, CodingKey  {
        case login_name
        case head_url
        case phone
        case user_name
        case department_name
        case depart_code
        case id
        case token

    }
    func refreshInfo(complate:(()->())?) {
            DDQueryManager.share.getProfileInfo(type: ApiModel<DDAccount>.self, success: { (apiModel) in
                if apiModel.ret_code == "0" , let a = apiModel.data{
                    DDAccount.share.setPropertisOfShareBy(otherAccount: a)
                }
            }, failure: { (error ) in
            }) {
                    complate?()
            }
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login_name = try container.decodeIfPresent(type(of: login_name), forKey: CodingKeys.login_name) as? String
        head_url = try container.decodeIfPresent(type(of: head_url), forKey: CodingKeys.head_url) as? String
        phone = try container.decodeIfPresent(type(of: phone), forKey: CodingKeys.phone) as? String
        user_name = try container.decodeIfPresent(type(of: user_name), forKey: CodingKeys.user_name) as? String
        
        department_name = try container.decodeIfPresent(type(of: department_name), forKey: CodingKeys.department_name) as? String
        department_name = try container.decodeIfPresent(type(of: department_name), forKey: CodingKeys.department_name) as? String
        depart_code = try container.decodeIfPresent(type(of: depart_code), forKey: CodingKeys.depart_code) as? String
        token = try container.decodeIfPresent(type(of: token), forKey: CodingKeys.token) as? String
        do {
            let iddd = try container.decodeIfPresent(Int.self, forKey: CodingKeys.id)
            id = "\(iddd)"
        } catch  {
            do {
                let iddd = try container.decodeIfPresent(String.self, forKey: CodingKeys.id)
                id = iddd
            } catch  {
                id = "null"
            }
        }
        
    }
    
    
    
    
    
    
    
    var login_name:String?
    var head_url : String?
    var phone: String?
    var user_name: String?
    var department_name:String?
    var depart_code:String?
    var id: String? // = 95
    var token: String?// "101faa72fd8cd4f1cdb5ef3ca6e8d49c29cd36e9"
    var departmentType : DepartmentType{
        switch depart_code {
        case "10001":
            return DepartmentType.admin
        case "20001":
            return DepartmentType.yeWuBu
        case "30001":
            return DepartmentType.shouXuBu
        case "40001":
            return DepartmentType.chaiJieBu
        case "50001":
            return DepartmentType.waiQinBu
        case "60001":
            return DepartmentType.kuGuanBu
        default:
            return DepartmentType.chaiJieBu
        }
    }
    
    var isLogin : Bool {
        if let token = self.token, token.count > 0{
            return true
        }else {
            return false
        }
        
    }
    
    static let share = DDAccount.read()
    

    override init() {
        
    }
    func louginout()  {
        self.deleteAccountFromDisk()
        NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil)
    }
    ///save account from memary to disk .
    
    /// return value  : save success or not
    @discardableResult
    func save() -> Bool {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath : NSString = docuPath as NSString? {
            let filePath = realDocuPath.appendingPathComponent("Account.data")
            let isSuccess =  NSKeyedArchiver.archiveRootObject(self , toFile: filePath)
            if isSuccess {
                mylog("archive success")
            }else{
                mylog("archive failure")
            }
            return isSuccess
        }else{
            mylog("the  path of archive is not exist")
            return false
        }
    }
    
    ///load account from local disk
    class  func read() -> DDAccount {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath : NSString = docuPath as NSString? {
            let filePath = realDocuPath.appendingPathComponent("Account.data")
            let object =  NSKeyedUnarchiver.unarchiveObject(withFile:  filePath)
            if let realObjc = object as? DDAccount {
                return realObjc
            }else{
                return  DDAccount.init()
            }
        }else{
            mylog("the  path of unarchive is not exist")
            return  DDAccount.init()
        }
    }
    ///set share account's propertis by other account dictionary
    
    
    ///set share account's propertis by other account instance
    func setPropertisOfShareBy( otherAccount : DDAccount)  {
        if let token = otherAccount.token, token.count > 0 {
            self.token = token
        }
        if let name = otherAccount.login_name, name.count > 0 {
            self.login_name = name
        }
        if let mobile = otherAccount.phone, mobile.count > 0 {
            self.phone = mobile
        }
        if let id = otherAccount.id {
            self.id = id
        }
        self.department_name = otherAccount.department_name ?? "null"
        self.depart_code = otherAccount.depart_code  ?? "null"
        self.user_name = otherAccount.user_name  ?? "null"
        self.head_url = otherAccount.head_url ?? "null"
        self.save()
    }
    
    ///remove account data from disk
    @discardableResult
    func deleteAccountFromDisk() -> Bool {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("Account.data")
        do {
            try  FileManager.default.removeItem(atPath: path)
            mylog("remove account data from disk success")
            self.token = nil
            self.login_name = nil
            self.id = nil
            self.phone = nil
            self.department_name = nil
            self.depart_code = nil
            self.user_name = nil
            self.head_url = nil
            
            return true
        }catch  let error as NSError {
            mylog("remove account data from disk failure")
            mylog(error)
            return false
        }
        
        
        
        
    }
    
    
    //unarchive binary data to instance
    required init?(coder aDecoder: NSCoder) {
        
        self.token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        self.id = (aDecoder.decodeObject(forKey: "id") as? String) ?? ""
        self.phone = (aDecoder.decodeObject(forKey: "phone") as? String) ?? ""
        self.login_name = aDecoder.decodeObject(forKey: "login_name") as? String
        head_url = aDecoder.decodeObject(forKey: "head_url") as? String
        self.user_name = aDecoder.decodeObject(forKey: "user_name") as? String
        self.department_name = aDecoder.decodeObject(forKey: "department_name") as? String
        self.depart_code = aDecoder.decodeObject(forKey: "depart_code") as? String
        
    }
    
    
    //unarchive instance to binary data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.phone, forKey: "phone")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.id, forKey: "id")
        
        aCoder.encode(self.login_name, forKey: "login_name")
        aCoder.encode(head_url, forKey: "head_url")
        aCoder.encode(self.user_name, forKey: "user_name")
        aCoder.encode(department_name, forKey: "department_name")
        aCoder.encode(self.depart_code, forKey: "depart_code")
        
    }
}
