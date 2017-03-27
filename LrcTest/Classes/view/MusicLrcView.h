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
//#import "LrcTest-Swift.h"
//#if LrcTest
//#import "LrcTest-Swift.h"
//#elseif MusicLRC
//#import "MusicLRC-Swift.h"
//#else
//#import <MusicLRC/MusicLRC-Swift.h>
//#endif
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
@required
-(UIColor *)musicLrcHighlightColor; //自定义高亮色
@required
-(UIColor *)musicLrcColor;  //自定义默认颜色
@optional
-(UIImage *)visualEffectImage;  //自定义毛玻璃背景
@optional
-(BOOL)refreshAllLrcColor; //: 在快进音乐时，定位当前歌词之前先重制tableView状态
@optional
-(void)refreshFinish;  //: 在快进音乐时，重制tableView状态完成

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

-(BOOL)loadLrcBy:(NSString *)lrcPath audioPlayer:(AVAudioPlayer *)player lrcDedegate:(id<MusicLrcDelegate>)lrcDelegate;

@end
