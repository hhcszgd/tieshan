//
//  LocationManager.swift
//  zuidilao
//
//  Created by w   y on 2019/9/15.
//  Copyright © 2019年 w   y. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager.init()
    override init() {
        super.init()
        //定位设置
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()//定位状态
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        //开始定位
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    let currentCity: PublishSubject<String> = PublishSubject<String>.init()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mylog(location.coordinate)
        let gecode = CLGeocoder.init()
        gecode.reverseGeocodeLocation(location) {[weak self](placemarks, error) in
            guard let place = placemarks?.first else {
                return
            }
            let addressDic = place.addressDictionary
            guard let city = addressDic?["City"] as? String else {
                return
            }
            self?.currentCity.onNext(city)
        }
    }
    
    
    let headTransform: PublishSubject<CGAffineTransform> = PublishSubject<CGAffineTransform>.init()
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //获取真北方向
        let trueHeading = newHeading.trueHeading
        //让指南针指向南面
        //将真北方向角度转换成angle
        let angle = Double.pi / 180 * trueHeading
        let transform = CGAffineTransform.init(rotationAngle: CGFloat(angle))
        self.headTransform.onNext(transform)
        
        
    }
    
    
    
    
    
}
