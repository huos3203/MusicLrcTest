//
//  MusicAPI.swift
//  LrcTest
//
//  Created by huoshuguang on 2017/3/28.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

public class MusicAPI: NSObject
{
    class var shareInstance: MusicAPI
    {
        //
        struct Singleton{
           static let instance = MusicAPI()
        }
        
        return Singleton.instance
    }
    
    private var clockViewManager:ClockListView!
    private var lrcViewManager:MusicLrcView!
    private var httpTaskManager:HttpClientManager!
    override init() {
        //
        clockViewManager = ClockListView()
        lrcViewManager = MusicLrcView()
        httpTaskManager = HttpClientManager()
        
    }
    
    //下载，同步歌词
    public func downLrcBy(lrc model:MusicLrcModel,SyncTo player:AVAudioPlayer,lrcDelegate:MusicLrcDelegate,completion:@escaping(Bool)->Void)
    {
        //
        lrcViewManager.showindicatorView()
        httpTaskManager.downMusicLrcBy(lrcModel: model) { (lrcPath) in
            //
            OperationQueue.main.addOperation {
                let isCanLoad = self.lrcViewManager.loadLrc(by: lrcPath, audioPlayer: player, lrcDedegate: lrcDelegate)
                completion(isCanLoad)
            }
        }
    }
    
    //定时关闭
    public func setupTimerTo(view:UIView,delegate:DelayClockDelegate)
    {
        clockViewManager.delayClockVC.delayClockDelegate = delegate
        view.addSubview(clockViewManager)
    }


}
