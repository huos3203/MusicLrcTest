//
//  BananaTests.swift
//  MusicLrcUtil
//
//  Created by Xcode Server on 2017/4/21.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit
import XCTest
class BananaTests: XCTestCase
{
    /**
     验证Peel行为
     */
    func testPeel()
    {
        //安排
        let banana = Banana()
        
        //动作
        banana.peel()
        
        //断言
        XCTAssertTrue(banana.isEdible)
    }
    
}
