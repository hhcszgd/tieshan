//
//  PlateMainController.h
//  PlateDemo
//
//  Created by ocrgroup on 2018/3/9.
//  Copyright © 2018年 DXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateMainController : UIViewController
@property (strong, nonatomic) void (^actionBlock)(NSString *);
- (instancetype)initWithAuthorizationCode:(NSString *)authorizationCode;

@end
