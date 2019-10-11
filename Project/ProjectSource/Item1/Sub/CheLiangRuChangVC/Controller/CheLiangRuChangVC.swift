//
//  CheLiangRuChangVC.swift
//  Project
//
//  Created by WY on 2019/9/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//
import UIKit
private let scanCarNumAuthCode = "9DD232F7B4C7398BA6C2";
//import PlateMainController
extension CheLiangRuChangVC: PlateCameraDelegate {
    func cameraController(_ cameraController: UIViewController!, recognizePlateSuccessWithResult plateStr: String!, plateColor: String!, plateImage: UIImage!, squareImage: UIImage!, andFullImage fullImage: UIImage!) {
        self.navigationController?.popViewController(animated: true)
        takePhotoBtn.setImage(squareImage, for: UIControlState.normal)
        carImage = squareImage
        carBrandNum = plateStr
        carBrandColor = plateColor
    }
    
    
}
class CheLiangRuChangVC: DDNormalVC {
    let addBtn = UIButton()
    var carBrandColor = ""
    var carBrandNum = ""
    var carImage = UIImage()
    let takePhotoBtn = UIButton()
    lazy var scanner: PlateCameraController = {
        let vc = PlateCameraController(authorizationCode: scanCarNumAuthCode)!
        vc.delegate = self
        vc.deviceDirection = .portrait
        return vc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车辆入场"
        view.addSubview(addBtn)
        addBtn.adjustsImageWhenHighlighted = false
        addBtn.backgroundColor = .blue
        addBtn.setTitle("确定", for: UIControlState.normal)
        addBtn.frame = CGRect(x: 20, y: view.bounds.height - DDSliderHeight - 20 - 40, width: view.bounds.width - 40, height: 40)
        addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        
        view.addSubview(takePhotoBtn)
        takePhotoBtn.imageView?.contentMode = .scaleAspectFit
        takePhotoBtn.setImage(UIImage(named:"zhaoxiangjo"), for: UIControlState.normal)
        takePhotoBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        takePhotoBtn.addTarget(self , action: #selector(tokePhoto(sender:)), for: UIControlEvents.touchUpInside)
        let photoBtnX : CGFloat = 20
        let photoBtnW = view.bounds.width - photoBtnX * 2
        let photoBtnH = photoBtnW * 0.64
        takePhotoBtn.frame = CGRect(x: photoBtnX, y: DDNavigationBarHeight + 64, width: photoBtnW, height: photoBtnH)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func tokePhoto(sender:UIButton){
        self.navigationController?.pushViewController(scanner ?? UIViewController(), animated: true)
        mylog("确定")
        //        self.navigationController?.pushViewController(ZengJiaCheLiangeVC(), animated: true)
    }
    @objc func addBtnClick(sender:UIButton){
        let vc = CheLiangGuanLiVC()
        vc.carImage = carImage
        vc.carBrandNum = carBrandNum
        vc.carBrandColor = carBrandColor
        self.navigationController?.pushViewController(vc , animated: true)
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
