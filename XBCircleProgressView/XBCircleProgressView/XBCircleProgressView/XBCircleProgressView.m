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
//起始位置开始算起，增加的角度（M_PI的倍数），最大为2，最小为0
@property (nonatomic,assign) CGFloat multipleAdd;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableDictionary *dic_textParams;
@end

@implementation XBCircleProgressView


- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRect");
    
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    CGFloat minW = w < h ? w : h;
    
    //计算圆心和半径
    CGPoint center = CGPointMake(w * 0.5, h * 0.5);
    CGFloat radius = minW * 0.5 - self.circleBorderWidth;

    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context, self.circleBorderWidth);
    CGContextSaveGState(context);
    
    
    //背景圆
    CGContextSetStrokeColorWithColor(context, [self getBackgroundColor].CGColor);
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    
    CGContextRestoreGState(context);
    
    
    //前景圆
    CGContextSetStrokeColorWithColor(context, [self getForegroundColor].CGColor);
    //最后一个参数，决定圆是顺时针画还是逆时针画，0是顺时针
    //但是前面的两个参数：起始位置，终止位置，都是按照x轴方向，顺时针来计算的
    CGContextAddArc(context, center.x, center.y, radius, [self getStartAngle], [self getEndAngle], [self getDirection]);
    CGContextDrawPath(context, kCGPathStroke);
    

    //时间
//    NSString *time = [NSString stringWithFormat:@"%d", [self getCurrentTime]];
    NSString *time = [self getCurrentTimeStr];
    //NSLog(@"%d",currentTime);
    CGSize size = getAdjustSizeWith_text_width_font(time, 44, self.dic_textParams[NSFontAttributeName]);
    [time drawInRect:CGRectMake((w - size.width)*0.5, (h - size.height)*0.5, size.width, size.height) withAttributes:self.dic_textParams];
}

//获取前景颜色
- (UIColor *)getBackgroundColor
{
    if (self.backgroundColor)
    {
        return self.backgroundColor;
    }
    return self.aniMode == AnimationMode_add ? XB_Color_circleProgressView_nor : XB_Color_circleProgressView_pro;
}
    
//获取背景颜色
- (UIColor *)getForegroundColor
{
    if (self.foregroundColor)
    {
        return self.foregroundColor;
    }
    return self.aniMode == AnimationMode_add ? XB_Color_circleProgressView_pro : XB_Color_circleProgressView_nor;
}

//获取开始的角度
- (CGFloat)getStartAngle
{
    return self.aniMode == AnimationMode_add ? (- M_PI * 0.5) : (- M_PI * 0.5);
}

//获取结束的角度
- (CGFloat)getEndAngle
{
    return self.aniMode == AnimationMode_add ? (- M_PI * (0.5 + self.multipleAdd)) : (M_PI * (- 0.5 + self.multipleAdd));
}

//获取画圆的方向
- (int)getDirection
{
    return self.aniMode == AnimationMode_add ? (1) : (0);
}

//获取当前时间，跑了几秒了
- (int)getCurrentTime
{
    int currentTime = self.multipleAdd / [self getMultipleAddEveryTime] / kFps;
    return currentTime;
}

//获取显示的文字
- (NSString *)getCurrentTimeStr
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressViewTitleForSeconds:totalSeconds:)])
    {
        return [self.delegate progressViewTitleForSeconds:[self getCurrentTime] totalSeconds:self.waitTime];
    }
    int time = self.aniMode == AnimationMode_add ? [self getCurrentTime] : (int)(self.waitTime - [self getCurrentTime]);
    return [NSString stringWithFormat:@"%d", time];
}

-(void)dealloc
{
    [self stopTimer];
    
    NSLog(@"XBCircleProgressView销毁");
}

//开始
- (void)startAnimation
{
    self.multipleAdd = 0;
    [self startTimer];
}

//结束
- (void)stopAnimation
{
    [self stopTimer];
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

- (void)updateDisplay
{
    self.multipleAdd += [self getMultipleAddEveryTime];
    //NSLog(@"%f",self.multipleAdd);
    [self setNeedsDisplay];
    if (self.multipleAdd >= 2.0)
    {
        [self stopTimer];
        if (self.delegate && [self.delegate respondsToSelector:@selector(progressViewDidEndAnimation:)])
        {
            [self.delegate progressViewDidEndAnimation:self];
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

-(NSMutableDictionary *)dic_textParams
{
    if (_dic_textParams == nil)
    {
        UIColor *textColor = nil;
        if (self.textColor)
        {
            textColor = self.textColor;
        }
        if (textColor == nil)
        {
            textColor = [self getForegroundColor];
        }
        UIFont *font = XB_Font(XB_GWidthAdjust_ip6(30));
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[NSFontAttributeName] = font;
        params[NSForegroundColorAttributeName] = textColor;
    
        _dic_textParams = params;
    }
    return _dic_textParams;
}

- (CGFloat)circleBorderWidth
{
    if (_circleBorderWidth == 0)
    {
        return 5;
    }
    return _circleBorderWidth;
}

@end
