//
//  EffectView.m
//  LrcTest
//
//  Created by pengyucheng on 14/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import "EffectView.h"

@implementation EffectView

-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //设置模糊透明度
        effectView.alpha = 0.5f;
        [self addSubview:effectView];
        effectView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[effectView]-0-|"
                                                             options:0 metrics:nil
                                                               views:@{@"effectView":effectView}];
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[effectView]-0-|"
                                                             options:0 metrics:nil
                                                               views:@{@"effectView":effectView}];
        [self addConstraints:h];
        [self addConstraints:v];
    }
    return self;
}

@end
