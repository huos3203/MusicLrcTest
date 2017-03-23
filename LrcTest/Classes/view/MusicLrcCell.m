//
//  MusicLrcCell.m
//  LrcTest
//
//  Created by pengyucheng on 14/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import "MusicLrcCell.h"

@implementation MusicLrcCell

+(MusicLrcCell *)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    MusicLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MusicLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}


-(void)setLrcColor:(UIColor *)lrcColor
{
    _lrcLabel.textColor = lrcColor;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //设置
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加子控件
        MusicLrcLabel *lrcLabel = [[MusicLrcLabel alloc]init];
        [self.contentView addSubview:lrcLabel];
        _lrcLabel = lrcLabel;
        lrcLabel.alpha = 0.7;
        lrcLabel.font = [UIFont systemFontOfSize:16];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        //约束
        lrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.contentView);
//        }];
        
        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[lrcLabel]-0-|"
                                                             options:0 metrics:nil
                                                               views:@{@"lrcLabel":lrcLabel}];
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lrcLabel]-0-|"
                                                             options:0 metrics:nil
                                                               views:@{@"lrcLabel":lrcLabel}];
        [self.contentView addConstraints:h];
        [self.contentView addConstraints:v];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
