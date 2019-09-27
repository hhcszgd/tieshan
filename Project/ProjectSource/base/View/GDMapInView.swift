//
//  GDMapInView.swift
//  zjlao
//
//  Created by WY on 17/3/18.
//  Copyright © 2019年 com.16lao.zjlao. All rights reserved.
//



import UIKit
import MapKit
class GDMapInView: UIView , MKMapViewDelegate {
    var mapView : MKMapView = MKMapView()
    var needGobackCenter = true
     var camera = MKMapCamera.init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupSubViews()  {
        self.setupMapView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mapView.frame = self.bounds
    }
    override func didMoveToSuperview() {
        if self.superview != nil  {
        }
    }
    func setupMapView()  {
        
        self.mapView.frame =  self.bounds
        self.mapView.showsUserLocation = true

        self.mapView.delegate = self
        if #available(iOS 9.0, *) {
            self.mapView.showsScale = true
        } else {
            // Fallback on earlier versions
        }//比例尺
        if #available(iOS 9.0, *) {
            self.mapView.showsTraffic = false
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 9.0, *) {
            self.mapView.showsCompass = true
        } else {
            // Fallback on earlier versions
        }
//        map.userLocation//用户当前位置
        self.mapView.mapType = MKMapType.standard
        self.addSubview(self.mapView)
    }
    //防止内存占用过高//可是会导致3D视角失效
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        /*
         */
        let type = mapView.mapType
        switch (type) {
        case MKMapType.hybrid:
            self.mapView.mapType = MKMapType.standard;
            break;
        case MKMapType.standard:
            self.mapView.mapType = MKMapType.hybrid;
            break;
        default:
            break;
        }
        self.mapView.mapType = MKMapType.standard;
    }
    
    func addPlaceMarkWithTouches(touches: Set<UITouch>)  {
        let touch : UITouch = touches.first!;
        let point =  touch.location(in: self.mapView)
        let coornidate =  self.mapView.convert(point, toCoordinateFrom: self.mapView)
        let userLocation = GDLocation.init()
        mylog(self.mapView.annotations.count)//如果显示当前位置的话 , count 至少为1
        if self.mapView.showsUserLocation {
            if self.mapView.annotations.count % 2 ==  0 {
                userLocation.type = GDLocationType.origen
            }else {
                userLocation.type = GDLocationType.image1
            }
        }else{
            if self.mapView.annotations.count % 2 ==  0 {
                userLocation.type = GDLocationType.origen
            }else {
                userLocation.type = GDLocationType.image1
            }
        }
        userLocation.coordinate = coornidate
        userLocation.title = "title"
        userLocation.subtitle = "subTitle"
        let location = CLLocation.init(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        DDLocationManager.share.geoCoder.reverseGeocodeLocation(location) { (arr , error ) in
            let placeMark = arr?.first
            userLocation.title = placeMark?.country
            userLocation.subtitle = placeMark?.name
            mylog("country->\(placeMark?.country)")
            mylog("name->\(placeMark?.name)")
            mylog("administrativeArea->\(placeMark?.administrativeArea)")
            mylog("locality->\(placeMark?.locality)")
            mylog("ocean->\(placeMark?.ocean)")
            mylog("postalCode->\(placeMark?.postalCode)")
            mylog("subAdministrativeArea->\(placeMark?.subAdministrativeArea)")
            mylog("subLocality->\(placeMark?.subLocality)")
            mylog("subThoroughfare->\(placeMark?.subThoroughfare)")
            mylog("thoroughfare->\(placeMark?.thoroughfare)")
            /*
             country->Optional("中国")//国家
             name->Optional("看丹路39号")//最小单位地址,可能是个公司名,也可能跟街道重复
             administrativeArea->Optional("北京市")//省份
             locality->Optional("北京市") // 市
             ocean->nil // 当坐标在海里的时候才有值 , 如渤海
             postalCode->nil
             subAdministrativeArea->nil
             subLocality->Optional("丰台区")//区
             subThoroughfare->Optional("39号")
             thoroughfare->Optional("看丹路")//街道
             */
        }
        //        self.mapView?.addAnnotation((self.mapView?.userLocation)!)
        //            self.mapView?.showAnnotations([userLocation], animated: true)
        self.mapView.addAnnotation(userLocation)
//                self.mapView?.removeAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
//        self.mapView?.annotations//大头针数组
        //        }

    }
    
    // MARK: 注释 : 导航划线
    func drawLineMethod(sourceCoordinate : CLLocationCoordinate2D , destinationCoordinate : CLLocationCoordinate2D , transportType: MKDirectionsTransportType =  MKDirectionsTransportType.any)  {
            let tempRequest = MKDirectionsRequest.init()
            tempRequest.transportType = transportType
            tempRequest.source = MKMapItem.init(placemark: MKPlacemark.init(coordinate: sourceCoordinate , addressDictionary:nil ))
            tempRequest.destination = MKMapItem.init(placemark: MKPlacemark.init(coordinate: destinationCoordinate, addressDictionary:nil ))
            let tempDerection : MKDirections = MKDirections.init(request: tempRequest)
            tempDerection.calculate(completionHandler: { (resp, error ) in
                if error == nil {
                    if let route = resp?.routes.last{
                        self.mapView.addOverlays([route.polyline])
                    }else{
                        mylog("error")
                    }
                }else{
                    mylog(error)
                }
                /*
                 resp'properties:
                 let routes : [MKRoute]= respons?.routes//线路数组(多种方案)
                 let route = routes.first
                 route.name : 线路名称
                 route.distance : 距离
                 expectedTravelTime : 语句时间
                 polyline : 折线(数据模型)
                 let steps : [MKRouteStep] = route.first.steps
                 let step = steps.first
                 step.instructions : 导航提示语
                 */

            })
    }

    ///
    
    ////delegate 
    
    ////
    
    //MARK: 获取两个坐标之间的路线resp?.routes
    func getRoutes(sourceCoordinate : CLLocationCoordinate2D , destinationCoordinate : CLLocationCoordinate2D , complate : @escaping (_ response : MKDirectionsResponse? )->())  {
        if #available(iOS 10.0, *) {
            let tempRequest = MKDirectionsRequest.init()
            tempRequest.source = MKMapItem.init(placemark: MKPlacemark.init(coordinate: sourceCoordinate))
            tempRequest.destination = MKMapItem.init(placemark: MKPlacemark.init(coordinate: destinationCoordinate))
            let tempDerection : MKDirections = MKDirections.init(request: tempRequest)
            tempDerection.calculate(completionHandler: { (resp, error ) in
                if error != nil {complate(nil) ;return}
                /*
                 resp'properties:
                 let routes : [MKRoute]= respons?.routes//线路数组(多种方案)
                 let route = routes.first
                 route.name : 线路名称
                 route.distance : 距离
                 expectedTravelTime : 语句时间
                 polyline : 折线(数据模型)
                 let steps : [MKRouteStep] = route.first.steps
                 let step = steps.first
                 step.instructions : 导航提示语
                 */
                    complate(resp)
            })
        } else {
            // Fallback on earlier versions
            complate(nil)
        }
    }
   
    //执行划线
    func performDrawLint (polyline: MKPolyline)  {
        self.mapView.add(polyline)
    }
    // MARK: 注释 : (划线用的代理方法)添加覆盖层后调用
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        if overlay.isKind(of: MKPolyline.self ) {
            
            let lineRender = MKPolylineRenderer.init(overlay: overlay)
            lineRender.lineWidth = 5
            //lineRender.fillColor = UIColor.red
            lineRender.strokeColor = UIColor.purple
            return lineRender
        }
        if overlay.isKind(of: MKCircle.self ) {
            let lineRender = MKCircleRenderer.init(overlay: overlay)
            lineRender.alpha = 0.5
            lineRender.fillColor = UIColor.red
            //lineRender.strokeColor = UIColor.purple
            return lineRender
        }
        
        return MKOverlayRenderer()
    }
    
    
    
    
    
    // MARK: 注释 : 获取地图截图
    func getshotScreen() {
        let options = MKMapSnapshotOptions()
        //options.size = CGSize(width: 200, height: 200)
        let snapShotter  : MKMapSnapshotter = MKMapSnapshotter.init(options: options)
        snapShotter.start { (snapShot, error ) in
            mylog(snapShot?.image)
        }
    }
    
    // MARK: 注释 : 3D视角
    func setup3D()  {
        
        let camera = MKMapCamera.init(lookingAtCenter: CLLocationCoordinate2D.init(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude), fromEyeCoordinate: CLLocationCoordinate2D.init(latitude: self.mapView.centerCoordinate.latitude - 0.005, longitude: self.mapView.centerCoordinate.longitude), eyeAltitude: 21.0)//3D视角
        self.camera = camera
        self.mapView.setCamera(camera, animated: true)
    }
    
    //实时获取用户位置代理
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        mylog("get current location : \(userLocation.coordinate)")
//        mapView.setCenter(userLocation.coordinate, animated: true)//设置当前位置到屏幕中心
        if needGobackCenter {
            needGobackCenter = false
            self.settheUserLocationToScreenCenter(location:userLocation)//实时设置当前位置到屏幕中心
        }
    }
    //实时设置位置到屏幕中心
    func settheUserLocationToScreenCenter(location: MKUserLocation)  {
        mapView.setCenter(location.coordinate, animated: true)//设置当前位置到屏幕中心
        let span :  MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.010001, longitudeDelta: 0.010001)//初始显示范围,值越小越精确
        let  region: MKCoordinateRegion = MKCoordinateRegion.init(center:location.coordinate, span: span)
        mapView.setRegion(region, animated: true)//当region改变的时候设置这些
    }
    //返回大头针视图的代理
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if  annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude && annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude {//用户当前的位置正常返回蓝圈
            return nil
        }else{//其他的返回(自定义)大头针
            if let gdLocation  = annotation as? GDLocation {
                if gdLocation.type == GDLocationType.origen {//
                   return returnCustomAnnotationView(mapView, viewFor: annotation)
                }else if (gdLocation.type == GDLocationType.image1){
                    return self.returnCustomAnnotationViewWithImage(mapView, viewFor: annotation)
                }else{
                    return nil
                }
            }else{
                return nil
            }
        }
    }
    //返回图片大头针
    func returnCustomAnnotationViewWithImage(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "placeMark")
        if view == nil  {
            view = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "placeMark")
        }
            view?.annotation = annotation
            view?.canShowCallout = true//不用图片的时候使用 , 弹出常规的文字
            view?.isDraggable = true
        
            view?.image = UIImage(named: "ar_back")
//        view?.leftCalloutAccessoryView/rightCalloutAccessoryView//标题弹窗的左右视图
//        view.detailCalloutAccessoryView//标题弹窗的subTitle位置
            return view //
     }

    //返回系统大头针,(只是自定义颜色)
    func returnCustomAnnotationView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "placeMark")
        if view == nil  {
            view = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "placeMark")
        }
        if let subView  = view as? MKPinAnnotationView {
            subView.annotation = annotation
            subView.canShowCallout = true//不用图片的时候使用 , 弹出常规的文字
            subView.animatesDrop = true
            subView.isDraggable = true
            if #available(iOS 9.0, *) {
                subView.pinTintColor = UIColor.red
            } else {
                /**
                 MKPinAnnotationColorRed = 0,
                 MKPinAnnotationColorGreen,
                 MKPinAnnotationColorPurple
                 */
                subView.pinColor = MKPinAnnotationColor.red
            }
            return subView //
        }else{
            return nil  //默认是系统
        }
    }
    

    
}
