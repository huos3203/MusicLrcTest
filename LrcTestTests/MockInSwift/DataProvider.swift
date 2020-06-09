//
//  DataProvider.swift
//  LrcTestTests
//
//  Created by jhmac on 2020/6/9.
//  Copyright © 2020 PBBReader. All rights reserved.
//

import UIKit

protocol DataProviderProtocol: class {
    func fetch(callback: @escaping (_ data: String) -> Void)
}

class DataProvider: NSObject, DataProviderProtocol {
    //https://stackoverflow.com/questions/59784963/swift-escaping-closure-captures-non-escaping-parameter-oncompletion
    func fetch(callback: @escaping (_ data: String) -> Void) {
        let url = NSURL(string: "http://example.com/")!
        let session = URLSession(configuration: URLSessionConfiguration.default)

        let task = session.dataTask (with: url as URL, completionHandler: { (data, resp, err) in
            let string = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)! as String
            callback(string)
        })
        task.resume()
    }
}

class TextViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var resultLabel: UILabel!
    var dataProvider: DataProviderProtocol?

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataProvider = dataProvider ?? DataProvider()

        dataProvider?.fetch(callback: { [unowned self] (data) -> Void in
            self.resultLabel.text = data
        })
    }
}
