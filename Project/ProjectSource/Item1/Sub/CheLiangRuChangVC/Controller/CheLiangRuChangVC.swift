//
//  CheLiangRuChangVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class CheLiangRuChangVC: DDNormalVC {
    let addBtn = UIButton()
    let takePhotoBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车辆入场"
        view.addSubview(addBtn)
        addBtn.backgroundColor = .blue
        addBtn.setTitle("确定", for: UIControlState.normal)
        addBtn.frame = CGRect(x: 20, y: view.bounds.height - DDSliderHeight - 20 - 40, width: view.bounds.width - 40, height: 40)
        addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        
        view.addSubview(takePhotoBtn)
        takePhotoBtn.setImage(UIImage(named:"zhaoxiangjo"), for: UIControlState.normal)
        takePhotoBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        let photoBtnX : CGFloat = 20
        let photoBtnW = view.bounds.width - photoBtnX * 2
        let photoBtnH = photoBtnW * 0.64
        takePhotoBtn.frame = CGRect(x: photoBtnX, y: DDNavigationBarHeight + 64, width: photoBtnW, height: photoBtnH)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func addBtnClick(sender:UIButton){
        self.navigationController?.pushViewController(CheLiangGuanLiVC(), animated: true)
        mylog("确定")
        //        self.navigationController?.pushViewController(ZengJiaCheLiangeVC(), animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
