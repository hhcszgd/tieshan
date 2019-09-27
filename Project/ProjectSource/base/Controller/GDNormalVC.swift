//
//  GDNormalVC.swift
//  zjlao
//
//  Created by WY on 16/11/21.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//

import UIKit
enum VCType {
    case withBackButton
    case withoutBackButton
}

class GDNormalVC: GDBaseVC , CustomNaviBarDelegate , UITableViewDelegate,UITableViewDataSource ,UICollectionViewDelegate , UICollectionViewDataSource{
    
    override var keyModel: GDModel? {
        set{
            super.keyModel = newValue
            mylog(newValue?.navTitle)
            if newValue != nil && newValue!.navTitle != nil  {
                self.textNavTitle = newValue!.navTitle!
            }
            if newValue != nil && newValue!.attributeTitle != nil  {
                self.attritNavTitle = newValue!.attributeTitle!
            }
        }
        get{
            return  super.keyModel
        }
    }
    private var  scrollViewType = ""
    lazy var collectionView: UICollectionView = {
        self.scrollViewType = "collect"
        let collect = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout.init())
        self.view.addSubview(collect)
        collect.dataSource = self
        collect.delegate = self
        collect.register(UICollectionViewCell.self , forCellWithReuseIdentifier: "item")
        collect.frame = self.view.bounds
        return collect
    }()
    lazy var tableView : UITableView = {
        self.scrollViewType = "table"
        let temp = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)//
        self.view.addSubview(temp)
        temp.dataSource = self
        temp.delegate = self
        temp.frame = self.view.bounds
        return temp
    
    }()
    
    lazy var refreshHeader: GDRefreshControl = {
        let control = GDRefreshControl.init(target: self, selector: #selector(refresh))
        return control
    }()
    
    
    
    //MARK:refresh  这个控件的高度是根据图片的像素数类定的 , 像素限制在40个点(注意2X和3X)
    ///下拉刷新
    @objc func refresh ()  {

    }
    lazy var refreshFooter: GDLoadControl = {
        let control = GDLoadControl.init(target: self, selector: #selector(loadMore))
        return control
    }()
    ///上拉加载更多
    @objc func loadMore ()  {
    }

    //MARK:collectViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        item.backgroundColor = UIColor.randomColor()
        return item
    }
    //MARK:tabViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil  {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(indexPath.section)组\(indexPath.row)行"
        return cell ?? UITableViewCell()
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        return nil
    }
    
    var currentType : VCType = VCType.withBackButton
    
    var attritNavTitle : NSAttributedString  {
        set{
            mylog(newValue)
            naviBar.attributeTitle = newValue  }
        get{ return naviBar.attributeTitle }
    }
    
    var textNavTitle : String  {
        set{   naviBar.title = newValue  }
        get{ return naviBar.title }
    }
    
   // var naviBar : GDNavigatBar = GDNavigatBar()
    var naviBar : GDNavigatBar = GDNavigatBar()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {//代码或xib创建控制器
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
   convenience init(type : VCType) {
        self.init()
        mylog(self.view)
        if naviBar.superview == nil  {
            self.view.addSubview(naviBar)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ///通知，切换语言刷新页面
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: GDLanguageChanged, object: nil)
        
        
        
        self.view.backgroundColor = UIColor.white
        if naviBar.superview == nil  {
            self.view.addSubview(naviBar)
        }
        self.automaticallyAdjustsScrollViewInsets = false
        if (((self.navigationController?.childViewControllers.count) ?? 1) > 1) {
            self.currentType=VCType.withBackButton;
            naviBar.currentType = NaviBarStyle.withBackBtn
        }else{
            self.currentType=VCType.withoutBackButton;
            naviBar.currentType = NaviBarStyle.withoutBackBtn
        }
        
        switch currentType {
        case .withBackButton:
            //
           // naviBar = GDNavigatBar(type: NaviBarStyle.withBackBtn)
            naviBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: NavigationBarHeight )
            naviBar.delegate = self
            break
        case .withoutBackButton:
            //
            
            //naviBar = GDNavigatBar(type: NaviBarStyle.withoutBackBtn)
            naviBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: NavigationBarHeight )
            break
        }
        naviBar.backgroundColor = UIColor.white
        //        self.view.addSubview(naviBar)//推迟添加 , 否则会提前调用viewdidload()
        
        
        
        self.naviBar.showLineview = true
        naviBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: NavigationBarHeight )
        
    }
    ///刷新页面
    @objc func refreshUI() {
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubview(toFront: self.naviBar)

        
    }
//    override  func showErrorView ()  {//因为有导航栏 , 所以得重写次方法把错误页面插到导航栏下面
//        self.errorView = GDErrorView()
//        self.errorView?.addTarget(self, action: #selector(errorViewClick), for: UIControlEvents.touchUpInside)
//        self.view.insertSubview(errorView!, belowSubview: self.naviBar)
//        self.errorView?.frame = self.view.bounds
//        
//        
//    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func popToPreviousVC() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
      //MARK:代理方法 , 子类若想用这个方法 , 必须在这个父类中首先实现一下 , 再在子类中重写才会生效
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.naviBar.change(by: scrollView)
//        
//    }

    
}
