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
     1. 使用明确清晰的方法名
     新的方法命名：
     
     明确了什么是正在被测试的对象：testPeel 指明了正在被测试的是 Banana.peel() 方法。
     明确了测试通过的条件：makesTheBananaEdible 指明了只要这个测试方法被调用后，香蕉就已经被剥皮（可食用）。
     */
//    func testPeel()
    func testPeel_makesTheBananaEdible()
    {
        //Arrange: Create the banana we'll be peeling.
        let banana = Banana()
        
        //Act: Peel the banana.
        banana.peel()
        
        //Assert: Verify that the banana is now edible.
        XCTAssertTrue(banana.isEdible)
    }
    
    
    /**
      对条件进行测试
     代码做了以下其中一件事：
        给别人一个已经被剥过皮的香蕉。
        或者给别人一个没剥皮的香蕉。
     我们的方法名字清晰地指明了测试通过时所应具备的条件：在 whenTheBananaIsPeeled 测试中，offer() 方法应该 offersTheBanana。那香蕉没被剥皮的情况呢？好吧，我们也写了另外一个测试来测试这种情况。
     
     注意，我们为每个 if 条件单独写了一个测试。在我们写测试时，确保每个条件都能被测试，是一个好的模式。如果其中一个条件不再满足，或者需要修改，我们就很容易知道哪个测试需要处理。
     */
    func testOffer_whenTheBananaIsPeeled_offersTheBanana()
    {
        // Arrange: Create a banana and peel it.
        let banana = Banana()
        banana.peel()
        
        // Act: Create the string used to offer the banana.
        let message = offer(banana)
        
        // Assert: Verify it's the right string.
        XCTAssertEqual(message, "Hey, want a banana?")
    
    }
    
    func testOffer_whenTheBananaIsntPeeled_offersToPeelTheBanana()
    {
        // Arrange: Create a banana.
        let banana = Banana()
        
        // Act: Create the string used to offer the banana.
        let message = offer(banana)
        
        // Assert: Verify it's the right string.
        XCTAssertEqual(message, "Hey, want me to peel this banana for you?")
    }
    
}
