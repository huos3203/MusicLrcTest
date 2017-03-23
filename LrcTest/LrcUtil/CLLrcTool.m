//
//  CLLrcTool.m
//  QQMusic
//
//  Created by 杨博兴 on 16/10/19.
//  Copyright © 2016年 xx_cc. All rights reserved.
//

#import "CLLrcTool.h"
#import "CLLrcLine.h"

static  CLLrcTool *instance;
@implementation CLLrcTool

+(NSArray *)lrcToolWithLrcPath:(NSString *)lrcFilePath
{
    // 2. 获取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcFilePath encoding:NSUTF8StringEncoding error:nil];
    
    // 将歌词转化为数组 ，会以每个\n为分隔符 转化为数组中的每个元素
    NSArray *lrcArr = [lrcString componentsSeparatedByString:@"\n"];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSString *lrcLineString in lrcArr) {
        
        // 过滤掉不要的字符串，如果是以这些开头 或者不是以[开头的直接退出循环
        if ([lrcLineString hasPrefix:@"[ti:"] ||
            [lrcLineString hasPrefix:@"[ar:"] ||
            [lrcLineString hasPrefix:@"[al:"] ||
            [lrcLineString hasPrefix:@"[by:"] ||
            ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        // 将字符串转化为模型
        CLLrcLine *lrcLine = [CLLrcLine LrcLineString:lrcLineString];
        [tempArr addObject:lrcLine];
    }
    return tempArr;
}

+(CLLrcTool *)shared
{
    if (!instance)
    {
        instance = [[CLLrcTool alloc] init];
    }
    return instance;
}


//解析单行 样例：[02:45.23][01:18.45]让我一等再等
//将单行信息加入数组并排序
-(NSArray *)ParserLrcWithPath:(NSString *)lrcFilePath
{
    // 2. 获取歌词
    NSString *lrcSource = [NSString stringWithContentsOfFile:lrcFilePath encoding:NSUTF8StringEncoding error:nil];
    // 将歌词转化为数组 ，会以每个\n为分隔符 转化为数组中的每个元素
    NSArray *lrcSourceArr = [lrcSource componentsSeparatedByString:@"\n"];
    __block NSMutableArray *lrcArray = [NSMutableArray new];
    [lrcSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *tempArray = [self parpserLineText:(NSString *)obj];
        [lrcArray addObjectsFromArray:tempArray];
    }];
    
    //排序
    NSArray *tempArray =  [lrcArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CLLrcLine *obj1Model = obj1;
        CLLrcLine *obj2Model = obj2;
        NSComparisonResult result = [[NSNumber numberWithDouble:obj1Model.time] compare:[NSNumber numberWithDouble:obj2Model.time]];
        return result == NSOrderedDescending; // 升序
    }];
    return tempArray;
}

-(NSMutableArray *)parpserLineText:(NSString *)lineText
{
    NSMutableArray *lineArr = [NSMutableArray new];
    //正则表达式实现
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\d{1,2}:\\d{2}.\\d{2}"
                                                                    options:NSRegularExpressionCaseInsensitive
                                                                      error:nil];
    NSArray *matchs = [regex matchesInString:lineText options:0 range:NSMakeRange(0, lineText.length)];
    for (NSTextCheckingResult *match in matchs)
    {
        NSRange lastRange = [[matchs lastObject] rangeAtIndex:0];
        NSString *lrcc = [lineText substringFromIndex:lastRange.location + lastRange.length + 1];
        //
        NSRange timeRange = [match rangeAtIndex:0];
        NSString *timeStr = [lineText substringWithRange:timeRange];
        CLLrcLine *lrcLine = [[CLLrcLine alloc] initWithText:lrcc andTime:timeStr];
        [lineArr addObject:lrcLine];
    }
    
    return [lineArr mutableCopy];
   
    
//    [regex enumerateMatchesInString:lineText
//                            options:0
//                              range:NSMakeRange(0, [lineText length])
//                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//        NSRange matchRange = [match range];
//        NSRange firstHalfRange = [match rangeAtIndex:1];
//        NSRange secondHalfRange = [match rangeAtIndex:2];
//        
//    }];
}
@end
