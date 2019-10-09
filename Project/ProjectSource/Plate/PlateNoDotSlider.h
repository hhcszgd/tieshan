//
//  PlateNoDotSlider.h
//  PlateDemo
//
//  Created by ocrgroup on 2019/6/16.
//  Copyright © 2019 DXY. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol PlateNoDotSliderDelegate <NSObject>

- (void)noDotSliderChanged:(CGFloat)percentage;

- (void)noDotSliderChangeFinished:(CGFloat)percentage;

@end


@interface PlateNoDotSlider : UIView

@property (nonatomic, weak) id <PlateNoDotSliderDelegate> delegate;

- (void)setSavedPercent:(CGFloat)percentage;

@end

NS_ASSUME_NONNULL_END
