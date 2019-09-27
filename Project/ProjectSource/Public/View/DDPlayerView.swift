//
//  DDPlayerView.swift
//  TestAVPlayerLayer
//
//  Created by WY on 2019/9/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import AVKit
class DDPlayerView: UIView {
    let imageView = UIImageView()
    var playerLayer : AVPlayerLayer?
    let bottomBar = DDPlayerControlBar()
    private var ddSuperView : UIView?
    private var frameInDDSuperView : CGRect?
    private var currentItemTotalTime : Double = 0
    private var indicatorView = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    private var tapCount : Int = 0
    private var isBuffering : Bool = false
    private var needRemoveObserver : Bool = false
    var currentUrl : String?
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.playerLayer?.player?.pause()
        self.playerLayer = nil
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
        self.imageView.frame = self.bounds
        bottomBar.frame = CGRect(x: 0, y: self.bounds.height - 40, width: self.bounds.width, height: 40)
        indicatorView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        if let size = playerLayer?.player?.currentItem?.presentationSize , size != CGSize.zero{
            var realH = self.bounds.width * size.height / size.width
            if realH > self.bounds.height {//以宽为标准
                realH = self.bounds.height
            }
            self.bottomBar.frame = CGRect(x: 0, y: self.bounds.height / 2 + realH / 2 - 40, width: self.bounds.width, height: 40)
            self.bringSubview(toFront: self.bottomBar)
            self.bringSubview(toFront: imageView)
        }
        self.superview?.bringSubview(toFront: self)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.bottomBar.delegate = self
        addToWindow()
        _addsubViews()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if !self.bottomBar.isHidden {
                UIView.animate(withDuration: 1, animations: {
                    self.bottomBar.isHidden = true
                })
            }
        }
    }
    func setPlaceholderImage(imgUrlStr : String?) {
        self.imageView.image = nil
        self.imageView.setImageUrl(url: imgUrlStr)
    }
    ///the only way to set movie url
    func replaceCurrentMovieItemWith(urlStr:String,placeholderImgUrlStr : String? = nil ) {
//        let urlStr =
        if let placeholderImgUrlStr = placeholderImgUrlStr {
//            self.imageView.image = nil
            self.imageView.isHidden = false
            self.imageView.setImageUrl(url: placeholderImgUrlStr)
        }else{
            self.imageView.isHidden = true
        }
        currentUrl = urlStr
        
//        if let url = URL(string: "https://www.bilibili.com/328b803e-1646-184b-a0b8-f27516c76b41"){
        if let url = URL(string: urlStr){
            if needRemoveObserver{
                self.removePlayerObserver()
            }
            let item = AVPlayerItem.init(url: url)
            self.playerLayer?.player?.replaceCurrentItem(with: item)
            self.playerLayer?.player?.pause()
            self.bottomBar.configUIWhenPlayEnd()
            self.playerLayer?.player?.currentItem?.seek(to: kCMTimeZero, completionHandler: nil )
            self.addPlayerObserver()
            currentItemTotalTime = 0
            
        }
    }
    func _addsubViews()  {
        self.addSubview(bottomBar)
        bottomBar.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(indicatorView)
        indicatorView.hidesWhenStopped = true
        indicatorView.activityIndicatorViewStyle = .gray
        self.bottomBar.isHidden = true
        self.addSubview(imageView)
        self.imageView.isHidden = true
    }
    func addToWindow()  {
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            window.addSubview(self)
        }
    }
    func addToSuperView()  {
        if let ddsuperView = ddSuperView{
            self.removeFromSuperview()
            ddsuperView.addSubview(self )
        }
    }
    deinit {
        mylog("is player desdroyed ?")
//        removePlayerObserver()
    }
    
    convenience init(frame:CGRect  , superView:UIView? = nil,urlStr : String ,placeholderImgUrlStr : String? = nil ){
        self.init(frame: frame)
        if let placeholderImgUrlStr = placeholderImgUrlStr {
            //            self.imageView.image = nil
            self.imageView.isHidden = false
            self.imageView.setImageUrl(url: placeholderImgUrlStr)
        }else{
            self.imageView.isHidden = true
        }
        ddSuperView = superView
        frameInDDSuperView = frame
        self.addToSuperView()
        currentUrl = urlStr
        if let url = URL(string: urlStr){
            let playItem = AVPlayerItem.init(url: url)
            let player = AVPlayer.init(playerItem: playItem)
            playerLayer = AVPlayerLayer.init(player: player)
            self.addPlayerObserver()
            self.configPlayer()
        }
    }
    func removePlayerObserver() {//在更新item的地方移除通知再添加
        
        playerLayer?.player?.currentItem?.removeObserver(self , forKeyPath: "status")
        if #available(iOS 10.0, *) {
            playerLayer?.player?.removeObserver(self , forKeyPath: "timeControlStatus")
        }else{
            playerLayer?.player?.removeObserver(self , forKeyPath: "rate")
            playerLayer?.player?.currentItem?.removeObserver(self , forKeyPath: "playbackBufferEmpty")
            playerLayer?.player?.currentItem?.removeObserver(self , forKeyPath: "playbackLikelyToKeepUp")
        }
    }
    func addPlayerObserver()  {
        needRemoveObserver = true 
        playerLayer?.player?.currentItem?.addObserver(self , forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil )
        //        playerLayer?.player?.addObserver(self , forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil )
        
        if #available(iOS 10.0, *) {
            playerLayer?.player?.addObserver(self , forKeyPath: "timeControlStatus", options: NSKeyValueObservingOptions.new, context: nil )
            }else{
            
            playerLayer?.player?.addObserver(self , forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil )
            
            playerLayer?.player?.currentItem?.addObserver(self , forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil )//缓冲中
            playerLayer?.player?.currentItem?.addObserver(self , forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil )//缓冲完毕
            
        }
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath ?? "" == "status"{
            if let statusRewValue = change?[NSKeyValueChangeKey.newKey] as? Int{
                if let status  = AVPlayerItemStatus.init(rawValue: statusRewValue){
                    switch status{
                    case .failed:
                        print("失败")
                        break
                    case .readyToPlay:
                        print("准备播放")
                        if !self.imageView.isHidden {self.imageView.isHidden = true}
                        isBuffering = false
                        indicatorView.stopAnimating()
                        self.bottomBar.isHidden = false
                        if let duration = self.playerLayer?.player?.currentItem?.duration {
                            let seconds = duration.seconds
                            currentItemTotalTime = seconds
                            bottomBar.configSlider(minimumValue: 0.0, maximumValue: Float(seconds))
                        }else {
                            bottomBar.configSlider(minimumValue: 0.0, maximumValue: 0.0)
                        }
                        let value = Float((self.playerLayer?.player?.currentItem?.currentTime() ?? kCMTimeZero).seconds)
                        self.bottomBar.configSliderValue(value:value)
                        self.bringSubview(toFront: bottomBar)
                        layoutIfNeeded()
                        setNeedsLayout()
                        break
                    case .unknown:
                        print("未知")
                        break
                    }
                }
            }
        }else if keyPath ?? "" == "timeControlStatus"{
            if let statusRewValue = change?[NSKeyValueChangeKey.newKey] as? Int{
                configControlBar(statusRewValue:statusRewValue)
            }
        }else if keyPath ?? "" == "rate"{
            print("--->\(#line) ::: \(self.playerLayer?.player?.rate)")
            if self.playerLayer?.player?.rate ?? 0 == 0.0 {//暂停
                if let currentTime =  self.playerLayer?.player?.currentItem?.currentTime() {
                    if Int(currentItemTotalTime) == Int(currentTime.seconds) && currentItemTotalTime != 0{//播放完毕
                        ///重置界面到初始状态
                        self.bottomBar.configUIWhenPlayEnd()
                        self.playerLayer?.player?.currentItem?.seek(to: kCMTimeZero, completionHandler: nil )
                        currentItemTotalTime = 0
                    }else{//暂停
                        self.bottomBar.configUIWhenPause()
                    }
                }
            }else if self.playerLayer?.player?.rate ?? 0 == 1.0 {//播放
                self.bottomBar.configUIWhenPlaying()
                if !self.imageView.isHidden {self.imageView.isHidden = true}
                indicatorView.stopAnimating()
            }
        }else if keyPath ?? "" == "playbackBufferEmpty"{
            print("--->\(#line) ::: stop ?")
            isBuffering = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                if self.isBuffering{//执行转圈, 更新播放按钮
                    self.indicatorView.startAnimating()
                    self.bringSubview(toFront: self.indicatorView)
                }
            }
        }else if keyPath ?? "" == "playbackLikelyToKeepUp"{
            print("--->\(#line) ::: continue ?")
            if !self.imageView.isHidden {self.imageView.isHidden = true}
            isBuffering = false
            self.indicatorView.stopAnimating()
            if let duration = self.playerLayer?.player?.currentItem?.duration {
                let seconds = duration.seconds
                currentItemTotalTime = seconds
            }
        } else{super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)}
        
    }
    func destroy()  {
        self.removePlayerObserver()
        self.playerLayer?.player?.pause()
        self.playerLayer?.player = nil
        self.playerLayer?.removeFromSuperlayer()
        self.removeFromSuperview()
    }
    func configControlBar(statusRewValue:Int?){//AVPlayerTimeControlStatus不兼容ios9
        if #available(iOS 10.0, *) {
            if let status  = AVPlayerTimeControlStatus.init(rawValue: statusRewValue ?? 0){
                switch status{
                case .paused:
                    print("暂停")//更新播放按钮
                    if let currentTime =  self.playerLayer?.player?.currentItem?.currentTime() {
                        if currentItemTotalTime - currentTime.seconds < 1 && currentItemTotalTime != 0{//播放完毕
                            ///重置界面到初始状态
                            self.bottomBar.configUIWhenPlayEnd()
                            self.playerLayer?.player?.currentItem?.seek(to: kCMTimeZero, completionHandler: nil )
                            currentItemTotalTime = 0
                        }else{//暂停
                            self.bottomBar.configUIWhenPause()
                        }
                    }
                case .playing:
                    print("播放中")//取消转圈并播放,更新播放按钮
                    if !self.imageView.isHidden {self.imageView.isHidden = true}
                    self.bottomBar.configUIWhenPlaying()
                    if let duration = self.playerLayer?.player?.currentItem?.duration {
                        let seconds = duration.seconds
                        currentItemTotalTime = seconds
                    }
                    indicatorView.stopAnimating()
                    break
                case .waitingToPlayAtSpecifiedRate:
                    print("等待 到特定的比率去播放")//
                    self.bottomBar.configUIWhenPause()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        if #available(iOS 10.0, *) {
                            if let tempStatus = self.playerLayer?.player?.timeControlStatus , tempStatus == .waitingToPlayAtSpecifiedRate{//执行转圈, 更新播放按钮
                                self.indicatorView.startAnimating()
                                self.bringSubview(toFront: self.indicatorView)
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    break
                }
            }
        }else{
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touches")
        self.bottomBar.perfomrTap()
    }
    
    func configPlayer() {
        if let playLayer = playerLayer{
            self.layer.addSublayer(playLayer)
            playLayer.frame = self.bounds
            playLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            playLayer.contentsScale = UIScreen.main.scale
            self.addPeriodicTimeObserver()
            self.addBoundaryTimeObserver()
        }
    }
    
    
    func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 1,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        // Add time observer
        let timeObserverToken =
            playerLayer?.player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) {
                [weak self] time in
                // update player transport UI
                print("\(#line)")
                if let isAnimating = self?.indicatorView.isAnimating , isAnimating  {self?.indicatorView.stopAnimating()}
                let value = Float((self?.playerLayer?.player?.currentItem?.currentTime() ?? kCMTimeZero).seconds)
                self?.bottomBar.configSliderValue(value:value)
                
        }
    }
    func addBoundaryTimeObserver() {
        
        let assetDuration = self.playerLayer?.player?.currentItem?.duration ?? kCMTimeZero
        var times = [NSValue]()
        // Set initial time to zero
        var currentTime = kCMTimeZero
        // Divide the asset's duration into quarters.
        let interval = CMTimeMultiplyByFloat64(assetDuration, 0.25)
        
        // Build boundary times at 25%, 50%, 75%, 100%
        while currentTime < assetDuration {
            currentTime = currentTime + interval
            times.append(NSValue(time:currentTime))
        }
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        // Add time observer
        let timeObserverToken =
            playerLayer?.player?.addBoundaryTimeObserver(forTimes: times, queue: mainQueue) {
                [weak self]  in
                // Update UI
                print("\(#line)")
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDPlayerView : DDPlayerControlDelegate{
    func screenChanged(isFullScreen: Bool) {
        if isFullScreen {
            if let window = UIApplication.shared.keyWindow{
                window.addSubview(self)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"PeiXunMovieFullScreen"), object: nil )
                UIView.animate(withDuration: 0.25) {
                    self.bounds = CGRect(x: 0, y: 0, width: window.bounds.height, height: window.bounds.width)
                    self.center = CGPoint(x: window.bounds.width/2, y: window.bounds.height/2)
                    
                    self.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2))
                }
                self.playerLayer?.frame = self.bounds
                //                self.configControlViews()
                
            }
        }else{
            if let _superView = ddSuperView{
                _superView.addSubview(self)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"PeiXunMovieSmallScreen"), object: nil )
                UIView.animate(withDuration: 0.25) {
                    self.transform = CGAffineTransform.identity
                    self.frame = self.frameInDDSuperView ?? CGRect.zero
                    self.playerLayer?.frame = self.bounds
                    
                }
                //                self.configControlViews()
                
            }
        }
    }
    
    func sliderChanged(sender: DDSlider) {
        let seconds = sender.value
        //        CMTimeMakeWithSeconds
        let targetTime =  CMTimeMakeWithSeconds(Float64(seconds), self.playerLayer?.player?.currentItem?.currentTime().timescale ?? Int32(0));
        self.playerLayer?.player?.seek(to: targetTime, completionHandler: { (bool ) in
            
        })
    }
    
    func pressToPlay() {
        self.playerLayer?.player?.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if self.playerLayer?.player?.rate == 0.0{                
                self.indicatorView.startAnimating()
            }
        }
    }
    
    func pressToPause() {
        self.playerLayer?.player?.pause()
    }
    
    
}

class DDSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setThumbImage(UIImage(named:"playdragging"), for: UIControlState.normal)
        self.setThumbImage(UIImage(named:"playdragging"), for: UIControlState.highlighted)
        self.minimumTrackTintColor = UIColor.orange
        self.maximumTrackTintColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func trackRect(forBounds bounds: CGRect) -> CGRect{
        let rect = super.trackRect(forBounds: bounds)
        return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: 6)
    }
    
}


enum DDPlayerControlBarStyle : Int  {
    case smallScreen = 0
    case fullScreen
}
protocol DDPlayerControlDelegate : NSObjectProtocol{
    func screenChanged(isFullScreen:Bool)
    func sliderChanged(sender:DDSlider)
    func pressToPlay()
    func pressToPause()
}
class DDPlayerControlBar: UIView {
    var style : DDPlayerControlBarStyle = .smallScreen{
        didSet{
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    let playButton = UIButton()
    let slider = DDSlider()
    private var currentItemTotalTime : Double = 0
    private let fullScreenButton = UIButton()
    private var tapCount : Int = 0
    weak var delegate : DDPlayerControlDelegate?
    private var hasPlayedTimeLabel : UILabel = UILabel()
    private var leftTimeLabel : UILabel = UILabel()
    private var fullScreenTimeLabel : UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        _addsubViews()
    }
    func _addsubViews()  {
        
        self.addSubview(playButton)
        self.addSubview(slider)
        self.addSubview(fullScreenButton)
        
        self.addSubview(hasPlayedTimeLabel)
        self.addSubview(leftTimeLabel)
        self.addSubview(fullScreenTimeLabel)
//        fullScreenButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        playButton.imageEdgeInsets =  UIEdgeInsetsMake(8, 8, 8, 8)
        fullScreenButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
//        fullScreenButton.contentVerticalAlignment = .fill
//        fullScreenButton.contentHorizontalAlignment = .fill
//        playButton.imageView?.contentMode = .scaleAspectFill
//        fullScreenButton.imageView?.contentMode = .scaleAspectFill
        //        hasPlayedTimeLabel.text = "11:11"
        //        leftTimeLabel.text = "12:12"
        //        fullScreenTimeLabel.text = "12:12/33:33"
        hasPlayedTimeLabel.font = GDFont.systemFont(ofSize: 14)
        leftTimeLabel.font = GDFont.systemFont(ofSize: 14)
        fullScreenTimeLabel.font = GDFont.systemFont(ofSize: 14)
        hasPlayedTimeLabel.textAlignment = .center
        leftTimeLabel.textAlignment = .center
        fullScreenTimeLabel.textAlignment = .center
        
        hasPlayedTimeLabel.textColor = UIColor.white
        leftTimeLabel.textColor = UIColor.white
        fullScreenTimeLabel.textColor = UIColor.white
        
        slider.addTarget(self , action: #selector(sliderChanged(sender:)), for: UIControlEvents.valueChanged)
        //        fullScreenButton.setTitle("全屏", for: UIControlState.normal)//full screen
        //        fullScreenButton.setTitle("小屏", for: UIControlState.selected)//not full screen
        //        playButton.setTitle("播放", for: UIControlState.normal)//play
        //        playButton.setTitle("暂停", for: UIControlState.selected)//pause
        fullScreenButton.setImage(UIImage(named:"fullscreenbutton"), for: UIControlState.normal)
        fullScreenButton.setImage(UIImage(named:"shrinkscreen"), for: UIControlState.selected)
        playButton.setImage(UIImage(named:"playbutton"), for: UIControlState.normal)
        playButton.setImage(UIImage(named:"stopbutton"), for: UIControlState.selected)
        playButton.addTarget(self , action: #selector(playButtonAction(sender:)), for: UIControlEvents.touchUpInside)
//        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        fullScreenButton.addTarget(self , action: #selector(fullScreenButtonAction(sender:)), for: UIControlEvents.touchUpInside)
    }
    @objc func sliderChanged(sender:DDSlider){
        performDelayHidden()
        self.delegate?.sliderChanged(sender: sender)
    }
    @objc func playButtonAction(sender:UIButton)  {
        performDelayHidden()
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.delegate?.pressToPlay()
        }else{
            self.delegate?.pressToPause()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonToBorder : CGFloat = 0
        let buttonY = buttonToBorder
        let buttonH = self.bounds.height - buttonToBorder * 2
        let buttonToScreen : CGFloat = 20
        let smallScreenTimeLabelWidth : CGFloat = 44
        switch style {
        case .smallScreen:
            playButton.frame = CGRect(x: buttonToScreen, y: buttonY,width: buttonH, height: buttonH)
            fullScreenButton.frame = CGRect(x: self.bounds.width - (buttonToScreen + buttonH), y: buttonY,width: buttonH, height: buttonH)
            
            
            hasPlayedTimeLabel.frame = CGRect(x: playButton.frame.maxX , y: buttonY,width: smallScreenTimeLabelWidth, height: buttonH)
            leftTimeLabel.frame = CGRect(x: fullScreenButton.frame.minX - smallScreenTimeLabelWidth, y: buttonY,width: smallScreenTimeLabelWidth, height: buttonH)
//            hasPlayedTimeLabel.sizeToFit()
//            leftTimeLabel.sizeToFit()
//            hasPlayedTimeLabel.frame = CGRect(x: playButton.frame.maxX + buttonToBorder, y: buttonY,width: hasPlayedTimeLabel.bounds.width, height: buttonH)
//            leftTimeLabel.frame = CGRect(x: fullScreenButton.frame.minX - (buttonToScreen + leftTimeLabel.bounds.width), y: buttonY,width: leftTimeLabel.bounds.width, height: buttonH)
            fullScreenTimeLabel.isHidden = true
            hasPlayedTimeLabel.isHidden = false
            leftTimeLabel.isHidden = false
            let sliderLeftRightMargin : CGFloat = 1
            let sliderH : CGFloat = 26
            slider.frame =  CGRect(x: hasPlayedTimeLabel.frame.maxX + sliderLeftRightMargin, y: self.bounds.height/2 - sliderH/2,width: leftTimeLabel.frame.minX - (hasPlayedTimeLabel.frame.maxX + sliderLeftRightMargin * 2), height: sliderH)
            //            slider.center = CGPoint(x:self.bounds.width/2  , y : self.bounds.height/2)
            
        case .fullScreen:
            fullScreenTimeLabel.isHidden = false
            hasPlayedTimeLabel.isHidden = true
            leftTimeLabel.isHidden = true
            playButton.frame = CGRect(x: buttonToScreen, y: buttonY,width: buttonH, height: buttonH)
            fullScreenButton.frame = CGRect(x: self.bounds.width - (buttonToScreen + buttonH), y: buttonY,width: buttonH, height: buttonH)
            
            let sliderLeftRightMargin : CGFloat = 10
            slider.bounds =  CGRect(x: 0, y: 0,width: fullScreenButton.frame.minX - (playButton.frame.maxX + sliderLeftRightMargin * 2), height: 40)
            slider.center = CGPoint(x:self.bounds.width/2  , y : playButton.frame.minY)
            fullScreenTimeLabel.sizeToFit()
            fullScreenTimeLabel.frame = CGRect(x: slider.frame.minX, y: playButton.frame.midY, width: fullScreenTimeLabel.bounds.width, height: playButton.bounds.height/2)
            
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func configSlider(minimumValue:Float ,maximumValue : Float){
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
    }
    func configSliderValue(value : Float){
        slider.value = value
        let hasPlayHours = Int(value) / 3600
        let hasPlayHoursString = String(format: "%02d", hasPlayHours)
        
        let hasPlayMinuts = (Int(value) % 3600) / 60
        let hasPlayMinutsString = String(format: "%02d", hasPlayMinuts)
        
        let hasPlaySeconds = (Int(value) % 60)
        let hasPlaySecondsString = String(format: "%02d", hasPlaySeconds)
        
        let leftPlayHours = Int(slider.maximumValue - value) / 3600
        let leftPlayHoursString = String(format: "%02d", leftPlayHours)
        
        let leftPlayMinuts = (Int(slider.maximumValue - value) % 3600) / 60
        let leftPlayMinutsString = String(format: "%02d", leftPlayMinuts)
        
        let leftPlaySeconds = (Int(slider.maximumValue - value) % 60)
        let leftPlaySecondsString  = String(format: "%02d", leftPlaySeconds)
        
        let totalPlayHours = Int(slider.maximumValue ) / 3600
        let totalPlayHoursString = String(format: "%02d", totalPlayHours)
        
        let totalPlayMinuts = (Int(slider.maximumValue) % 3600) / 60
        let totalPlayMinutsString = String(format: "%02d", totalPlayMinuts)
        
        let totalPlaySeconds = (Int(slider.maximumValue) % 60)
        let totalPlaySecondsString = String(format: "%02d", totalPlaySeconds)
//        let hasPlayStr = hasPlayHours == 0 ? "\(hasPlayMinuts):\(hasPlaySeconds)" : "\(hasPlayHours):\(hasPlayMinuts):\(hasPlaySeconds)"
        let hasPlayStr = hasPlayHours == 0 ? "\(hasPlayMinutsString):\(hasPlaySecondsString)" : "\(hasPlayHoursString):\(hasPlayMinutsString):\(hasPlaySecondsString)"
        let leftStr =  leftPlayHours == 0 ? "\(leftPlayMinutsString):\(leftPlaySecondsString)" : "\(leftPlayHoursString):\(leftPlayMinutsString):\(leftPlaySecondsString)"
        let totalStr =  totalPlayHours == 0 ? "\(totalPlayMinutsString):\(totalPlaySecondsString)" : "\(totalPlayHoursString):\(totalPlayMinutsString):\(totalPlaySecondsString)"
        self.hasPlayedTimeLabel.text = hasPlayStr
        self.leftTimeLabel.text = leftStr
        self.fullScreenTimeLabel.text = "\(hasPlayStr)/\(totalStr)"
        layoutIfNeeded()
        setNeedsLayout()
    }
    /*
     func configSliderValue(value : Float){
     slider.value = value
     let hasPlayHours = Int(value) / 3600
     var hasPlayMinuts = (Int(value) % 3600) / 60
     let hasPlaySeconds = (Int(value) % 60)
     
     let leftPlayHours = Int(slider.maximumValue - value) / 3600
     let leftPlayMinuts = (Int(slider.maximumValue - value) % 3600) / 60
     let leftPlaySeconds = (Int(slider.maximumValue - value) % 60)
     
     let totalPlayHours = Int(slider.maximumValue ) / 3600
     let totalPlayMinuts = (Int(slider.maximumValue) % 3600) / 60
     let totalPlaySeconds = (Int(slider.maximumValue) % 60)
     
     let hasPlayStr = hasPlayHours == 0 ? "\(hasPlayMinuts):\(hasPlaySeconds)" : "\(hasPlayHours):\(hasPlayMinuts):\(hasPlaySeconds)"
     let leftStr =  leftPlayHours == 0 ? "\(leftPlayMinuts):\(leftPlaySeconds)" : "\(leftPlayHours):\(leftPlayMinuts):\(leftPlaySeconds)"
     let totalStr =  totalPlayHours == 0 ? "\(totalPlayMinuts):\(totalPlaySeconds)" : "\(totalPlayHours):\(totalPlayMinuts):\(totalPlaySeconds)"
     self.hasPlayedTimeLabel.text = hasPlayStr
     self.leftTimeLabel.text = leftStr
     self.fullScreenTimeLabel.text = "\(hasPlayStr)/\(totalStr)"
     layoutIfNeeded()
     setNeedsLayout()
     }
     */
    @objc func fullScreenButtonAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        performDelayHidden()
        if sender.isSelected{//全屏
            self.style = .fullScreen
            self.delegate?.screenChanged(isFullScreen: true )
            rootNaviVC?.setNeedsStatusBarAppearanceUpdate()
        }else{//小屏
            self.style = .smallScreen
            self.delegate?.screenChanged(isFullScreen: false  )
        }
    }
    func updateTime(time:TimeInterval) {
        
    }
    func configUIWhenPause() {
        self.playButton.isSelected = false
    }
    func configUIWhenPlaying() {
        self.playButton.isSelected = true
    }
    func configUIWhenPlayEnd() {
        performDelayHidden()
        UIView.animate(withDuration: 1, animations: {
            self.isHidden = false
        })
        self.playButton.isSelected = false
        self.slider.value = 0.0
    }
    func perfomrTap() {
        
        if self.isHidden{
            performDelayHidden()
            UIView.animate(withDuration: 1, animations: {
                self.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 1, animations: {
                self.isHidden = true
            })
        }
    }
    private func performDelayHidden(){
        tapCount += 1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if !self.isHidden {
                self.tapCount -= 1
                if self.tapCount == 0{
                    UIView.animate(withDuration: 1, animations: {
                        self.isHidden = true
                    })
                }
                
            }
        }
    }
    
    
}
