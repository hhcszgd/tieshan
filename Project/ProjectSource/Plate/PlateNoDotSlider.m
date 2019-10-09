//
//  PlateNoDotSlider.m
//  PlateDemo
//
//  Created by ocrgroup on 2019/6/16.
//  Copyright © 2019 DXY. All rights reserved.
//

#import "PlateNoDotSlider.h"


#define THEMECOLOR [UIColor colorWithRed:89/255.0 green:212/255.0 blue:209/255.0 alpha:1]

@interface PlateNoDotSlider ()


@property (nonatomic, strong) UIView * backgroundView;

@property (nonatomic, strong) UIImageView * circleView;

@property (nonatomic, strong) UIView * leftView;

@property (nonatomic, assign) CGFloat sumOffset;

@property (nonatomic, assign) CGFloat originPercentage;


@end


@implementation PlateNoDotSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
        
    }
    return self;
}


- (void)prepareUI {
    [self addSubview:self.backgroundView];
    
    [self addSubview:self.leftView];
    
    [self addSubview:self.circleView];
    
    [self frameSetup];
}

- (void)frameSetup {
    self.backgroundView.frame = CGRectMake(15, CGRectGetHeight(self.bounds) * 0.5 - 1, CGRectGetWidth(self.bounds) - 15 * 2, 2);
    
    self.backgroundView.layer.cornerRadius = 1;
    self.backgroundView.layer.masksToBounds = YES;
    
    self.circleView.frame = CGRectMake(0, 0, 26, 26);
    self.circleView.center = CGPointMake(CGRectGetMinX(self.backgroundView.frame), CGRectGetMidY(self.backgroundView.frame));
    
    
    self.sumOffset = 0;
    
    
    self.leftView.frame = CGRectMake(0, 0, 0, CGRectGetHeight(self.backgroundView.frame));
    self.leftView.center = CGPointMake(CGRectGetMidX(self.circleView.frame), CGRectGetMidY(self.backgroundView.frame));
    
    self.leftView.layer.cornerRadius = 1;
    self.leftView.layer.masksToBounds = YES;
}

#pragma mark - 手势
- (void)pan:(UIPanGestureRecognizer *)sender {
    //1.get offset
    CGPoint offset = [sender translationInView:sender.view];
    
    //2.return to zero
    [sender setTranslation:CGPointZero inView:sender.view];
    
    //防止往左滑右面穿透 防止向右滑过界
    if (offset.x + CGRectGetMidX(self.circleView.frame) < CGRectGetMinX(self.backgroundView.frame) || offset.x + self.circleView.center.x > CGRectGetMaxX(self.backgroundView.frame)) {
        return ;
    }
    self.sumOffset += offset.x;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            //更新frame
            CGRect circleRect = self.circleView.frame;
            circleRect.origin.x = self.sumOffset;
            self.circleView.frame = circleRect;
            //            NSLog(@"offset:%.2lf circlecenter.x:%.2lf backview.x%.2lf", self.sumOffset, self.circleView.center.x, self.backgroundView.frame.origin.x);
            
            CGRect leftRect = self.leftView.frame;
            leftRect.size.width = self.sumOffset;
            self.leftView.frame = leftRect;
            
            
            if ([self.delegate respondsToSelector:@selector(noDotSliderChanged:)]) {
                [self.delegate noDotSliderChanged:self.sumOffset / CGRectGetWidth(self.backgroundView.frame)];
            } else {
                NSLog(@"%@:noDotSliderChanged:未实现！", self.delegate);
            }
            
            break;
        }
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(noDotSliderChangeFinished:)]) {
                    [self.delegate noDotSliderChangeFinished:self.sumOffset / CGRectGetWidth(self.backgroundView.frame)];
                } else {
                    //                    NSLog(@"%@:noDotSliderChangeFinished:未实现！", self.delegate);
                }
            }
        }
            
        default:
            break;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - Setter
- (void)setSavedPercent:(CGFloat)percentage {
    self.originPercentage = percentage;
    self.sumOffset = CGRectGetWidth(self.backgroundView.frame) * self.originPercentage;
    //更新frame
    CGRect circleRect = self.circleView.frame;
    circleRect.origin.x = self.sumOffset;
    self.circleView.frame = circleRect;
    //    NSLog(@"offset:%.2lf circlecenter.x:%.2lf backview.x%.2lf", self.sumOffset, self.circleView.center.x, self.backgroundView.frame.origin.x);
    
    CGRect leftRect = self.leftView.frame;
    leftRect.size.width = self.sumOffset;
    self.leftView.frame = leftRect;
    
}

#pragma mark - Getter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (UIImageView *)circleView {
    if (!_circleView) {
        _circleView = [[UIImageView alloc] init];
        UIImage * circleImage = [UIImage imageNamed:@"PlateImageResource.bundle/naniu"];
        _circleView.image = circleImage;
        _circleView.userInteractionEnabled = YES;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_circleView addGestureRecognizer:pan];
    }
    return _circleView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        _leftView.backgroundColor = THEMECOLOR;
    }
    return _leftView;
}

@end
