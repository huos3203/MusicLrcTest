//
//  EventDescriptionFormatter.swift
//  LrcTestTests
//
//  Created by jhmac on 2020/6/9.
//  Copyright © 2020 PBBReader. All rights reserved.
//

import UIKit
import Foundation

public protocol EventProtocol {
   var name     : String {get set}
   var startDate: NSDate {get set}
   var endDate  : NSDate {get set}
}

public extension NSDate {

    class func dateFromeString(dateString: String) -> NSDate {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.date(from: dateString)! as NSDate
    }
    
    func descriptionString() -> String {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self as Date)
    }
}

class EventDescriptionFormatter: NSObject {
    
    public override init() {}
    
    public func eventDescriptionFromEvent(event : EventProtocol) -> String {
    
        return "\(event.name):开始于\(event.startDate.descriptionString()),结束于\(event.endDate.descriptionString())"
    }
}
