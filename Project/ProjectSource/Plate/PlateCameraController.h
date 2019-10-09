//
//  PlateCameraController.h
//  PlateDemo
//
//  Created by DXY on 2017/7/13.
//  Copyright © 2017年 DXY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kPlateDeviceDirectionUp,
    kPlateDeviceDirectionLeft,
    kPlateDeviceDirectionRight,
    kPlateDeviceDirectionUpsideDown
} PlateDeviceDirection;


@protocol PlateCameraDelegate <NSObject>

@required
/**
 识别成功回调

 @param cameraController 相机控制器
 @param plateStr 车牌号
 @param plateColor 车牌颜色
 @param plateImage 车牌图像
 @param fullImage 完整图像
 */
- (void)cameraController:(UIViewController *)cameraController recognizePlateSuccessWithResult:(NSString *)plateStr plateColor:(NSString *)plateColor plateImage:(UIImage *)plateImage squareImage:(UIImage *)squareImage andFullImage:(UIImage *)fullImage;

@optional
/**
 点击取消回调

 @param cameraController 相机控制器(内部已pop和dismiss,外部无需做,此回调为混合开发项目提供)
 */
- (void)backButtonClickWithPlateCameraController:(UIViewController *)cameraController;

@end



@interface PlateCameraController : UIViewController


@property (nonatomic, weak) id <PlateCameraDelegate> delegate;

/**
 * 最后的缩放比例
 */
@property (nonatomic, assign) CGFloat effectiveScale;


/**
 设备当前锁定方向
 */
@property (nonatomic, assign) UIInterfaceOrientation deviceDirection;

/**
 PlateCameraController代码版本号
 */
@property (nonatomic, copy) NSString * codeVersion;

- (instancetype)initWithAuthorizationCode:(NSString *)authorizationCode;



@end
