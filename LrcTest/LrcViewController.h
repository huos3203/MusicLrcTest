//
//  ViewController.h
//  LrcTest
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "MusicLrcView.h"
@interface LrcViewController : UIViewController<MusicLrcDelegate>
{
    AVPlayer * _player;
    AVAudioPlayer *_audioPlayer;
}
@end

