//
//  DDInternalVC.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 com.16lao. All rights reserved.
//
///:导航栏自定义,实现了导航栏内部细节 , 可以没有导航栏
import SnapKit
import UIKit
class DDInternalVC: DDProvideForceTouchVC , CustomNaviBarDelegate , UIGestureRecognizerDelegate{
    var scrollCritical : CGFloat {
        if DDDevice.type == .iphoneX {return 88}
        return  64
    }//滚动临界值
    var naviBar : DDNavigatBar!
    let refreshImages = [UIImage.init(named: "loading1.png")!, UIImage.init(named: "loading2.png")!, UIImage.init(named: "loading3.png")!, UIImage.init(named: "loading4.png")!, UIImage.init(named: "loading5.png")!]
    private var scrollViews : [UIScrollView] = [UIScrollView]()
    var tableView : UITableView?{
        didSet{
            if tableView == nil{
                self.removeAllScrollViewObservers()
            }else{
                self.addObservers(scrollView: tableView!)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configNavBar()
        // Do any additional setup after loading the view.
    }
    func _configNavBar()  {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.setNavigationBarHidden(true   , animated: true )//自定义导航栏就需要隐藏导航控制器的导航栏1
        naviBar  = DDNavigatBar()
        naviBar.backgroundColor = UIColor.DDThemeColor
        if naviBar.superview == nil  { self.view.addSubview(naviBar); }
        naviBar.snp.makeConstraints { (make ) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(scrollCritical)
        }
        naviBar.backBtn.isHidden = self.isFirstVCInNavigationVC
        naviBar.delegate = self
        naviBar.backBtn.setImage(UIImage(named:"returnImage"), for: UIControlState.normal)
        naviBar.backBtn.imageEdgeInsets = UIEdgeInsetsMake(2, -9, 2, 9) //为了和系统返回箭头统一
        if let delegate = self as? UIGestureRecognizerDelegate{
            navigationController?.interactivePopGestureRecognizer?.delegate = delegate
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: true )//自定义导航栏就需要隐藏导航控制器的导航栏2
        self.view.bringSubview(toFront: self.naviBar)
        mylog(self.navigationController)
    }
    func popToPreviousVC() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///子类实现
    func contentOffsetInContentInset(scrollView : UIScrollView , scale  : CGFloat)  {//0~1
        //        mylog("contentInset范围内滚动\(scale)")
        //        self.navigationView.changeBackgrouncAlpha(alpha:1 - scale)//改变导航栏透明度
        //        self.navigationView.changeFrame(paramet: scale)//改变导航栏位置
    }
    func contentOffsetBigThanInsetTop(scrollView : UIScrollView ,scale  : CGFloat)  {//0~1
        //        mylog("大于0\(scale)")
    }
    func contentOffsetLessThanInsetTop(scrollView : UIScrollView ,scale  : CGFloat)  {//0~1
        //        mylog("小于0\(scale)")
    }
    func contentOffsetChanged(scrollView : UIScrollView ,contentOffset : CGPoint) {
        //        mylog("监听contentOffsetChanged\(contentOffset)")
    }
    deinit {
        self.removeAllScrollViewObservers()
    }
}

extension DDInternalVC {
    func addObservers(scrollView:UIScrollView) {
        if !scrollViews.contains(scrollView) {
            scrollViews.append(scrollView)
            scrollView.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            scrollView.addObserver(self , forKeyPath: "contentInset", options: NSKeyValueObservingOptions.new, context: nil)
            scrollView.addObserver(self , forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    final func removeAllScrollViewObservers(){
        scrollViews.forEach {self.removeObservers(scrollView: $0)}
        scrollViews.removeAll()
    }
    func removeObservers(scrollView:UIScrollView?) {
        if scrollView == nil  {return}
        scrollView!.removeObserver(self , forKeyPath: "contentOffset")
        scrollView!.removeObserver(self , forKeyPath: "contentInset")
        scrollView!.removeObserver(self , forKeyPath: "contentSize")
    }
    
    
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let scrollView = object as? UIScrollView
        
        if keyPath != nil && keyPath! == "contentOffset" && scrollView != nil {
            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                self.contentOffsetChanged(scrollView : scrollView! ,contentOffset: newPoint)
                let contentInset  = scrollView!.contentInset
                if contentInset.top < 0 {//应该没人这么干
                }else{
                    if newPoint.y < -contentInset.top {//滚完inset后,继续往下拖动 , y值<-top
                        let cha = -newPoint.y - contentInset.top
                        if cha <= self.scrollCritical {
                            self.contentOffsetLessThanInsetTop(scrollView : scrollView! , scale: cha / self.scrollCritical)
                        }
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: 0)//使inset外继续可以调用这个方法
                    }
                    if newPoint.y >= -contentInset.top && newPoint.y <= 0   {//在inset范围内滚动
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: ((scrollView?.contentInset.top)! + newPoint.y) / (scrollView?.contentInset.top)!)
                    }
                    if newPoint.y >= 0   {//滚到scrollView控件的边缘后 , 继续往上拖动
                        let cha = newPoint.y
                        if cha <= self.scrollCritical {
                            self.contentOffsetBigThanInsetTop(scrollView : scrollView! ,scale: cha / self.scrollCritical)
                        }
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: 1)//使inset外继续可以调用这个方法
                    }
                }
                
                
            }
        }else if keyPath != nil && keyPath! == "contentInset"{
            if  let newContentInset = change?[NSKeyValueChangeKey.newKey] as? CGRectEdge{
//                mylog("监听contentInset : \(String(describing: newContentInset))")
                
            }
            
        }else if keyPath != nil && keyPath! == "contentSize"{
            if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
//                mylog("监听contentSize : \(String(describing: newSize))")
                
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}
