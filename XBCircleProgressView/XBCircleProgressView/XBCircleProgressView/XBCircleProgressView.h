//
//  XBCircleProgressView.h
//  D11Module
//
//  Created by xxb on 2017/7/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBCircleProgressView;

@protocol XBCircleProgressViewDelegate <NSObject>

@optional
- (void)progressViewDidEndAnimation:(XBCircleProgressView *)progressView;
- (NSString *)progressViewTitleForSeconds:(int)seconds totalSeconds:(int)totalSeconds;

@end

typedef enum : NSUInteger {
    AnimationMode_add,              //时间和进度增加
    AnimationMode_subduction        //时间和进度减少
} AnimationMode;

@interface XBCircleProgressView : UIView


@property (nonatomic,weak) id<XBCircleProgressViewDelegate>delegate;
//圆圈边缘宽度,默认5
@property (nonatomic,assign) CGFloat circleBorderWidth;
@property (nonatomic,assign) AnimationMode aniMode;
///等待时间（就是动画跑完的时间）
@property (nonatomic,assign) CGFloat waitTime;
    
//前景色
@property (nonatomic,strong) UIColor *foregroundColor;
//背景色
@property (nonatomic,strong) UIColor *backgroundColor;
//文字颜色
@property (nonatomic,strong) UIColor *textColor;
    
- (void)setProgress:(CGFloat)progress animation:(BOOL)animation;

- (void)startAnimation;
- (void)stopAnimation;
@end
