//
//  VerifyAppTool.h
//  DRM
//
//  Created by pengyucheng on 29/03/2017.
//  Copyright © 2017 pyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyAppTool : NSObject

+(void)verifyByVersionOwer:(NSString *)username token:(NSString *)token OnHost:(NSString *)serverUrl handler:(void(^)(NSString *code,NSString *msg))handler;

@end
