//
//  XBCircleProgressViewConfig.h
//  D11Module
//
//  Created by xxb on 2017/7/13.
//  Copyright © 2017年 xxb. All rights reserved.
//

#ifndef XBCircleProgressViewConfig_h
#define XBCircleProgressViewConfig_h

//屏幕宽高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


//根据传入的文字、宽度和字体计算出合适的size (CGSize)
#define getAdjustSizeWith_text_width_font(text,width,font) ({[text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :font} context:NULL].size;})

#define XB_Color_circleProgressView_nor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]
#define XB_Color_circleProgressView_pro [UIColor colorWithRed:80/255.0 green:115/255.0 blue:208/255.0 alpha:1]

#define XB_Font(x) [UIFont systemFontOfSize:x]

#define XB_GWidthAdjust_ip6(x) ((ScreenWidth / 375) * x)
#define XB_GHeightAdjust_ip6(x) ((ScreenHeight/667) * x)

#define kFps (30)



#endif /* XBCircleProgressViewConfig_h */
