//
//  MusicLrcCell.h
//  LrcTest
//
//  Created by pengyucheng on 14/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicLrcLabel.h"
@interface MusicLrcCell : UITableViewCell

@property(nonatomic,strong)UIColor *lrcColor;
/** 显示歌词的label*/
@property (nonatomic, weak, readonly) MusicLrcLabel *lrcLabel;
+(MusicLrcCell *)lrcCellWithTableView:(UITableView *)tableView;
@end
