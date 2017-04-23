//
//  Monkey.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

public enum Silliness
{
    case ExtremelySilly
    case NotSilly
    case VerySilly
}
public class Monkey: Equatable
{
    var name:String?
    var silliness:Silliness?
    init(name:String,silliness:Silliness)
    {
        self.name = name
        self.silliness = silliness
    }
}
