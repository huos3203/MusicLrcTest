//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let reg = try! NSRegularExpression.init(pattern: "\\d{2}:\\d{2}.\\d{2}", options: .caseInsensitive)
let lineText = "[02:45.23][01:18.45]让我一等再等"
reg.enumerateMatches(in: lineText,
                options: NSRegularExpression.MatchingOptions.anchored,
                  range: NSRange.init(location: 0, length: lineText.utf16.count))
            { (match, flags, stop) in
                //
                let matchRange = match?.rangeAt(1)
                let time = (lineText as NSString).substring(with: matchRange!)
                print("----\(time)")
            }

