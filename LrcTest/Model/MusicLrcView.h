//
//  MusicLrcView.h
//  LrcTest
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
/*
 实现要求
 1、实现类为视图，可以直接嵌入其他视图
 2、支持重设歌词路径
 3、支持重设当前进度
 4、支持重设高亮歌词颜色
 5、支持重设非高亮歌词颜色
 6、支持前进，后退几秒
 */

//代理
@protocol MusicLrcDelegate <NSObject>

//重设高亮歌词颜色
-(UIColor *)setHighlightLrcColor;

-(UIColor *)setLrcColor;

@end


@interface MusicLrcView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    AVPlayer * _player;
    NSString * _lrcLocalPath;
    NSTimer * _timerPlay;
    UITableView* _tableView;
    NSMutableArray *_arrayItemList;
}

@property(nonatomic, retain) NSMutableArray *arrayItemList;
@property (weak, nonatomic) id<MusicLrcDelegate> lrcDelegate;


-(id)initWithLrcLocalPath:(NSString *)localPath currentPlayer:(AVPlayer *)player;

@end
