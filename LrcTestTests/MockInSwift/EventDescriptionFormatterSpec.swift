//
//  EventDescriptionFormatterSpec.swift
//  MusicLrcUtil
//
//  Created by jhmac on 2020/6/9.
//  Copyright © 2020 PBBReader. All rights reserved.
//

import Quick
import Nimble

//https://www.jianshu.com/p/e2dd3fcccad4

class EventDescriptionFormatterSpec: QuickSpec {
    override func spec() {
        class MockEvent: EventProtocol {
        
            var name      : String
            var startDate : NSDate
            var endDate   : NSDate
            
            init() {
            
                self.name      = "Fixture Time"
                self.startDate = NSDate.dateFromeString(dateString: "2015-11-27 09:52:00")
                self.endDate   = NSDate.dateFromeString(dateString: "2015-11-27 10:52:00")
            }
            
        }
        
        describe("EventDescriptionFormatter") { () -> Void in
            
            var descriptionFormatter : EventDescriptionFormatter!
            let mockEvent = MockEvent()
            
            beforeEach { () -> () in
                
                descriptionFormatter = EventDescriptionFormatter()
            }
            
            context(".eventDescriptionFromEvent") { () -> Void in
                
                it("should describe the event", closure: { () -> () in
                    
                    expect(descriptionFormatter.eventDescriptionFromEvent(event: mockEvent)).to(equal("Fixture Time:开始于2015-11-27 09:52:00,结束于2015-11-27 10:52:00"))
                })
            }
        }
        
    }
}
