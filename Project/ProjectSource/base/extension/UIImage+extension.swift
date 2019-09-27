//
//  UIImage+extension.swift
//  zuidilao
//
//  Created by w   y on 2019/9/23.
//  Copyright © 2019年 w   y. All rights reserved.
//

import Foundation

extension UIImage {
    class func ImageWithColor(color: UIColor, frame: CGRect) -> UIImage? {
        let aframe = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(aframe)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
}

extension UIImage{
    func compressImageSize() -> UIImage {
        let dd = UIImageJPEGRepresentation(self, 1)
        if dd?.count ?? 0 > 900000{//压缩到大概1M以下
            UIGraphicsBeginImageContextWithOptions(self.size, true, 0.5)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width , height: self.size.height ))
            if let  newImage  = UIGraphicsGetImageFromCurrentImageContext(){
                UIGraphicsEndImageContext();
                guard let data = UIImageJPEGRepresentation(newImage, 1) else{
                    return newImage
                }
                guard let convertImage = UIImage(data: data) else{return newImage}
                return convertImage.compressImageSize()
            }else{
                return self
            }
            
        }
        return self
    }
    
    /// compressImageQuality
    ///
    /// - Parameters:
    ///   - quality: 0.0 ~ 1.0, 1.0 is the best quality
    func compressImageQuality( quality : CGFloat) -> UIImage {
        guard let data = UIImageJPEGRepresentation(self , quality) else{
            return self
        }
        guard let convertImage = UIImage(data: data) else{return self}
        return convertImage
    }
    func addWaterImage(_ waterImage : UIImage , waterImageRect : CGRect? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0)// 0 不压缩
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width , height: self.size.height))
        let waterImageRect = waterImageRect
        if let waterImageRect = waterImageRect{
            waterImage.draw(in: waterImageRect)
        }else{
            
            let waterSizeScale = self.size.width/8 * 6 / waterImage.size.width
            let waterW:CGFloat = waterImage.size.width * waterSizeScale
            let waterH : CGFloat = waterImage.size.height * waterSizeScale
            let waterX : CGFloat = self.size.width/8
            let waterY:CGFloat = self.size.height/2 - waterH/2
            let waterRect = CGRect(x: waterX, y: waterY, width: waterW, height: waterH)
            waterImage.draw(in: waterRect)
        }
        let  newImage  = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        let data = UIImageJPEGRepresentation(newImage!, 1)////最好一个参数起压缩作用
        guard let convertImage = UIImage(data: data!) else{return self}
        return convertImage
    }
    func writeImage(filePathLastComponent:String? = nil ) {
        let data = UIImageJPEGRepresentation(self,1)
        var homePathOrigin = NSHomeDirectory()
        if let filePathLastComponent = filePathLastComponent{
            homePathOrigin.append("/Library/\(filePathLastComponent)")
        }else{
            let fileName = "/Library/\(Date().timeIntervalSince1970)"
            homePathOrigin.append("\(fileName).jpeg")
        }
        let result1 = try?  data?.write(to: URL(fileURLWithPath: homePathOrigin))
    }
}



import UIKit
import SDWebImage
extension  UIImageView {
    func setImageUrl(url:String?) {
        if let urlStr = url , let urlInstence = URL(string: urlStr){
            self.sd_setImage(with: urlInstence, placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.retryFailed,SDWebImageOptions.cacheMemoryOnly])
        }else{
            self.image = DDPlaceholderImage
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
extension  UIButton {
    func setImageUrl(url:String? , status : UIControlState = .normal) {
        if let urlStr = url , let urlInstence = URL(string: urlStr){
            self.sd_setImage(with: urlInstence, for: status, placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.retryFailed,SDWebImageOptions.cacheMemoryOnly])
        }else{
            self.setImage(DDPlaceholderImage, for: status)
        }
    }
}
