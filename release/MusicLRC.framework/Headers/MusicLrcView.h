//
//  MusicLrcView.h
//  LrcTest
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "MusicLrcLabel.h"
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
-(UIColor *)musicLrcHighlightColor;

-(UIColor *)musicLrcColor;

-(UIImage *)visualEffectImage;

-(BOOL)refreshAllLrcColor;

-(void)refreshFinish;

@end


@interface MusicLrcView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    AVPlayer * _player;
    AVAudioPlayer * _audioPlayer;
    NSString * _lrcLocalPath;
    NSTimer * _timerPlay;
//    UITableView* _tableView;
    NSMutableArray *_arrayItemList;
}

@property(nonatomic, retain) NSMutableArray *arrayItemList;
@property (weak, nonatomic) id<MusicLrcDelegate> lrcDelegate;


@property (strong, nonatomic) NSString *lrcName;
/** 歌词数组 */
@property(nonatomic,strong)NSArray *lrcList;
/** 歌词的Label */
@property (nonatomic, weak) MusicLrcLabel *lrcLabel;
/** 当前歌词的下标 */
@property (nonatomic,assign) NSInteger currentIndex;
/** 当前播放的时间 */
@property (nonatomic,assign) NSTimeInterval currentTime;

/** 当前音乐的总时间 */
@property (nonatomic,assign) NSTimeInterval duration;
/** 歌词的定时器 */
@property (nonatomic,strong) CADisplayLink *lrcTiemr;

+(MusicLrcView *)shared;

-(void)loadLrcBy:(NSString *)lrcPath audioPlayer:(AVAudioPlayer *)player lrcDedegate:(id<MusicLrcDelegate>)lrcDelegate;

-(void)switchLrcOfMusic:(NSString *)lrcPath
            audioPlayer:(AVAudioPlayer *)player
            lrcDelegate:(id<MusicLrcDelegate>)lrcDelegate;

-(void)switchLrcOfMusic:(NSString *)lrcPath
                 player:(AVPlayer *)player
            lrcDelegate:(id<MusicLrcDelegate>)lrcDelegate;
@end
