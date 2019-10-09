//
//  PlateVerticalButton.m
//  PlateDemo
//
//  Created by ocrgroup on 2019/6/14.
//  Copyright © 2019 DXY. All rights reserved.
//

#import "PlateVerticalButton.h"

@implementation PlateVerticalButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)layoutSubviews {
    [super layoutSubviews];
    
    // image center
    CGPoint center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    //text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    newFrame.size.height = 20;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
