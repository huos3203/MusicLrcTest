//
//  MusicLrcLabel.m
//  LrcTest
//
//  Created by pengyucheng on 14/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import "MusicLrcLabel.h"

@implementation MusicLrcLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect progressRect = CGRectMake(0, 0, rect.size.width * _progress, rect.size.height);
    [super drawRect:progressRect];
    //设置当前绘图上下文的填充渲染颜色为 红色
    [_fillColor set];
    //使用当前颜色来填充指定的矩形框
    UIRectFillUsingBlendMode(progressRect, kCGBlendModeSourceIn);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
