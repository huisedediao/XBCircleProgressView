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
- (void)circleProgressViewStartSetProgress:(XBCircleProgressView *)progressView;
- (void)circleProgressViewDidSettedProgress:(XBCircleProgressView *)progressView;
///返回文本或者富文本
- (id)circleProgressView:(XBCircleProgressView *)progressView titleForSeconds:(int)seconds totalSeconds:(int)totalSeconds;

@end

typedef enum : NSUInteger {
    XBCircleProgressViewDirection_clockwise,                //顺时针
    XBCircleProgressViewDirection_anticlockwise             //逆时针
} XBCircleProgressViewDirection;

typedef enum : NSUInteger {
    XBCircleProgressViewOrder_nor,                          //正序，前景覆盖面从少到多
    XBCircleProgressViewOrder_reverse                       //倒序，前景覆盖面从多到少
} XBCircleProgressViewOrder;
//reverse

@interface XBCircleProgressView : UIView

@property (nonatomic,weak) id<XBCircleProgressViewDelegate>delegate;
///前景圆圈边缘宽度,默认5
@property (nonatomic,assign) CGFloat f_borderWidthForeground;
///背景圆圈边缘宽度,默认5
@property (nonatomic,assign) CGFloat f_borderWidthBackground;
///方向，顺时针还是逆时针
@property (nonatomic,assign) XBCircleProgressViewDirection direction;
///顺序，是正序还是倒序
@property (nonatomic,assign) XBCircleProgressViewDirection order;
///等待时间（就是动画跑完的时间）
@property (nonatomic,assign) CGFloat waitTime;
///前景色
@property (nonatomic,strong) UIColor *color_borderForeground;
///背景色
@property (nonatomic,strong) UIColor *color_borderBackground;
///文字标签
@property (nonatomic,strong) UILabel *lb_text;
/**
 注意，如果animation为YES，如果原来有动画，动画会停止
 */
- (void)setProgress:(CGFloat)progress animation:(BOOL)animation;
///获取当前进度
- (CGFloat)currentProgress;

- (void)startAnimation;
- (void)stopAnimation;

//是否正在执行动画
- (BOOL)isAnimationing;
@end
