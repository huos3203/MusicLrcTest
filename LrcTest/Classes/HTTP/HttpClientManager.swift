//
//  HttpClientManager.swift
//  LrcTest
//
//  Created by pengyucheng on 22/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

import UIKit

class HttpClientManager: NSObject
{
    
    //请求url
    func verifyAppVersionBy(withURL url:String, about app:VerifyAppVersionModel,completionHander:@escaping (VerifyAppVersionModel)->Void)
    {
        //urlsession使用
        var request = URLRequest(url: URL(string: url)!)
        print(app.convertToJSON())
        let data = app.convertToJSON().data(using: .utf8)
        request.httpBodyStream = InputStream.init(data: data!)
        request.httpMethod = "POST"
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request) {
            (data, resp, err) in
            print("响应的服务器地址：\(resp?.url?.absoluteString)")
            var dict:NSDictionary? = nil
            do {
                dict  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? NSDictionary
                app.code = dict?.object(forKey: "code") as! String
                app.result = dict?.object(forKey: "result") as! String
                app.msg = dict?.object(forKey: "msg") as! String
                completionHander(app)
            } catch {
                
            }
        }
        dataTask.resume()
    }
}
