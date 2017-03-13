//
//  MusicLrcView.m
//  LrcTest
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import "MusicLrcView.h"
#import "MusicLrcParser.h"

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
        if (!_timerPlay)
        {
            _timerPlay = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                          target:self
                                                        selector:@selector(currentPlayTime)
                                                        userInfo:nil
                                                         repeats:YES];
        }
        //歌词列表使用tableView来显示
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


-(void)switchLrcOfMusic:(NSString *)lrcPath
                 player:(AVPlayer *)player
            lrcDelegate:(id<MusicLrcDelegate>)lrcDelegate
{
//    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
//    [self layoutIfNeeded];
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

//model解析lrc歌词文件
//获取音频当前时间点，秒单位，并定位到当前的单元格
-(Float64) currentPlayTime
{
    if (_player)
    {
        CMTime currentTime = _player.currentItem.currentTime;
        Float64 fCurrentTime = CMTimeGetSeconds(currentTime);
        //        NSLog(@"fCurrentPlayTime = %f",fCurrentTime);
        int currentIndex = [self currentPlayIndex:[NSString stringWithFormat:@"%f",fCurrentTime]];
        
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:(NSUInteger )currentIndex inSection:0];
        UITableViewCell *cell  = [self cellForRowAtIndexPath:cellIndexPath];
        cell.textLabel.textColor = [_lrcDelegate setHighlightLrcColor];
        [self selectRowAtIndexPath:cellIndexPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
        //重置上一个cell文本颜色
        NSIndexPath *preCellIndexPath = [NSIndexPath indexPathForRow:(NSUInteger )currentIndex-1 inSection:0];
        UITableViewCell *preCell  = [self cellForRowAtIndexPath:preCellIndexPath];
        preCell.textLabel.textColor = [_lrcDelegate setLrcColor];
        NSLog(@"currentIndex = %d",currentIndex);
        return fCurrentTime;
    }
    return -1.0f;
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


#pragma mark uitableViewDelegate回调
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayItemList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellI = @"CellI";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellI];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellI];
    }
    
    if (cell)
    {
        NSDictionary *dic = [self.arrayItemList objectAtIndex:indexPath.row];
        NSString *key = @"key is nil";
        NSString *value = @"value is nil";
        if (dic)
        {
            key = [dic.allKeys objectAtIndex:0];
            value = [dic objectForKey:key];
            cell.textLabel.text = value;//字体颜色
            cell.textLabel.textColor = [_lrcDelegate setLrcColor];
            cell.detailTextLabel.text  = key;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
