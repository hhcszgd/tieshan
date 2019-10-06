//
//  CarScannerVC.swift
//  Project
//
//  Created by JohnConnor on 2019/10/5.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit
import AVFoundation

class CarScannerVC: DDInternalVC ,AVCaptureMetadataOutputObjectsDelegate , CarQRViewDelegate {
 let qrView  = CarQRView()
    var delegate: QRCodeScannerVCDelegate?
    var complateHandle : ((String)->())?
    var captureSession: AVCaptureSession!
    var code: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavBar()
        self.setup()
        // Do any additional setup after loading the view.
    }
    func configNavBar()  {
        naviBar.attributeTitle = NSAttributedString(string: "扫描车位", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
//        naviBar.currentType = NaviBarStyle.withBackBtn
        self.naviBar.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.lightGray
        self.naviBar.backBtn.setImage(UIImage(named:"nav_back_white"), for: UIControlState.normal)
        if self.navigationController == nil {
            self.naviBar.backBtn.isHidden = true
        }
    }
     
    func setup()  {
        let frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        self.view.addSubview(self.qrView)
        self.qrView.delegate = self
        self.qrView.frame  =  frame
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func skip(view : CarScannerVC.CarQRView  ){
        guard ((self.navigationController?.popViewController(animated: true)) != nil) else{
            self.dismiss(animated: true , completion: nil )
            return
        }
    }
    func qrView(view: CarScannerVC.CarQRView, didCompletedWithQRValue: String) {
        mylog(didCompletedWithQRValue)
         self.delegate?.scannerComplate(code: didCompletedWithQRValue)
        self.complateHandle?(didCompletedWithQRValue)
        self.dismiss(animated: true , completion: nil )
    }
    
    deinit{
        mylog("扫描控制器销毁")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true )
        if !self.qrView.session.isRunning{
            self.qrView.session.startRunning()
            self.qrView.setNeedsLayout()
        }
    }
}

@objc protocol CarQRViewDelegate : NSObjectProtocol{
    func qrView(view : CarScannerVC.CarQRView  , didCompletedWithQRValue : String)
    func skip(view : CarScannerVC.CarQRView  )
}

extension CarScannerVC {

    class CarQRView: UIView ,AVCaptureMetadataOutputObjectsDelegate{
        weak var delegate : CarQRViewDelegate?
        let bgView  = UIImageView()//背景框
        let lineView = UIImageView()//上下扫描的线
        let descrip = UILabel(title: "将二维码/条码放入框内,即可自动扫描", font: UIFont.systemFont(ofSize: 14), color: .white, align: .center)
        let flashdescrip = UILabel(title: "轻触点亮/关闭", font: UIFont.systemFont(ofSize: 14), color: .white, align: .center)
        let skipBtn = UIButton()
        let session = AVCaptureSession()
        var sublayer    : AVCaptureVideoPreviewLayer?
        let videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
        //        AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let flashLightBtn = UIButton()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setupQRScannerCompose()
            self.setupControlCompose()
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func setupControlCompose ()  {
            self.addSubview( bgView)
            self.addSubview(lineView)
            self.addSubview(flashLightBtn)
            self.addSubview(descrip)
            self.addSubview(skipBtn)
            self.addSubview(flashdescrip)
            flashLightBtn.setImage(UIImage(named: "icon_shoudiantong_nor"), for: UIControlState.normal)
            flashLightBtn.setImage(UIImage(named: "icon_shoudiantong_sel"), for: UIControlState.selected)
            flashLightBtn.addTarget(self, action: #selector(flashBtnClick(sender:)), for: UIControlEvents.touchUpInside)
            self.bgView.image = UIImage.init(named: "pick_bg")
            self.lineView.image = UIImage.init(named: "line")
            if videoCaptureDevice?.isTorchAvailable ?? false{
                flashLightBtn.isHidden = false
                flashdescrip.isHidden = false
            }else{
                flashLightBtn.isHidden = true
                flashdescrip.isHidden = true
            }
            skipBtn.setTitle("跳过扫描", for: UIControlState.normal)
            skipBtn.backgroundColor = mainColor
            skipBtn.addTarget(self , action: #selector(skipBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        }
        @objc func skipBtnClick(sender:UIButton) {
            self.delegate?.skip(view: self)
        }
        @objc func flashBtnClick(sender:UIButton) {
            sender.isSelected = !sender.isSelected
            if videoCaptureDevice?.isTorchAvailable ?? false{
                self.videoCaptureDevice?.torchMode = sender.isSelected ?  .on : .off
            }
        }
        func setupQRScannerCompose()  {
            //        let videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            //        videoCaptureDevice.unlockForConfiguration()
            do {
                try  videoCaptureDevice?.lockForConfiguration()
                
            }catch{
                mylog(error)
            }
            if videoCaptureDevice?.isTorchAvailable ?? false{
                videoCaptureDevice?.torchMode = .off
            }
            //MARK:先注销 , 等会儿再测
            //        let setting = AVCapturePhotoSettings.init(format: nil).flashMode = AVCaptureFlashMode.on
            
            //        videoCaptureDevice.torchMode =  AVCaptureTorchMode.on
            //        videoCaptureDevice.flashMode  = AVCaptureFlashMode.on
            if let videoCaptureDevice  = self.videoCaptureDevice {
                do {
                    
                    let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                    
                    if self.session.canAddInput(videoInput) {
                        self.session.addInput(videoInput)
                    } else {
                        print("Could not add video input")
                    }
                    
                    let metadataOutput = AVCaptureMetadataOutput()
                    
                    if self.session.canAddOutput(metadataOutput) {
                        self.session.addOutput(metadataOutput)
                        
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.pdf417]
                    } else {
                        print("Could not add metadata output")
                    }
                    
                    let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.sublayer = previewLayer
                    self.layer.addSublayer(self.sublayer!)
                    //            previewLayer?.frame = self.view.layer.bounds
                    //            self.view.layer .addSublayer(previewLayer!)
                    self.session.startRunning()
                } catch let error as NSError {
                    print("Error while creating vide input device: \(error.localizedDescription)")
                }
            }
            
            
        }
        //    override func layoutSublayers(of layer: CALayer) {
        //        super.layoutSublayers(of: layer)
        //        sublayer?.frame = self.layer.bounds
        //
        //    }
        //扫描成功的代理
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
            mylog(metadataObjects)
            for item in metadataObjects {
                if let obj  = item as? AVMetadataMachineReadableCodeObject {
                    if obj.stringValue?.count ?? 0 > 0 {
                        let isRespondOption = (self.delegate?.responds(to: #selector(QRViewDelegate.qrView(view:didCompletedWithQRValue:))))
                        if let isRespond = isRespondOption  {
                            if isRespond {
                                self.delegate?.qrView(view: self, didCompletedWithQRValue: obj.stringValue!)
                                self.session.stopRunning();
                                return
                            }
                        }
                    }
                    
                }
            }
            
        }
        //    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {//过期
        //        mylog(metadataObjects)
        //        //MARK: 强制解包失败已修复
        //
        //        for item in metadataObjects {
        //            if let obj  = item as? AVMetadataMachineReadableCodeObject {
        //                if obj.stringValue?.characters.count ?? 0 > 0 {
        //                    let isRespondOption = (self.delegate?.responds(to: #selector(QRViewDelegate.qrView(view:didCompletedWithQRValue:))))
        //                    if let isRespond = isRespondOption  {
        //                        if isRespond {
        //                            self.delegate?.qrView(view: self, didCompletedWithQRValue: obj.stringValue!)
        //                            self.session.stopRunning();
        //                            return
        //                        }
        //                    }
        //                }
        //
        //            }
        //        }
        //    }
        override func layoutSubviews() {
            super.layoutSubviews()
            mylog(self.bounds)
            sublayer?.frame = self.bounds
            let  size = self.bounds.size;
            let  bgW : CGFloat = 200
            let bgH  : CGFloat = 200
            let  bgX  : CGFloat = (size.width - bgW) * 0.5;
            let  bgY  : CGFloat = (size.height - bgH) * 0.5;
            //  背景的位置
            self.bgView.frame = CGRect.init(x: bgX, y: bgY, width: bgW, height: bgH)
            descrip.frame = CGRect.init(x: 0, y: bgView.frame.maxY , width: bounds.width , height: 40)
            //  线的frame
            self.lineView.frame = CGRect.init(x: bgX, y: bgY, width: bgW, height: 2)
            //  使用核心动画
            self.lineView.layer.removeAnimation(forKey: "positionAnimation")
            let  positionAnimation : CABasicAnimation =  CABasicAnimation.init(keyPath: "position.y")
            positionAnimation.fromValue = (bgY);
            positionAnimation.toValue = (self.bgView.frame.maxY)
            positionAnimation.duration = 2
            positionAnimation.repeatCount = Float(NSIntegerMax)
            self.lineView.layer.add(positionAnimation, forKey: "positionAnimation")
            self.skipBtn.frame = CGRect(x: 24 , y: self.bounds.height - 88, width:self.bounds.width - 48, height:44)
            flashLightBtn.frame = CGRect(x: self.bounds.width/2 - 22 , y: self.skipBtn.frame.minY - 100, width:44, height:44)
            flashdescrip.frame = CGRect(x: 0 , y: self.flashLightBtn.frame.maxY + 10, width:bounds.width, height:34)
            skipBtn.layer.cornerRadius = 8
            skipBtn.layer.masksToBounds = true
        }
        
        deinit {
            mylog("二维码视图销毁了")
            //         videoCaptureDevice.torchMode = .off
            
        }
    }
    /**
     /**
     *  当输出对象解析到相应地内容的时候,就会调用该方法
     */
     - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
     {
     AVMetadataMachineReadableCodeObject *obj = [metadataObjects firstObject];
     
     if (obj.stringValue.length != 0) {
     if ([self.delegate respondsToSelector:@selector(qrView:didCompletedWithQRValue:)]) {
     [self.delegate qrView:self didCompletedWithQRValue:obj.stringValue];
     }
     [self.session stopRunning];
     }
     }
     
     
     
     - (void)layoutSubviews
     {
     [super layoutSubviews];
     
     CGSize size = self.bounds.size;
     
     CGFloat bgW = 200;
     CGFloat bgH = 200;
     CGFloat bgX = (size.width - bgW) * 0.5;
     CGFloat bgY = (size.height - bgH) * 0.5;
     //  背景的位置
     self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
     //  线的frame
     self.lineView.frame = CGRectMake(bgX, bgY, bgW, 2);
     
     //  使用核心动画
     [self.lineView.layer removeAnimationForKey:@"positionAnimation"];
     
     CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
     
     positionAnimation.fromValue = @(bgY);
     
     positionAnimation.toValue = @(CGRectGetMaxY(self.bgView.frame));
     
     positionAnimation.duration = 2;
     
     positionAnimation.repeatCount = NSIntegerMax;
     
     [self.lineView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
     }
     
     
     */
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */




}
