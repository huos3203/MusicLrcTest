//
//  MusicLrcswift
//  LrcTest
//
//  Created by Xcode Server on 2017/3/27.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit
// /client/downloadMusicLyric/{musicLyric_id}
// username /token / musiclyric_id
@objc
public class MusicLrcModel: NSObject
{
    var username:String?
    var token:String?
    var lrcURL:String?
    var musiclyric_id:String?
    var localPath:String?
    
    public init(username:String,token:String,lrcURL:String,musiclyric_id:String,localPath:String)
    {
        self.username = username
        self.token = token
        self.lrcURL = lrcURL
        self.musiclyric_id = musiclyric_id
        self.localPath = localPath
    }
    
    //转为请求数据
    func convertToJSON() -> String
    {
        return requestBody()
    }
}
