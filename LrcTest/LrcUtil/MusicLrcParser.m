//
//  MusicModel.m
//  LrcTest
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import "MusicLrcParser.h"
#import "CLLrcLine.h"

static MusicLrcParser *instance;

@implementation MusicLrcParser
{
    NSMutableArray *_arrayTemp;
    NSString *_lrcFileLocalPath;
    NSMutableArray *_arrayItemList;
}

#pragma mark shared
+(MusicLrcParser *)shared
{
    if (!instance)
    {
        instance = [[MusicLrcParser alloc] init];
    }
    return instance;
}

-(NSMutableArray *) parseLrcLocalPath:(NSString *)localPath
{
    _lrcFileLocalPath = localPath;
    _arrayTemp = [[NSMutableArray alloc] init];
    _arrayItemList = [[NSMutableArray alloc] init];
    
    NSError *error = [[NSError alloc] init];
    if (_lrcFileLocalPath)
    {
        NSString *sourceText = [NSString stringWithContentsOfFile:_lrcFileLocalPath encoding:NSUTF8StringEncoding error:&error];
        if (!sourceText || sourceText.length <= 0)
        {
            NSLog(@"lrc error = %@",error.description);
            return nil;
        }
        NSArray * tempArray=[sourceText componentsSeparatedByString:@"\n"];
        for (NSString *str in tempArray)
        {
            if (str && str.length > 0)
            {
                [_arrayTemp removeAllObjects]; // 清除数组里面的临时数据
                [self parseLrcLineWithLineText:str];   //解析单行中信息到数组中
                [self parseTempArray:_arrayTemp];       //把数组转为字典存储，并存入总单词列表中
            }
        }
        if (_arrayItemList && _arrayItemList.count > 0)
        {
//            [self sortAllItem:_arrayItemList];
            return _arrayItemList;
        }
    }
    
    return nil;
}

//解析行
-(void) parseLrcLineWithLineText:(NSString *)sourceLineText
{
    if (!sourceLineText || sourceLineText.length <= 0)
        return;
    NSRange range = [sourceLineText rangeOfString:@"]"];
    if (range.length > 0)
    {
        NSString * time = [sourceLineText substringToIndex:range.location + 1];
        NSLog(@"time = %@",time);
        NSString * other = [sourceLineText substringFromIndex:range.location + 1];
        NSLog(@"other = %@",other);
        if (time && time.length > 0)
            [_arrayTemp addObject:time];
        if (other)  //迭代
            [self parseLrcLineWithLineText:other];
    }
    else
    {
        [_arrayTemp addObject:sourceLineText];
    }
}

-(void) parseTempArray:(NSMutableArray *) tempArray
{
    if (!tempArray || tempArray.count <= 0)
        return;
    NSString *value = [tempArray lastObject];
    if (!value || ([value rangeOfString:@"["].length > 0 && [value rangeOfString:@"]"].length > 0))
    {
        [_arrayTemp removeAllObjects];
        return;
    }
    
    for (int i = 0; i < tempArray.count - 1; i++)
    {
        NSString * key = [tempArray objectAtIndex:(NSUInteger)i];
        // 将字符串转化为模型
//        CLLrcLine *lrcLine = [[CLLrcLine alloc] initWithText:value andTime:key];
        CLLrcLine *lrcLine = [CLLrcLine new];
        lrcLine.text = value;
        lrcLine.time = [self timeToSecond:key];
        [_arrayItemList addObject:lrcLine];
        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
//        NSString *secondKey = [self timeToSecond:key]; // 转换成以秒为单位的时间计数器
//        [dic setObject:value forKey:secondKey];  //设置时间和歌词的键值对
//        [_arrayItemList addObject:dic];
        
    }
    [_arrayTemp removeAllObjects];
}

// 转换成以秒为单位的时间计数器
-(NSTimeInterval)timeToSecond:(NSString *)formatTime
{
    if (!formatTime || formatTime.length <= 0)
        return 0;
    if ([formatTime rangeOfString:@"["].length <= 0 && [formatTime rangeOfString:@"]"].length <= 0)
        return 0;
    NSString * minutes = [formatTime substringWithRange:NSMakeRange(1, 2)];
    NSString * second = [formatTime substringWithRange:NSMakeRange(4, 5)];
    return minutes.floatValue * 60 + second.floatValue;
//    return [NSString stringWithFormat:@"%f",finishSecond];
}

// 以时间顺序进行排序
-(void)sortAllItem:(NSMutableArray *)array
{
    if (!array || array.count <= 0)
        return;
    for (int i = 0; i < array.count - 1; i++)
    {
        for (int j = i + 1; j < array.count; j++)
        {
            id firstDic = [array objectAtIndex:(NSUInteger )i];
            id secondDic = [array objectAtIndex:(NSUInteger)j];
            if (firstDic && [firstDic isKindOfClass:[NSDictionary class]] && secondDic && [secondDic isKindOfClass:[NSDictionary class]])
            {
                NSString *firstTime = [[firstDic allKeys] objectAtIndex:0];
                NSString *secondTime = [[secondDic allKeys] objectAtIndex:0];
                BOOL b = firstTime.floatValue > secondTime.floatValue;
                if (b) // 第一句时间大于第二句，就要进行交换
                {
                    [array replaceObjectAtIndex:(NSUInteger )i withObject:secondDic];
                    [array replaceObjectAtIndex:(NSUInteger )j withObject:firstDic];
                }
            }
        }
    }
}


@end
