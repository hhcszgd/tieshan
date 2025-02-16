//
//  QRCodeScannerVC.swift
//  zjlao
//
//  Created by WY on 16/11/9.
//  Copyright © 2019年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import AVFoundation
protocol QRCodeScannerVCDelegate {
    func scannerComplate(code: String?)
}
class QRCodeScannerVC: DDInternalVC,AVCaptureMetadataOutputObjectsDelegate , QRViewDelegate {
    let qrView  = QRView()
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
        naviBar.title = ""
//        naviBar.currentType = NaviBarStyle.withBackBtn
        self.naviBar.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.purple
        self.naviBar.backBtn.setImage(UIImage(named:"back_icon"), for: UIControlState.normal)
    }
//    func newQRCode() {
//        
//        self.captureSession = AVCaptureSession();
//        let videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        
//        do {
//            
//            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//            
//            if self.captureSession.canAddInput(videoInput) {
//                self.captureSession.addInput(videoInput)
//            } else {
//                print("Could not add video input")
//            }
//            
//            let metadataOutput = AVCaptureMetadataOutput()
//            if self.captureSession.canAddOutput(metadataOutput) {
//                self.captureSession.addOutput(metadataOutput)
//                
//                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
//            } else {
//                print("Could not add metadata output")
//            }
//            
//            let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
//            previewLayer?.frame = self.view.layer.bounds
//            self.view.layer .addSublayer(previewLayer!)
//            self.captureSession.startRunning()
//        } catch let error as NSError {
//            print("Error while creating vide input device: \(error.localizedDescription)")
//        }
//
//    }
    
    
    //I THINK THIS METHOD NOT CALL !
//    private func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
//        
//        // This is the delegate'smethod that is called when a code is readed
//        for metadata in metadataObjects {
//            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
//            let code = readableObject.stringValue
//            
//            // If the code is not empty the code is ready and we call out delegate to pass the code.
//            if  code!.isEmpty {
//                print("is empty")
//                
//            }else {
//                
//                self.captureSession.stopRunning()
//                self.dismiss(animated: true, completion: nil)
////                self.delegate?.barcodeReaded(barcode: code!)
//                
//                
//            }
//        }
//    
//    
//    
//    
//    
//    }
    
    
    
    
    
    
    
    
    func setup()  {
        let frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        self.view.addSubview(self.qrView)
        self.qrView.delegate = self
        self.qrView.frame  =  frame
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func qrView(view: QRView, didCompletedWithQRValue: String) {
        mylog(didCompletedWithQRValue)
//        view.removeFromSuperview()
        self.delegate?.scannerComplate(code: didCompletedWithQRValue)
        self.complateHandle?(didCompletedWithQRValue)
//        self.navigationController?.popViewController(animated: false  )
//        self.removeFromParentViewController()
    }
    
    class func creatQRCode(string:String , imageToInsert : UIImage?) -> UIImage?{
    //  使用coreImage框架中的滤镜来实现生成的二维码
    //  kCICategoryBuiltIn 内置的过滤器的分类
    //  1.创建一个用于生成二维码的滤镜
//    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    let qrFilter = CIFilter(name: "CIQRCodeGenerator")
    //  2.设置默认值
    qrFilter?.setDefaults()
    //  3.设置输入数据
    qrFilter?.setValue(string.data(using: String.Encoding.utf8), forKey: "inputMessage")
    
    //  4.生成图片
        var ciImage = qrFilter?.outputImage
    //  默认生成的ciImage的大小是很小
    //  放大ciImage
        let scale = CGAffineTransform(scaleX: 8, y: 8);
        ciImage = ciImage?.transformed(by: scale)
    //  5.设置二维码的前景色和背景色
        let colorFilter = CIFilter(name: "CIFalseColor")
    //  设置默认值
    colorFilter?.setDefaults()
    //  设置输入的值
    /*
     inputImage,
     inputColor0,
     inputColor1
     */
    //    NSLog(@"%@",colorFilter.inputKeys);
        colorFilter?.setValue(ciImage, forKey: "inputImage")
    //  设置前景色
        colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
    //  设置背景
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
    //  取出colorFilter中的图片
        ciImage = colorFilter?.outputImage;
    //  在中心增加一张图片
        if let ciImageUnwrap = ciImage  {
            let image = UIImage(ciImage: ciImageUnwrap)
            //  生成图片
            //  1.开启图片的上下文
            UIGraphicsBeginImageContext(image.size);
            //  2.把二维码的图片划入
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            //  3.在中心画其他图片
            if let insertImg = imageToInsert {
                let  weiW : CGFloat = 40;
                let weiH : CGFloat = 40;
                let weiX = (image.size.width - weiW) * 0.5;
                let  weiY = (image.size.height - weiH) * 0.5;
                insertImg.draw(in: CGRect(x: weiX, y: weiY, width: weiW, height: weiH))
            }
            let  qrImageForReturn =  UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            return qrImageForReturn
        }
        UIGraphicsEndImageContext();
        return nil
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


/*
 -(void)creatQRCode
 {
 //  使用coreImage框架中的滤镜来实现生成的二维码
 //  kCICategoryBuiltIn 内置的过滤器的分类
 //    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
 //    NSLog(@"%@",filters);
 
 //  1.创建一个用于生成二维码的滤镜
 CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
 
 //  2.设置默认值
 [qrFilter setDefaults];
 
 //  3.设置输入数据
 //    NSLog(@"%@",qrFilter.inputKeys);
 
 [qrFilter setValue:[@"要生成的字符串内容" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
 
 //  4.生成图片
 CIImage *ciImage = qrFilter.outputImage;
 //  默认生成的ciImage的大小是很小
 //    NSLog(@"%@",ciImage);
 
 //  放大ciImage
 CGAffineTransform scale = CGAffineTransformMakeScale(8, 8);
 ciImage = [ciImage imageByApplyingTransform:scale];
 
 //  5.设置二维码的前景色和背景色
 CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
 //  设置默认值
 [colorFilter setDefaults];
 
 //  设置输入的值
 /*
 inputImage,
 inputColor0,
 inputColor1
 
 */
 //    NSLog(@"%@",colorFilter.inputKeys);
 [colorFilter setValue:ciImage forKey:@"inputImage"];
 
 //  设置前景色
 [colorFilter setValue:[CIColor colorWithRed:1 green:0 blue:0] forKey:@"inputColor0"];
 //  设置背景
 [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:1] forKey:@"inputColor1"];
 //  取出colorFilter中的图片
 ciImage = colorFilter.outputImage;
 
 //  在中心增加一张图片
 UIImage *image = [UIImage imageWithCIImage:ciImage];
 
 //  生成图片
 //  1.开启图片的上下文
 UIGraphicsBeginImageContext(image.size);
 //  2.把二维码的图片划入
 [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
 //  3.在中心画其他图片
 UIImage *weiImage = [UIImage imageNamed:@"bg_franchise"];//要插入的图片
 CGFloat weiW = 40;
 CGFloat weiH = 40;
 CGFloat weiX = (image.size.width - weiW) * 0.5;
 CGFloat weiY = (image.size.height - weiH) * 0.5;
 
 [weiImage drawInRect:CGRectMake(weiX, weiY, weiW, weiH)];
 
 //  取出图片
 //    UIImage *qrImage =  UIGraphicsGetImageFromCurrentImageContext();
 
 //  结束上下文
 UIGraphicsEndImageContext();
 
 //    self.imageView.image = qrImage;
 
 }

 
 */
