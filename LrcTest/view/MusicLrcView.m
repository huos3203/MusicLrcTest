//
//  MusicLrcView.m
//  LrcTest
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import "MusicLrcView.h"
#import "MusicLrcParser.h"
#import "MusicLrcCell.h"
#import "CLLrcTool.h"
#import "CLLrcLine.h"
#import "MusicLrcCell.h"
#import "MusicLrcLabel.h"

static MusicLrcView *instance;
@implementation MusicLrcView


+(MusicLrcView *)shared
{
    if (!instance)
    {
        instance = [[MusicLrcView alloc] init];
    }
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = true;
        //如果为YES，在AutoLayout中则会自动将view的frame和bounds属性转换为约束。
        self.translatesAutoresizingMaskIntoConstraints = NO;
//        if (!_timerPlay)
//        {
//            _timerPlay = [NSTimer scheduledTimerWithTimeInterval:0.5
//                                                          target:self
//                                                        selector:@selector(currentPlayTime)
//                                                        userInfo:nil
//                                                         repeats:YES];
//        }
        
        if(!_lrcTiemr)
        {
            self.lrcTiemr = [CADisplayLink displayLinkWithTarget:self
                                                        selector:@selector(updateLrcPregress)];
            [self.lrcTiemr addToRunLoop:[NSRunLoop mainRunLoop]
                                forMode:NSRunLoopCommonModes];
        }
        //歌词列表使用tableView来显示
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setDelegate:self];
        [self setDataSource:self];
    }
    return self;
}

-(void)updateConstraints
{
//    [_tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|"
                                                         options:0 metrics:nil
                                                           views:@{@"tableview":self}];
    NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-0-|"
                                                         options:0 metrics:nil
                                                           views:@{@"tableview":self}];
    [[self superview] addConstraints:h];
    [[self superview] addConstraints:v];
    [super updateConstraints];
    
}

//固有内容大小
-(CGSize)intrinsicContentSize
{
    return CGSizeMake(320, 420);
}

-(void)setLrcName:(NSString *)lrcName
{
    // 0.更新行数
    self.currentIndex = 0;
    
    // 1. 记录歌词名
    _lrcName = lrcName;
    // 解析歌词 使用自己创建歌词解析工具
    self.lrcList = [CLLrcTool lrcToolWithLrcName:lrcName];
    
    CLLrcLine *lrcLine = self.lrcList[0];
    self.lrcLabel.text = lrcLine.text;
}

-(void)loadLrcBy:(NSString *)lrcPath
     audioPlayer:(AVAudioPlayer *)player
     lrcDedegate:(id<MusicLrcDelegate>)lrcDelegate
{
    [self setNeedsUpdateConstraints];
    [self reloadData];
    if(lrcPath != nil && player != nil && lrcDelegate != nil)
    {
        _audioPlayer = player;
        _lrcDelegate = lrcDelegate;
        //解析数据
        self.lrcName = lrcPath;
        [self reloadData];
    }
    else
    {
        NSLog(@"--调用switchLrcOfMusic方法中缺少初始化参数--");
    }

}

-(void)switchLrcOfMusic:(NSString *)lrcPath
            audioPlayer:(AVAudioPlayer *)player
            lrcDelegate:(id<MusicLrcDelegate>)lrcDelegate
{
//    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
//    [self layoutIfNeeded];
    [self reloadData];
    if(lrcPath != nil && player != nil && lrcDelegate != nil)
    {
//        _player = player;
        _audioPlayer = player;
        _lrcDelegate = lrcDelegate;
        //解析数据
        _lrcLocalPath = lrcPath;
        _arrayItemList = [[MusicLrcParser shared] parseLrcLocalPath:_lrcLocalPath];
    }
    else
    {
        NSLog(@"--调用switchLrcOfMusic方法中缺少初始化参数--");
    }
}

-(void)switchLrcOfMusic:(NSString *)lrcPath
                 player:(AVPlayer *)player
            lrcDelegate:(id<MusicLrcDelegate>)lrcDelegate
{
    [self setNeedsUpdateConstraints];
    [self reloadData];
    if(lrcPath != nil && player != nil && lrcDelegate != nil)
    {
        _player = player;
        _lrcLocalPath = lrcPath;
        _lrcDelegate = lrcDelegate;
        //解析数据
        _arrayItemList = [[MusicLrcParser shared] parseLrcLocalPath:_lrcLocalPath];
    }
    else
    {
        NSLog(@"--调用switchLrcOfMusic方法中缺少初始化参数--");
    }
}

#pragma mark uitableViewDelegate回调
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lrcList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicLrcCell *cell = [MusicLrcCell lrcCellWithTableView:tableView];
    cell.lrcColor = [_lrcDelegate musicLrcColor];
    if (self.currentIndex == indexPath.row)
    {
        cell.lrcLabel.font = [UIFont systemFontOfSize:20];
    }
    else
    {
        cell.lrcLabel.font = [UIFont systemFontOfSize:16];
        cell.lrcLabel.progress = 0;
    }
    
    // 获得当前播放的歌曲歌词模型
    CLLrcLine *lrcline = self.lrcList[indexPath.row];
    
    cell.lrcLabel.text = lrcline.text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - 使用自定义tableViewCell更新歌词进度
-(void)updateLrcPregress
{
    if (_audioPlayer)
    {
        self.currentTime = _audioPlayer.currentTime;
        NSLog(@"fCurrentAVAudioPlayTime = %f",self.currentTime);
    }
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    // 记录当前时间
    _currentTime = currentTime;
    // 获取歌词行数
    NSInteger count = self.lrcList.count;
    for (int i = 0; i < count; i ++)
    {
        // 获取i位置的歌词
        CLLrcLine *currentLrcLine = self.lrcList[i];
        // 获取下一句歌词
        NSInteger nextIndex = i + 1;
        // 先创建空的歌词模型
        CLLrcLine *nextLrcLine = nil;
        // 判断歌词是否存在
        if (nextIndex < self.lrcList.count) {
            // 说明存在
            nextLrcLine = self.lrcList[nextIndex];
        }
        // 用播放器的当前的时间和i位置歌词、i+1位置歌词的时间进行比较，如果大于等于i位置的时间并且小于等于i+1歌词的时间，说明应该显示i位置的歌词。
        // 并且如果正在显示的就是这行歌词则不用重复判断
        if (self.currentIndex != i
            && currentTime >= currentLrcLine.time
            && currentTime < nextLrcLine.time)
        {
            // 2.8设置主页上的歌词
            self.lrcLabel.text = currentLrcLine.text;
            
            
            // 将当前播放的歌词移动到中间
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self scrollToRowAtIndexPath:indexPath
                        atScrollPosition:UITableViewScrollPositionMiddle
                                animated:YES];
            
            // 记录上一句位置，当移动到下一句时，上一句和当前这一句都需要进行更新行
            NSIndexPath *previousPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            // 记录当前播放的下标。下次来到这里，currentIndex指的就是上一句
            self.currentIndex = i;
            [self reloadRowsAtIndexPaths:@[indexPath,previousPath]
                        withRowAnimation:UITableViewRowAnimationNone];
        }
        if (self.currentIndex == i)
        {
            // 获取播放速度 已经播放的时间 / 播放整句需要的时间
            CGFloat progress = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            // 获取当前行数的cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            MusicLrcCell *lrccell = [self cellForRowAtIndexPath:indexPath];
            lrccell.lrcLabel.progress = progress;
            lrccell.lrcLabel.fillColor = [_lrcDelegate musicLrcHighlightColor];
            self.lrcLabel.progress = progress;
        }
    }
}


#pragma mark 使用默认tableViewCell更新歌词进度
//获取音频当前时间点，秒单位，并定位到当前的单元格
-(Float64) currentPlayTime
{
    if (!(_player || _audioPlayer))
    {
        return -1.0f;
    }
    
    NSString *currentSeconds = @"";
    
    if (_player)
    {
        CMTime currentTime = _player.currentItem.currentTime;
        Float64 fCurrentTime = CMTimeGetSeconds(currentTime);
        NSLog(@"fCurrentPlayTime = %f",fCurrentTime);
        currentSeconds = [NSString stringWithFormat:@"%f", fCurrentTime];
    }
    
    if (_audioPlayer)
    {
        NSTimeInterval timeseconds = _audioPlayer.currentTime;
        NSLog(@"fCurrentAVAudioPlayTime = %f",timeseconds);
        currentSeconds = [NSString stringWithFormat:@"%f",timeseconds];
    }
    
    //当前索引
    int currentIndex = [self currentPlayIndex:currentSeconds];
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:(NSUInteger )currentIndex inSection:0];
    UITableViewCell *cell  = [self cellForRowAtIndexPath:cellIndexPath];
    if (cell)
    {
        if ([_lrcDelegate refreshAllLrcColor])
        {
            [self reloadData];
            [_lrcDelegate refreshFinish];
        }
        cell.textLabel.textColor = [_lrcDelegate musicLrcHighlightColor];
        [self selectRowAtIndexPath:cellIndexPath
                          animated:YES
                    scrollPosition:UITableViewScrollPositionMiddle];
        //重置上一个cell文本颜色
        NSIndexPath *preCellIndexPath = [NSIndexPath indexPathForRow:(NSUInteger )currentIndex-1 inSection:0];
        UITableViewCell *preCell  = [self cellForRowAtIndexPath:preCellIndexPath];
        if (preCell)
        {
            preCell.textLabel.textColor = [_lrcDelegate musicLrcColor];
        }
        
        NSLog(@"currentIndex = %d",currentIndex);
    }
    
    return (Float64)currentIndex;
}

-(int) currentPlayIndex:(NSString*) currentPlaySecond
{
    if (!currentPlaySecond || currentPlaySecond.length <= 0)
        return 0;
    
    int index;
    for (index = 0; index < self.arrayItemList.count; index++)
    {
        NSDictionary *dic = [self.arrayItemList objectAtIndex:index];
        if (dic)
        {
            NSString * strSecondValue = [dic.allKeys objectAtIndex:0];
            float fValue = strSecondValue.floatValue;
            if (fValue > currentPlaySecond.floatValue)
                break;
        }
    }
    return index - 1;
}
@end
