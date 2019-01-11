//
//  XBCircleProgressView.m
//  D11Module
//
//  Created by xxb on 2017/7/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBCircleProgressView.h"
#import "XBCircleProgressViewConfig.h"

@interface XBCircleProgressView ()
//起始位置开始算起，增加的角度的系数（M_PI的倍数），最大为2，最小为0
@property (nonatomic,assign) CGFloat multipleAdd;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation XBCircleProgressView

-(void)dealloc
{
    [self stopTimer];
    
    NSLog(@"XBCircleProgressView销毁");
}

- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRect");
    
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    CGFloat minW = w < h ? w : h;
    
    CGFloat borderMax = self.f_borderWidthForeground > self.f_borderWidthBackground ? self.f_borderWidthForeground : self.f_borderWidthBackground;
    
    //计算圆心和半径
    CGPoint center = CGPointMake(w * 0.5, h * 0.5);
    CGFloat radius_fore = minW * 0.5 - borderMax;
    CGFloat radius_back = minW * 0.5 - borderMax;

    CGContextRef context = UIGraphicsGetCurrentContext();

    [self.backgroundColor set];
    CGContextFillRect(context, rect);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, self.f_borderWidthBackground);
    
    
    //背景圆
    CGContextSetStrokeColorWithColor(context, self.color_borderBackground.CGColor);
    CGContextAddArc(context, center.x, center.y, radius_fore, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    
    CGContextRestoreGState(context);
    
    
    CGContextSetLineWidth(context, self.f_borderWidthForeground);
    //前景圆
    CGContextSetStrokeColorWithColor(context, self.color_borderForeground.CGColor);
    //最后一个参数，决定圆是顺时针画还是逆时针画，0是顺时针
    //但是前面的两个参数：起始位置，终止位置，都是按照x轴方向，顺时针来计算的
    CGContextAddArc(context, center.x, center.y, radius_back, [self getStartAngle], [self getEndAngle], self.direction);
    CGContextDrawPath(context, kCGPathStroke);
    
    //设置文字
    [self setText];
}

//开始
- (void)startAnimation
{
    [self startTimer];
}

//结束
- (void)stopAnimation
{
    [self stopTimer];
}

- (void)setProgress:(CGFloat)progress animation:(BOOL)animation
{
    if (progress > 1)
    {
        NSLog(@"进度不能大于1");
        progress = 1;
    }
    CGFloat endValue = progress * 2.0;
    if (animation == NO)
    {
        self.multipleAdd = endValue;
        [self setNeedsDisplay];
    }
    else
    {
        [self stopAnimation];
        
        CGFloat dif = ABS(endValue - self.multipleAdd);
        CGFloat addValue = dif / kFps;//动画时间定，kFps定，为了在动画时间内做完动画，计算出每次增加的量
        CGFloat interval = XB_circleProgressView_animationTime / kFps;
        [self updateDisplayWithMultipleAddValue:addValue endValue:endValue interval:interval difValue:dif addition:(endValue > self.multipleAdd)];
    }
}

- (void)updateDisplayWithMultipleAddValue:(CGFloat)addValue endValue:(CGFloat)endValue interval:(CGFloat)interval difValue:(CGFloat)difValue addition:(BOOL)addition
{
    if (ABS(endValue - 2.0) < 2.0 * 0.01)
    {
        endValue = 2.0;
    }
    CGFloat tempDif = ABS(self.multipleAdd - endValue);
    if (tempDif < difValue * 0.01)
    {
        tempDif = 0;
        self.multipleAdd = endValue;
    }
    else
    {
        //为了前面快后面慢的效果
        CGFloat xi = tempDif / difValue;
        if (addition)
        {
            self.multipleAdd += addValue * (xi * 2);
        }
        else
        {
            self.multipleAdd -= addValue * (xi * 2);
        }
    }
    
    [self updateDisplayWithMutipleValue:self.multipleAdd];
    if (ABS(self.multipleAdd - endValue) != 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateDisplayWithMultipleAddValue:addValue endValue:endValue interval:interval difValue:difValue addition:addition];
        });
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(circleProgressViewDidSettedProgress:)])
        {
            KWeakSelf
            [self.delegate circleProgressViewDidSettedProgress:weakSelf];
        }
    }
}


#pragma mark - 其他方法

- (void)setText
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleProgressView:titleForSeconds:totalSeconds:)])
    {
        KWeakSelf
        id text = [self.delegate circleProgressView:weakSelf titleForSeconds:[self getCurrentTime] totalSeconds:self.waitTime];
        if ([text isKindOfClass:[NSString class]])
        {
            self.lb_text.text = text;
        }
        else if ([text isKindOfClass:[NSAttributedString class]])
        {
            self.lb_text.attributedText = text;
        }
    }
    else
    {
        self.lb_text.text = [NSString stringWithFormat:@"%d", [self getCurrentTime]];
    }
}

//获取每次定时器回调时，增加的进度
- (CGFloat)getMultipleAddEveryTime
{
    if (self.waitTime <= 0)
    {
        return 2;
    }
    else
    {
        //每秒刷新的次数   FPS
        //等待的时间       T
        //倍数2（2 * M_PI正好一圈）
        //   2 / (FPS * T) = 每次刷新的进度
        return 2 / (self.waitTime * kFps);
    }
}

//获取开始的角度
- (CGFloat)getStartAngle
{
    return (- M_PI * 0.5);
}

//获取结束的角度
- (CGFloat)getEndAngle
{
    if (self.direction == XBCircleProgressViewDirection_clockwise)
    {
        return [self getStartAngle] + (M_PI * self.multipleAdd);
    }
    else
    {
        return [self getStartAngle] - (M_PI * self.multipleAdd);
    }
}

//获取当前时间，跑了几秒了
- (int)getCurrentTime
{
    int currentTime = self.multipleAdd / [self getMultipleAddEveryTime] / kFps;
    return currentTime;
}


#pragma mark - 定时器

- (void)updateDisplay
{
    self.multipleAdd += [self getMultipleAddEveryTime];
    NSLog(@"%f",self.multipleAdd);
    [self updateDisplayWithMutipleValue:self.multipleAdd];
}

- (void)updateDisplayWithMutipleValue:(CGFloat)mutipleValue
{
    [self setNeedsDisplay];
    if (self.multipleAdd >= 2.0)
    {
        [self stopTimer];
        if (self.delegate && [self.delegate respondsToSelector:@selector(circleProgressViewOnTheEnd:)])
        {
            KWeakSelf
            [self.delegate circleProgressViewOnTheEnd:weakSelf];
        }
    }
}

- (void)startTimer
{
    if (self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / kFps) target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}


#pragma mark - 懒加载

- (UILabel *)lb_text
{
    if (_lb_text == nil)
    {
        _lb_text = [UILabel new];
        [self addSubview:_lb_text];
        _lb_text.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_lb_text attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraint:centerXConstraint];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_lb_text attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraint:centerYConstraint];
    }
    return _lb_text;
}

- (CGFloat)f_borderWidthBackground
{
    if (_f_borderWidthBackground == 0)
    {
        return 5;
    }
    return _f_borderWidthBackground;
}

- (CGFloat)f_borderWidthForeground
{
    if (_f_borderWidthForeground == 0)
    {
        return 5;
    }
    return _f_borderWidthForeground;
}

- (UIColor *)color_borderBackground
{
    if (_color_borderBackground == nil)
    {
        return XB_Color_circleProgressView_foreground;
    }
    return _color_borderBackground;
}

- (UIColor *)color_borderForeground
{
    if (_color_borderForeground == nil)
    {
        return XB_Color_circleProgressView_background;
    }
    return _color_borderForeground;
}


@end
