//
//  Banana.swift
//  MusicLrcUtil
//
//  Created by Xcode Server on 2017/4/21.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

/**
 剥香蕉皮
 */
public class Banana
{
    private var isPeeled = false
    ///Arrange:创建一个
    
    public func peel()
    {
        isPeeled = true
    }
    
    /**
     判断香蕉是否能吃
     */
    public var isEdible:Bool{
        return isPeeled
    }
}
