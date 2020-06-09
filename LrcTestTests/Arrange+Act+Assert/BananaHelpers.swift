//
//  BananaHelpers.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

class BananaHelpers: NSObject
{
    ///internal:只能访问自己模块的任何internal实体，不能访问其他模块中的internal实体。
    ///internal可以省略，换句话说，默认访问限定是internal。
    internal func createNewPeeledBanana() -> Banana
    {
        let banana = Banana()
        banana.peel()
        return banana
    }

}
