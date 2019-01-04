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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XBCircleProgressView *circleView = [XBCircleProgressView new];
    [self.view addSubview:circleView];
    circleView.delegate = self;
    //    circleView.aniMode = AnimationMode_subduction;
    circleView.frame = CGRectMake(100, 100, 100, 100);
    circleView.waitTime = 100;
    circleView.circleBorderWidth = 5;
    circleView.backgroundColor = [UIColor blackColor];
    circleView.foregroundColor = [UIColor grayColor];
    circleView.textColor = [UIColor blackColor];
    [circleView startAnimation];
}
    
- (NSString *)progressViewTitleForSeconds:(int)seconds totalSeconds:(int)totalSeconds
{
    return [NSString stringWithFormat:@"%dS",seconds];
}

@end
