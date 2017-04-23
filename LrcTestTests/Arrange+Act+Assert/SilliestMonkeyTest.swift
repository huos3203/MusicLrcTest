//
//  SilliestMonkeyTest.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import XCTest
import Nimble
/**
 更好的失败返回信息，
    第一部分：手动设定 XCTAssert 的返回信息
    第二部分：Nimble 的返回信息
 */
class SilliestMonkeyTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSilliest_whenMonkeysContainSillyMonkeys_theyreIncludedInTheResult()
    {
        // Arrange:
        let kiki = Monkey(name: "Kiki", silliness: .ExtremelySilly)
        let carl = Monkey(name: "Carl", silliness: .NotSilly)
        let jane = Monkey(name: "Jane", silliness: .VerySilly)
        
        // Act:
        let sillyMonkeys = silliest([kiki, carl, jane])
        
        // Assert:
        XCTAssertTrue(monkeyContains(sillyMonkeys, kiki))
        //        XCTAssertTrue(monkeyContains(sillyMonkeys,object: kiki), "Expected sillyMonkeys to contain 'Kiki'")
        
        ///Nimble 能让你的测试断言及其返回信息更便于阅读：
        //预期中 kiki 应该包含在 silliest() 的返回值里面，但是实际的返回值只包含 jane
        expect(sillyMonkeys).to(contain(kiki))
        
        /*
         这个返回信息清楚地点明了出错的地方,因此很容易解决问题：
         expected to contain <Monkey(name: Kiki, sillines: ExtremelySilly)>,
         got <[Monkey(name: Jane, silliness: VerySilly)]>
         
         //实际返回值
         expected to contain <LrcTestTests.Monkey>, got <[LrcTestTests.Monkey]>
         */
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
