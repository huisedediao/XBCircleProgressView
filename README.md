# XBCircleProgressView
圆圈倒计时的动画效果
<br/>
####支持设置方向、设置进度（带先快后慢动画）、支持设置前景色、后景色
<br>
### 效果图：
![image](https://github.com/huisedediao/XBCircleProgressView/raw/master/show.gif)<br/>
### 示例代码：
<br>
<pre>

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XBCircleProgressView *circleView = [XBCircleProgressView new];
    [self.view addSubview:circleView];
    _circleView = circleView;
    circleView.delegate = self;
    circleView.direction = XBCircleProgressViewDirection_anticlockwise;
    circleView.frame = CGRectMake(100, 100, 200, 200);
    circleView.waitTime = 10;
    circleView.circleBorderWidth = 5;
//    circleView.backgroundColor = [UIColor grayColor];
//    circleView.foregroundColor = [UIColor redColor];
//    [circleView setProgress:0.5 animation:YES];
//    [circleView startAnimation];
}
- (IBAction)changeProgress:(id)sender {
    [_circleView setProgress:0.2 animation:YES];
}
- (IBAction)reset:(id)sender {
    [_circleView setProgress:0 animation:YES];
}


- (void)circleProgressViewDidSettedProgress:(XBCircleProgressView *)progressView
{
    [_circleView startAnimation];
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
</pre>
