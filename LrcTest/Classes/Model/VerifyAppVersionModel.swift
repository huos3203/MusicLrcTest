//
//  VerifyAppVersionModel.swift
//  LrcTest
//
//  Created by pengyucheng on 22/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

import UIKit

class VerifyAppVersionModel: NSObject {

    var username = ""
    var token = ""
    var application_name = { () -> NSString in 
        let bundle = Bundle.init(for: VerifyAppVersionModel.self)
        return bundle.object(forInfoDictionaryKey: "CFBundleName") as! NSString
    }()
    var app_version = { () -> NSString in 
        let bundle = Bundle.init(for: VerifyAppVersionModel.self)
        return bundle.object(forInfoDictionaryKey: "CFBundleVersion") as! NSString
    }()
    
    var result = ""
    var code = "" //状态码
    var msg = ""
    
    init(username:String,token:String)
    {
        self.username = username
        self.token = token
    }
    //转为请求数据
    func convertToJSON() -> String
    {
        return requestBody()
    }
}
