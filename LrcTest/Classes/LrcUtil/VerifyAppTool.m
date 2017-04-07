//
//  VerifyAppTool.m
//  DRM
//
//  Created by pengyucheng on 29/03/2017.
//  Copyright © 2017 pyc. All rights reserved.
//

#import "VerifyAppTool.h"

@implementation VerifyAppTool

+(void)verifyByVersionOwer:(NSString *)username token:(NSString *)token OnHost:(NSString *)serverUrl handler:(void (^)(NSString *, NSString *))handler
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *application_name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"application_name"];
    NSString *dataStr = [NSString stringWithFormat:@"%@?username=%@&token=%@&app_version=%@&application_name=%@&",serverUrl,username,token,version,application_name];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:dataStr]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *urlSession = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] == 200)
        {
            //NSLog(@"接收到的数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            //
          //  if ([NSJSONSerialization isValidJSONObject:data])
           // {
                //
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *code = (NSString *)[responseDic objectForKey:@"code"];
                NSNumber *result = (NSNumber *)[responseDic objectForKey:@"result"];
                NSString *msg = @"";
                if(![[responseDic objectForKey:@"msg"] isKindOfClass:[NSNull class]])
                {
                    msg = (NSString *)[responseDic objectForKey:@"msg"];

                }
            
            
                if (result.boolValue)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(code ,msg);
                    });
                    
                }
                else
                {
                    NSLog(@"result失败结果：%hhd",result.boolValue);
                }
                
           // }
        }
    }];
    [urlSession resume];
}



@end
