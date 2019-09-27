//
//  DDADView.swift
//  Project
//
//  Created by WY on 2019/9/18.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

//how to use this class
/*
DDADView(paramete : "hello world" ).done = { paramete in
    mylog(paramete
    )
    let vc = UIViewController()
    vc.view.backgroundColor = .red
    self.navigationController?.pushViewController(vc , animated: true )
}// 广告视图
*/
import UIKit
import SDWebImage
///  广告视图
class DDADView: UIControl {
    let imageView = UIImageView()
    let jumpButton = UIButton()
    var timer : CADisplayLink?
    let timeBackView = UIView()
    var timeinterval : TimeInterval = 0
    let totalTime : TimeInterval = 5
    var done  : (( Any?) -> ())?
    var paramete : Any?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    convenience init(paramete : Any?) {
        self.init(frame: CGRect.zero)
        self.paramete = paramete
        if let window =  UIApplication.shared.keyWindow{
            window.addSubview(self)
            self.frame = window.bounds
        }
        self.backgroundColor = .white
        self.addSubview(imageView)
        self.addSubview(timeBackView)
        self.addSubview(jumpButton)
        //        self.imageView.image = UIImage(named:"addImage")
        self.showImage()
        jumpButton.addTarget(self , action: #selector(enterButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        jumpButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        jumpButton.setTitle("跳过", for: UIControlState.normal)
        self.addTarget(self , action: #selector(gotoAddView(sender:)), for: UIControlEvents.touchUpInside)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func showImage() {
        if let dict = paramete as? [String : String] , let url = dict["imageUrlStr"] , let imgUrl = URL(string:url){
            self.imageView.sd_setImage(with: imgUrl , placeholderImage: nil , options: [SDWebImageOptions.retryFailed,SDWebImageOptions.highPriority]) { (img , error , cachType , url ) in
                if img != nil {mylog("load ad image success")}
            }
        }
        
    }
    @objc func gotoAddView(sender:DDADView){
        let para = self.paramete
        self.done?(para)
        enterButtonClick(sender:nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonWH : CGFloat = 50
        jumpButton.layer.cornerRadius = buttonWH/2
        jumpButton.layer.masksToBounds = true
        let borderW : CGFloat = 0
        jumpButton.frame = CGRect(x: self.bounds.width - buttonWH - 20, y: DDStateBarHeight + buttonWH, width: buttonWH, height: buttonWH)
        timeBackView.frame = CGRect(x: jumpButton.frame.minX - borderW, y: jumpButton.frame.minY - borderW, width: jumpButton.frame.width + borderW * 2, height: jumpButton.frame.height + borderW  * 2)
        self.imageView.frame = self.bounds
        self.addTimer()
    }
    @objc func enterButtonClick(sender:UIButton?) {
        mylog("enter")
        self.invalidTimer()
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }) { (bool ) in
            self.removeFromSuperview()
        }
    }
    @objc func startDraw() {
        timeinterval += 1
        let scale = (timeinterval/60) / totalTime
//        mylog(scale)
        if scale >= 1 {
            invalidTimer()
            self.enterButtonClick(sender: self.jumpButton)
        }
        let angle = Double.pi * 2 * scale
        //        mylog(angle)
        let layer = CAShapeLayer.init()
        layer.lineWidth = 2;
        //圆环的颜色
        layer.strokeColor = UIColor.orange.cgColor;
        //背景填充色
        layer.fillColor = UIColor.clear.cgColor;
        //初始化一个路径
        let  path = UIBezierPath(arcCenter: CGPoint(x: timeBackView.bounds.width/2, y: timeBackView.bounds.width/2), radius: timeBackView.bounds.width/2 , startAngle: -CGFloat(Double.pi / 2), endAngle:CGFloat(angle) -  CGFloat(Double.pi / 2), clockwise: true)
        
        layer.path = path.cgPath
        self.timeBackView.layer.addSublayer(layer )
    }
    @objc func endDraw() {
        
    }
    func addTimer()  {
        self.invalidTimer()
        timer = CADisplayLink.init(target: self, selector: #selector(startDraw))
        timer?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        //        timer = Timer.init(timeInterval: 5, target: self, selector: #selector(startDraw), userInfo: nil , repeats: true )
        //        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    func invalidTimer() {
        self.endDraw()
        timeinterval = 0
        if let tempTimer  = timer {
            tempTimer.invalidate()
            timer = nil
        }
    }
    deinit {
        mylog("AD view destroyed")
    }
}
struct ADModel : Codable {
    var start_pic : String?//    启动页图片
    var link: String? //   启动页链接 空代表无连接，不空是为链接地址
    var type: String? // 类型1、活动启动页 2、开屏广告
}
