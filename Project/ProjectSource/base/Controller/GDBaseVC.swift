//
//  GDBaseVC.swift
//  zjlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import HandyJSON
class GDBaseVC: UIViewController {

   private var resetAfterLanguaged = false
    var TabBarHeight : CGFloat {
        return self.tabBarController?.tabBar.bounds.size.height ?? 44.0
    }
    var parameter : AnyObject? //用来接收关键参数的属性 (字符串 , 自定义模型等等)
    var keyModel : GDModel? {
        didSet{

        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
        self.gdAddSubViews()

        // Do any additional setup after loading the view.
    }
//    func languageChange(){//1
//        self.resetAfterLanguaged = true
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {//2
        super.viewWillAppear(animated)
        if self.resetAfterLanguaged {
            self.resetAfterLanguaged = false
            self.gdAddSubViews()
            self.setupContentAndFrame()
        }
    }

    func gdAddSubViews () {//子类添加子控件在别的方法进行 , 如果切换语言后需要增减子控件时就重写这个方法
        for subView in self.view.subviews {//如果子类在调用这个方法时需要移除 导航栏以外的其他子控件 , 需调用super.gdAddSubViews()
            if let _ = subView as? GDNavigatBar {//导航栏不动 , 如果需要的话导航栏上的子控件自行移除或添加
            }else{
                subView.removeFromSuperview()
            }
        }
    }
    func setupContentAndFrame () {//子类用来重写 , 实现自动布局
        
    }
    
    /// 网络请求失败时调用这个方法以判断是否是没联网 , 当网络错误是自动展示错误页面
    ///
    /// - Parameter error: 错误参数
    /// - Returns: 网络是否可用
//    func checkErrorInfo(error:NSError, frame: CGRect) -> Bool {
//        if error.code < 0 {
//            self.showErrorView(frame: frame)//网络错误
//            return false
//        }else{
//            return true //非网络原因
//        }
//    }
    
    
    
    
//    lazy var emptyView: EmptyView = EmptyView()
//
//
//    //MARK:页面加载错误是调这个方法
//    func showErrorView (frame: CGRect)  {
//        if !self.view.subviews.contains(errorView) {
//            self.view.addSubview(errorView)
//        }else {
//            return
//        }
//        self.errorView.addTarget(self, action: #selector(errorViewClick), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(errorView)
//        //        self.view.insertSubview(errorView!, belowSubview: self.naviBar)
//        self.errorView.frame = frame
//
//
//    }
//    let errorView = GDErrorView()
    //MARK://子类重写它 , 在方法中调hiddenErrorView()
    func errorViewClick ()  {
        
    }
    func hiddenErrorView()  {
//        self.errorView.removeFromSuperview()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}




