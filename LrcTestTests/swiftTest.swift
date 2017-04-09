//
//  swiftTest.swift
//  LrcTest
//
//  Created by pengyucheng on 22/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

import XCTest
@testable import LogSwift
@testable import LrcTest
class swiftTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("提示版本信息------")
        let expection = expectation(description: "失败时显示原因")
        
        let app = VerifyAppVersionModel.init(username: "2323", token: "2313")
        
        
        let client = HttpClientManager()
        let url = "http://192.168.85.13:8660/DRM/client/product/verifyAppVersion"
        client.verifyAppVersionBy(withURL: url, about: app) { (app) in
            //
            print("提示版本信息")
            expection.fulfill()
        }
        
        //在方法底部指定一个超时，如果测试条件不适合时间范围便会结束执行：
        waitForExpectations(timeout: 5) { error in
            //
            print("错误信息:\(error?.localizedDescription)")
        }

    }
    
    func testjiami() {
        let log = PBBLogModel()
        let enc = log.aesEncryptPassword(password: "dfdfdf", secret: "d")
        print(enc)
        let des = log.aesDecryptor(password: enc, secret: "d")
        print(des)
    }
    
    func testHttp() {
        //
        let model = MusicLrcModel.init(username: "", token: "", lrcURL: "", musiclyric_id: "", localPath: "")
        HttpClientManager().downMusicLrcBy(lrcModel: model) { (path, log) in
            //
            print("路径：\(path),日志：\(log)")
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
