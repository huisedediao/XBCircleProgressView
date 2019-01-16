//
//  ViewController.m
//  XBCircleProgressView
//
//  Created by xxb on 2019/1/4.
//  Copyright © 2019年 xxb. All rights reserved.
//

#import "ViewController.h"
#import "XBCircleProgressView.h"

@interface ViewController ()<XBCircleProgressViewDelegate>
{
    XBCircleProgressView *_circleView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XBCircleProgressView *circleView = [XBCircleProgressView new];
    [self.view addSubview:circleView];
    _circleView = circleView;
    circleView.delegate = self;
    circleView.direction = XBCircleProgressViewDirection_anticlockwise;
    circleView.order = XBCircleProgressViewOrder_reverse;
    circleView.frame = CGRectMake(50, 240, 200, 200);
    circleView.waitTime = 10;
    circleView.f_borderWidthForeground = 8;
    circleView.f_borderWidthBackground = 5;
//    circleView.backgroundColor = [UIColor grayColor];
//    circleView.foregroundColor = [UIColor redColor];
//    [circleView setProgress:0.5 animation:YES];
//    [circleView startAnimation];
}
- (IBAction)changeProgress:(id)sender {
    static CGFloat progress = 0.2;
    [_circleView setProgress:progress animation:YES];
    progress += 0.2;
}
- (IBAction)reset:(id)sender {
    [_circleView setProgress:0 animation:YES];
}


- (void)circleProgressViewDidSettedProgress:(XBCircleProgressView *)progressView
{
//    [_circleView startAnimation];
}

- (void)circleProgressViewOnTheEnd:(XBCircleProgressView *)progressView
{
//    [progressView removeFromSuperview];
//    _circleView = nil;
}
    
- (id)circleProgressView:(XBCircleProgressView *)progressView titleForSeconds:(int)seconds totalSeconds:(int)totalSeconds
{
    return [NSString stringWithFormat:@"%d",seconds];
}

@end
