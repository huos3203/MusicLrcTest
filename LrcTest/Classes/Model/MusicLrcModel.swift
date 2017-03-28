//
//  MusicLrcModel.swift
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
    var username = ""
    var token = ""
    var lrcURL = ""
    var musiclyric_id=""
    
    public init(username:String,token:String,lrcURL:String,musiclyric_id:String)
    {
        //
        self.username = username
        self.token = token
        self.lrcURL = lrcURL
        self.musiclyric_id = musiclyric_id
    }
    
    //转为请求数据
    func convertToJSON() -> String
    {
        return requestBody()
    }
}
