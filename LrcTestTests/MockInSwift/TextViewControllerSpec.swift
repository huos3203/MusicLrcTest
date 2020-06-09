//
//  TextViewControllerSpec.swift
//  MusicLrcUtil
//
//  Created by jhmac on 2020/6/9.
//  Copyright © 2020 PBBReader. All rights reserved.
//

import Quick
import Nimble

class MockDataProvider: NSObject, DataProviderProtocol {
    var fetchCalled = false
    func fetch(callback: (_ data: String) -> Void) {
        fetchCalled = true
        callback("foobar")
    }
}

class TextViewControllerSpec: QuickSpec {
    override func spec() {
        describe("view controller") {
            it("fetch data with data provider") {
                let mockProvier = MockDataProvider()
                let bundle = Bundle.init(for: TextViewController.self)
                let viewController = UIStoryboard(name: "Text", bundle: bundle).instantiateViewController(withIdentifier: "TextViewController") as! TextViewController
                viewController.dataProvider = mockProvier

                expect(mockProvier.fetchCalled).to(equal(false))

                let _ = viewController.view

                expect(mockProvier.fetchCalled).to(equal(true))
            }
        }
    }
    
}
