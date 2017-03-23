//
//  ViewController.h
//  LrcTest
//
//  Created by pengyucheng on 08/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import <MusicLRC/MusicLrcView.h>
#import <MusicLRC/MusicLRC-Swift.h>
@interface LrcViewController : UIViewController<MusicLrcDelegate,DelayClockDelegate>
{
    AVPlayer * _player;
    AVAudioPlayer *_audioPlayer;
}

@property (strong, nonatomic) ClockTransitioningDelegate *exampleTransitionDelegate;
 //[ExampleTransitioningDelegate new]
@end

