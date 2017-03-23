//
//  MusicModel.h
//  LrcTest
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicLrcParser :NSObject

-(NSMutableArray *)parseLrcLocalPath:(NSString *)localPath;
+(MusicLrcParser *)shared ;
@end
