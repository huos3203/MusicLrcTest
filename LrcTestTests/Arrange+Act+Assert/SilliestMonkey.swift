//
//  SilliestMonkey.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

// 遵循Equatable协议,必须实现此方法
public func ==(lhs: Monkey, rhs: Monkey) -> Bool
{
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

public func silliest(_ monkeys: [Monkey]) -> [Monkey]
{
    return monkeys.filter { $0.silliness == .VerySilly /*|| $0.silliness == .ExtremelySilly */}
}

public func monkeyContains<T : Equatable>(_ array : [T], _ object : T?) -> Bool
{
    for temp in array {
        
        if temp == object {
            
            return true
        }
    }
    
    return false
}
