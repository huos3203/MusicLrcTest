//
//  LrcTestTests.m
//  LrcTestTests
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLLrcTool.h"
#import "CLLrcLine.h"
#import "LrcTestTests-Swift.h"

@interface LrcTestTests : XCTestCase

@end

@implementation LrcTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *lineText = @"[02:45.23][01:18.45]让我一等再等";
    //正则表达式实现
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\d{1,2}"
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSLog(@"============");
    [regex enumerateMatchesInString:lineText
                            options:0
                              range:NSMakeRange(0, [lineText length])
                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                             NSRange matchRange = [match range];
                             NSLog(@"=======ddddd=====%@",match);
                             NSRange firstHalfRange = [match rangeAtIndex:0];
//                             NSRange secondHalfRange = [match rangeAtIndex:2];
                             NSString *time = [lineText substringWithRange:firstHalfRange];
                             NSLog(@"时间：%@",matchRange);
                         }];
}

-(void)testExampleFor
{
    NSString *lineText = @"[02:45.23][01:18.45]让我一等再等";
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"\\d{2}:\\d{2}.\\d{2}" options:0 error:nil];
    NSRegularExpression *regLrc = [[NSRegularExpression alloc] initWithPattern:@"][^\\]]*" options:0 error:nil];
    NSArray *matchsLrc = [regLrc matchesInString:lineText options:0 range:NSMakeRange(0, [lineText length])];
    NSString *lrcc = @"";
    for (NSTextCheckingResult *match in matchsLrc)
    {
        NSRange lrcRange = [match rangeAtIndex:0];
        lrcc = [lineText substringWithRange:lrcRange];
    }
    NSArray *matchs = [reg matchesInString:lineText options:0 range:NSMakeRange(0, [lineText length])];
    for (NSTextCheckingResult * match in matchs)
    {
        NSRange lastRange = [[matchs lastObject] rangeAtIndex:0];
        lrcc = [lineText substringFromIndex:lastRange.location + lastRange.length + 1];
        NSString *text = [lineText substringWithRange:[match rangeAtIndex:0]];
        NSLog(@"匹配字符：%@",text);
    }
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


-(void)testParserLrcFile
{
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:@"qbd" ofType:@"lrc"];
    NSArray *lrcArray = [[CLLrcTool shared]ParserLrcWithPath:lrcPath];
    for (CLLrcLine * line in lrcArray)
    {
        NSLog(@"%@\n",line.description);
    }
//    [ enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CLLrcLine *line = (CLLrcLine *)obj;
//        NSLog(@"%@\n",line.description);
//    }];
}


-(void)testVerVersion
{
    NSString *url = @"http://192.168.85.13:8660/DRM/client/product/verifyAppVersion";
    HttpClientManager *manager = [HttpClientManager new];
    VerifyAppVersionModel *model = [[VerifyAppVersionModel alloc] initWithUsername:@"222" token:@"dddd"];
    [manager verifyAppVersionByWithURL:url
                                 about:model
                      completionHander:^(VerifyAppVersionModel * app) {
                          //
                          NSLog(@"-------%@",app.msg);
                      }];

}

@end
