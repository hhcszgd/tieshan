//
//  DDViewController.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//
let mainBgColor =  UIColor.colorWithHexStringSwift("F4F3F4")
import UIKit
enum DDLoadType : String {
    case refresh
    case initialize
    case loadMore
}
class DDViewController: UIViewController {
    var pageIndex = 1
    
    lazy var refreshHeader: GDRefreshControl = {
        let control = GDRefreshControl.init(target: self, selector: #selector(refresh))
        control.refreshHeight = 40
        control.backgroundColor = .clear
        control.titleLabel.backgroundColor = .clear
        control.imageView.backgroundColor = .clear
        control.imageView.isHidden = true
        //        let refreshImages = [UIImage.init(named: "loading1.png")!, UIImage.init(named: "loading2.png")!, UIImage.init(named: "loading3.png")!, UIImage.init(named: "loading4.png")!, UIImage.init(named: "loading5.png")!]
        ////        control.refreshingImages = refreshImages
        ////
        ////        control.pullingImages = refreshImages
        //>>>>>>> e08a45f63302c6a0a5d2da4614870b695b2c6d21
        return control
    }()
    ///下拉刷新
    @objc func refresh ()  {
        
    }
    lazy var loadFooter: GDLoadControl = {
        let control = GDLoadControl.init(target: self, selector: #selector(loadMore))
        control.loadHeight = 40
        control.imageView.isHidden = true
        control.backgroundColor = .clear
        control.titleLabel.backgroundColor = .clear
        control.imageView.backgroundColor = .clear
        //        let refreshImages = [UIImage.init(named: "loading1.png")!, UIImage.init(named: "loading2.png")!, UIImage.init(named: "loading3.png")!, UIImage.init(named: "loading4.png")!, UIImage.init(named: "loading5.png")!]
        //        control.loadingImages = refreshImages
        //        control.pullingImages = refreshImages
        return control
    }()
    ///上拉加载更多
    @objc func loadMore ()  {
    }
    func addRefresh(_ canBeScrollView : UIScrollView) {
        canBeScrollView.gdRefreshControl = refreshHeader
    }
    func addLoadMore(_ canBeScrollView : UIScrollView) {
        canBeScrollView.gdLoadControl = loadFooter
    }
    var showModel : DDShowProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = mainBgColor
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension DDViewController{
    var isFirstVCInNavigationVC : Bool{
        if let navigationVC = self.navigationController {
            if let index = navigationVC.viewControllers.index(of: self) , index == 0{
                return true
            }
        }
        return false
    }
    var indexInTabBarVC : Int?{
        if let tabBarVC = self.navigationController?.tabBarController {
            if let index = tabBarVC.viewControllers?.index(of: self.navigationController!) {
                return index
            }
        }
        if let tabBarVC = self.tabBarController {
            if let index = tabBarVC.viewControllers?.index(of: self) {
                return index
            }
        }
        return nil
    }
    
}
