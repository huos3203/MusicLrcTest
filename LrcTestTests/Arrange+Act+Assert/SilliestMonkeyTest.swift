//
//  SilliestMonkeyTest.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import XCTest

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
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
