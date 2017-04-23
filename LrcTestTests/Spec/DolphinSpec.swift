//
//  DolphinSpec.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import Quick
import Nimble

class DolphinSpec: QuickSpec {
    override func spec()
    {
        /**
         it 函数 用于描述测试的方法名，代表一个最小的单元用例，有两个参数：例子的名称和闭包
         下面这个例子具体说明了 Sea.Dolphin 类应有的行为：
         一只新的海豚（dolphin）应该是聪明（smart）且友好（friendly）的：
         */
        it("is friendly") { 
            //
            expect(Dolphin().isFriendly).to(beTruthy())
        }
        
        it("is smart") { 
            //
            expect(Dolphin().isSmart).to(beTruthy())
        }
        
        /**
         例子群：使用 describe 和 context，是按一定逻辑关系组织的例子。
         例子群支持：共享配置（setup）和卸载（teardown）代码。
         
         当这两个例子在 Xcode 中运行的时候，它们会从 describe 和 it 函数中输出一些描述性的语言：
         ```
         DolphinSpec.a_dolphin_its_click_is_loud
         DolphinSpec.a_dolphin_its_click_has_a_high_frequency
         ```
         显然，这两个测试各自测试的内容都很清晰明了。
         */
        describe("a dolphin") {
            //
            describe("its click", closure: {
                //
                it("is loud", closure: { 
                    //
                    let click:Click = Dolphin().click()
                    expect(click.isLoud).to(beTruthy())
                })
                
                it("has a high frequency", closure: { 
                    //
                    let click:Click = Dolphin().click()
                    expect(click.hasHighFrequency).to(beTruthy())
                })
            })
            
        }
        
        /**
         使用 beforeEach 和 afterEach 共享配置／卸载代码
         对于海豚这个例子来说，像这样共享配置代码并不是一个很大的工程。
         但是对于更复杂的对象，共享代码能够省去大量写代码的时间！
         如果想在每个例子后面执行特定的代码，可以使用 afterEach
         */
        describe("a dolphin") { 
            
            var dolphin:Dolphin?
            //共享配置1
            beforeEach {
                //
                dolphin = Dolphin()
            }
            
            describe("its click", closure: { 
                
                var click:Click?
                ///共享配置2
                beforeEach {
                    click = dolphin?.click()
                }
                it("is loud", closure: { 
                    expect(click?.isLoud).to(beTruthy())
                })
                it("is high frequency", closure: { 
                    //
                    expect(click?.hasHighFrequency).to(beTruthy())
                })
                
            })
        }
        
        
        /**
         使用 context 指定条件的行为
         海豚使用叫声进行回声定位。当接近了它们感兴趣的东西时，海豚会发出一系列的超声波对其进行更准确的探测。
         
         这个测试需要展示在不同环境下，click 方法的不同行为。通常，海豚只叫（click）一声。但是当海豚接近它们感兴趣的东西时，它会发出很多次叫声。
         
         这种情况可以用 context 函数来表示：
         一个 context 代表正常情况，
         一个 context 代表海豚接近感兴趣的东西
        */
        
        // context用于指定条件或状态
        describe("a dolphin") { () -> () in
            
            var dolphin : Dolphin!
            //共享配置
            beforeEach({ () -> Void in
                
                dolphin = Dolphin()
            })
            
            describe("its click", closure: { () -> () in
                
                var click : Click!
                //共享配置
                beforeEach({ () -> () in
                    
                    click = dolphin.click()
                })
                
                //场景1
                context("when the dolphin is not near anything interesting", { () -> Void in
                    
                    it("is only emited once", closure: { () -> () in
                        
                        expect(click.count()).to(equal(1))
                    })
                })
                
                //场景2
                context("when the dolphin is near something intereting", { () -> Void in
                    
                    it("is emited three times", closure: { () -> () in
                        
                        expect(click.count()).to(equal(3))
                    })
                })
            })
        }

        
        /**
        访问当前例子的元数据
        在某些情况下，你会想知道当前运行的例子的名称，或者目前已经运行了多少例子。Quick 提供了闭包 beforeEach 和 afterEach ，通过这些闭包，可以访问元数据。
        */
        beforeEach { exampleMetadata in
            print("Example number \(exampleMetadata.exampleIndex) is about to be run.")
        }
        
        afterEach { exampleMetadata in
            print("Example number \(exampleMetadata.exampleIndex) has run.")
        }
    }
}
