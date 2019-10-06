
//
//  AppDelegate.swift
//  Project
//
//  Created by WY on 2019/9/16.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import CoreData
import CryptoSwift
import Alamofire
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?{didSet{window?.backgroundColor = UIColor.white}}
    
    /**Alamofire的网络监听类*/
//    let manager = NetworkReachabilityManager(host: "www.baidu.com")//域名一定正确填写
    var rootTabBarVC :DDRootTabBarVC?
    var rootNavVC : DDRootNavVC?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        test1()
        // Override point for customization after application launch.
        startNetworkReachabilityObserver()
        registerLoginNotification()
        self.configRootVC()
        setupOriginPushNotification()
        setupJpush(launchOptions: launchOptions)
//        self.testLanguage()
        //向微信注册
//        WXApi.registerApp("wx6f542c8fd815f11e", universalLink: <#String#>)

        return true
    }
    
    
    var firstLaunch = false
    
    ///:configRootVC
    func configRootVC() {
        if  window  == nil {window = UIWindow(frame: UIScreen.main.bounds)}
        if checkIsNewVersion() {
            let rootVC = DDNewFeature(isNewVersion: true)
            rootVC.done = {
                self.configRootVC()
            }
            self.window?.rootViewController = rootVC
            self.window?.makeKeyAndVisible()
            return
        }
        let isLogin = DDAccount.share.isLogin
        if isLogin{
            let rootNavVC = DDRootNavVC()
            self.window?.rootViewController = rootNavVC
            self.window?.makeKeyAndVisible()
        }else{
            let loginVC = DDLoginVC()
            let naviVC = UINavigationController.init(rootViewController: loginVC)
//            naviVC.navigationBar.isHidden  = true
//            naviVC.setNavigationBarHidden(true , animated: false )
            naviVC.navigationBar.shadowImage = UIImage()
            self.window?.rootViewController = naviVC
            self.window?.makeKeyAndVisible()
        }
        if firstLaunch{
            DDRequestManager.share.advertApi(true )?.responseJSON(completionHandler: { (response) in
                if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<ADModel>.self, from: response){
                    dump(apiModel)
                    if let imgUrl = apiModel.data?.start_pic{
                        let para = ["imageUrlStr":imgUrl  , "link":apiModel.data?.link]
                        DDADView.init(paramete: para).done = {para in
                            if let dict = para as? [String:String] , let link = dict["link"]{
                                let vc = GDBaseWebVC()
                                vc.userInfo = link
                                if let naviVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
                                    naviVC.pushViewController(vc , animated: true )
                                }
                            }
                        }
                    }
                }
            })

            firstLaunch = false
            Thread.sleep(forTimeInterval: 2)
        }
    }
    
    
    ///9.0系统之前使用的回调
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.host == "safepay" {
            //跳转到支付宝钱包处理支付结果
            
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (dict) in
                PayManager.share.alipaySuccess?(dict)
            }
            
        }
        if url.host == "pay" {
            
            return WXApi.handleOpen(url, delegate: PayManager.share)
            
        }
        return true
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.host == "pay" {
            
            return WXApi.handleOpen(url, delegate: PayManager.share)
            
        }
        return true
    }
    ///9.0系统之后使用的支付宝回调方法
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            //跳转到支付宝钱包处理支付结果
            
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (dict) in
                PayManager.share.alipaySuccess?(dict)
            }
            
        }
        if url.host == "pay" {
            
            return WXApi.handleOpen(url, delegate: PayManager.share)
            
        }
        return true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        mylog(self.checkIsNewVersion())
        JPUSHService.resetBadge()
        DDRequestManager.share.getPublickKey { (publicKey) in print("xxxxxxxxxxxxxxxx\(publicKey)")}
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //        if #available(iOS 10.0, *) {
        self.saveContext()
        //        } else {
        // Fallback on earlier versions
        //        }
    }
    
    // MARK: - Core Data stack
    //ios 9 and early
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.16lao.new.mh824appWithSwift" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "ZDLao", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    

    
    ///:ios10
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    
    
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ZDLao")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    //    @available(iOS 10.0, *)
    func saveContext () {
        
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }else{
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
        }
        
        
    }
    
}
// notification
extension AppDelegate{
    func registerLoginNotification()  {
        NotificationCenter.default.addObserver(self , selector: #selector(loginResult(sender:)), name: NSNotification.Name.init("loginSuccess"), object: nil )
    }
    @objc func loginResult(sender:Notification)  {
        configRootVC()
    }
}
extension AppDelegate {
    func testPhp() {
//        PHPRequestManager.share.test()
//        DDRequestManager.share.testPHP(url: "https://172.16.2.39/test1.php", method: HTTPMethod.get , parameters: nil , print: true )
    }
}
