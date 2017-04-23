//
//  Offer.swift
//  MusicLrcUtil
//
//  Created by Xcode Server on 2017/4/21.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

public func offer(_ banana:Banana) -> String
{
    //
    if banana.isEdible
    {
        // 给人一个已经剥好的香蕉
        return "Hey, want a banana?"
    }
    else
    {
        // 给人一个味剥皮的香蕉
        return "Hey, want me to peel this banana for you?"
    }
}

