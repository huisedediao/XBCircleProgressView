//
//  XBCircleProgressView.m
//  D11Module
//
//  Created by xxb on 2017/7/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBCircleProgressView.h"
#import "XBCircleProgressViewConfig.h"
#import "XBHeader.h"


@interface XBCircleProgressView ()
//起始位置开始算起，增加的角度（M_PI的倍数），最大为2，最小为0
@property (nonatomic,assign) CGFloat multipleAdd;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableDictionary *params;
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
    CGFloat radius = minW * 0.5 - kCircleBorderWidth;

    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context, kCircleBorderWidth);
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
    NSString *time = [NSString stringWithFormat:@"%d", [self getCurrentTime]];
    //NSLog(@"%d",currentTime);
    CGSize size = getAdjustSizeWith_text_width_font(time, 44, self.params[NSFontAttributeName]);
    [time drawInRect:CGRectMake((w - size.width)*0.5, (h - size.height)*0.5, size.width, size.height) withAttributes:self.params];
}

- (UIColor *)getBackgroundColor
{
    return self.aniMode == AnimationMode_add ? D11_Color_gray : D11_Color_blue;
}

- (UIColor *)getForegroundColor
{
    return self.aniMode == AnimationMode_add ? D11_Color_blue : D11_Color_gray;
}

- (CGFloat)getStartAngle
{
    return self.aniMode == AnimationMode_add ? (- M_PI * 0.5) : (- M_PI * 0.5);
}

- (CGFloat)getEndAngle
{
    return self.aniMode == AnimationMode_add ? (- M_PI * (0.5 + self.multipleAdd)) : (M_PI * (- 0.5 + self.multipleAdd));
}

- (int)getDirection
{
    return self.aniMode == AnimationMode_add ? (1) : (0);
}

- (int)getCurrentTime
{
    int currentTime = self.multipleAdd / [self getMultipleAddEveryTime] / kFps;
    return self.aniMode == AnimationMode_add ? currentTime : (int)(self.waitTime - currentTime);
}

-(void)dealloc
{
    [self stopTimer];
    
    NSLog(@"XBCircleProgressView销毁");
}

- (void)startAnimation
{
    self.multipleAdd = 0;
    [self startTimer];
}

- (void)stopAnimation
{
    [self stopTimer];
}

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

-(NSMutableDictionary *)params
{
    if (_params == nil)
    {
        UIFont *font = D11_Font(GWidthAdjust_ip6(30));
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[NSFontAttributeName] = font;
        params[NSForegroundColorAttributeName] = D11_Color_blue;
    
        _params = params;
    }
    return _params;
}

@end
