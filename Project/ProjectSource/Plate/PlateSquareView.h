//
//  PlateSquareView.h
//  PlateDemo
//
//  Created by ocrgroup on 2018/3/15.
//  Copyright © 2018年 DXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateSquareView : UIView


@property (nonatomic, assign) CGRect squareRect;


@property (assign, nonatomic) BOOL leftHidden;
@property (assign, nonatomic) BOOL rightHidden;
@property (assign, nonatomic) BOOL topHidden;
@property (assign, nonatomic) BOOL bottomHidden;

- (instancetype)initWithFrame:(CGRect)frame margin:(CGFloat)margin bottomHeight:(CGFloat)bottomHeight andSquareRatio:(CGFloat)squareRatio;

@end
