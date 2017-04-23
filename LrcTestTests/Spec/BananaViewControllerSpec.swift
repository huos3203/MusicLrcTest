//
//  BananaViewControllerSpec.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import Quick
import Nimble

class BananaViewControllerSpec: QuickSpec
{
    override func spec()
    {
        var viewController:BananaViewController!
        beforeEach { 
            viewController = BananaViewController()
        }
        
        //#1 加载周期
        describe(".viewDidLoad()") {
            
            beforeEach({ 
                //方法1:访问控制器的View，来触发控制器的.viewDidLoad()
                let _ = viewController.view
            })
            
            it("sets banana count label to zero", closure: {
                print(viewController.bananaCountLabel.text)
                expect(viewController.bananaCountLabel.text).to(equal("0"))
            })
        }
        
        //#2
        describe("the view") {
            //方法2: 触发.viewDidLoad(), .viewWillAppear(), 和 .viewDidAppear() 事件
            beforeEach({ 
                //
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()
            })
            
            it("sets banana count label to zero", closure: {
                //
                expect(viewController.bananaCountLabel.text).to(equal("10"))
            })
        }
        
        
        //#3
        describe(".viewDidLoad()") {
            //
            beforeEach({ () -> () in
                
                // 方法3: 直接调用生命周期事件
                viewController.viewDidLoad()
            })

            it("sets banana count label to zero", closure: { () -> () in
                
                expect(viewController.bananaCountLabel.text).to(equal("10"))
            })
        }
        
        //#4 测试UIControl事件
        describe("the more banana button") {
            beforeEach({ 
                //
                viewController.viewDidLoad()
            })
            
            it("increments the banana count label when tapped", closure: {
                viewController.button.sendActions(for: .touchUpInside)
                expect(viewController.bananaCountLabel.text).to(equal("1"))
            })
        }
    }
}
