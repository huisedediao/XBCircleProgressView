# XBCircleProgressView
圆圈倒计时的动画效果
<br/>
### 效果图：
![image](https://github.com/huisedediao/XBCircleProgressView/raw/master/show.gif)<br/>
### 示例代码：
<br>
<pre>

        XBCircleProgressView *progressView = [XBCircleProgressView new];
        progressView.aniMode = AnimationMode_subduction;
        progressView.waitTime = 15;
        progressView.delegate = self;
        [progressView startAnimation];

@end
</pre>
