//
//  Dolphin.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

public struct Click
{    
    public var isLoud = true
    public var hasHighFrequency = true
    
    public func count() -> Int {
        
        return 1
    }
}

public class Dolphin {
    
    public  var isFriendly = true
    public  var isSmart    = true
    public  var isHappy    = false
    
    public init() {
        
    }
    
    public init(happy: Bool) {
        
        isHappy = happy
    }
    
    public func click() -> Click {
        
        return Click()
    }
    
    public func eat(food: AnyObject) {
        
        isHappy = true
    }
}

