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
///
- (void)circleProgressViewOnTheEnd:(XBCircleProgressView *)progressView;
- (void)circleProgressViewDidSettedProgress:(XBCircleProgressView *)progressView;
///返回文本或者富文本
- (id)circleProgressView:(XBCircleProgressView *)progressView titleForSeconds:(int)seconds totalSeconds:(int)totalSeconds;

@end

typedef enum : NSUInteger {
    XBCircleProgressViewDirection_clockwise,                //顺时针
    XBCircleProgressViewDirection_anticlockwise             //逆时针
} XBCircleProgressViewDirection;

@interface XBCircleProgressView : UIView

@property (nonatomic,weak) id<XBCircleProgressViewDelegate>delegate;
///前景圆圈边缘宽度,默认5
@property (nonatomic,assign) CGFloat f_borderWidthForeground;
///背景圆圈边缘宽度,默认5
@property (nonatomic,assign) CGFloat f_borderWidthBackground;
///方向，顺时针还是逆时针
@property (nonatomic,assign) XBCircleProgressViewDirection direction;
///等待时间（就是动画跑完的时间）
@property (nonatomic,assign) CGFloat waitTime;
    
///前景色
@property (nonatomic,strong) UIColor *color_foreground;
///背景色
@property (nonatomic,strong) UIColor *color_background;
///文字标签
@property (nonatomic,strong) UILabel *lb_text;
/**
 注意，如果animation为YES，如果原来有动画，动画会停止
 */
- (void)setProgress:(CGFloat)progress animation:(BOOL)animation;

- (void)startAnimation;
- (void)stopAnimation;

@end
