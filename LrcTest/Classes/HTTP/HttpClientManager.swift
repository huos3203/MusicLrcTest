//
//  HttpClientManager.swift
//  LrcTest
//
//  Created by pengyucheng on 22/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

import UIKit

public class HttpClientManager:NSObject
{
    
    public class var shareInstance:HttpClientManager
    {
        struct Singleton {
            static let instance = HttpClientManager()
        }
        return Singleton.instance
    }
    
    
    
    //请求url
    public func verifyAppVersionBy(withURL url:String,
                                     about app:VerifyAppVersionModel,
                              completionHander:@escaping (VerifyAppVersionModel)->Void)
    {
        //urlsession使用
        var request = URLRequest(url: URL(string: url)!)
        print(app.convertToJSON())
        let data = app.convertToJSON().data(using: .utf8)
        request.httpBodyStream = InputStream.init(data: data!)
        request.httpMethod = "POST"
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request) {
            (data, resp, err) in
           // print("响应的服务器地址：\(resp?.url?.absoluteString)")
            let response = resp as! HTTPURLResponse
            if(response.statusCode == 200)
            {
                var dict:NSDictionary? = nil
                do {
                    dict  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? NSDictionary
                    app.code = dict?.object(forKey: "code") as! String
                    let resu = dict?.object(forKey: "result") as! NSNumber
                    app.result = resu.boolValue
                    app.msg = dict?.object(forKey: "msg") as! String
                    completionHander(app)
                } catch {
                    print("验证app版本，解析时失败")
                }
            }
        }
        dataTask.resume()
    }
    
    //下载歌词
    public func downMusicLrcBy(lrcModel model:MusicLrcModel , loadLrc:@escaping (String)->Void)
    {
        if (model.lrcURL == nil || (model.lrcURL?.isEmpty)!)                //model.lrcURL.utf16.count == 0
        || (model.musiclyric_id == nil || (model.musiclyric_id?.isEmpty)!)  //model.musiclyric_id.utf16.count == 0
        || (model.token == nil || (model.token?.isEmpty)!)                  //model.token.utf16.count == 0
        || (model.username == nil || (model.username?.isEmpty)!)            //model.username.utf16.count == 0
        || (model.localPath == nil || (model.localPath?.isEmpty)!)            //model.username.utf16.count == 0)
        {
            loadLrc("")
            return
        }
        
        //当文件存在时
        if(FileManager.default.fileExists(atPath: model.localPath!))
        {
            loadLrc(model.localPath!)
            return
        }
        
        var request = URLRequest(url: URL(string: model.lrcURL!)!)
        print(model.convertToJSON())
        let data = model.convertToJSON().data(using: .utf8)
        request.httpBodyStream = InputStream.init(data: data!)
        request.httpMethod = "POST"
        let requestLrcURL = URLSession.shared.dataTask(with: request) { (data, response, err) in
            //
            let responses = response as! HTTPURLResponse
            print("responses.statusCode：-----\(responses.statusCode)")
            if (responses.statusCode == 200)
            {
                let httpURL = String.init(data: data!, encoding: String.Encoding.utf8)
                
                if (httpURL?.lowercased().hasSuffix("lrc"))!
                {
                    //test
                    //let lrcFileURL = self.createLRCDir().path
                    let lrcFileURL = model.localPath!
                    self.downLRCByStringURL(urlStr:  httpURL!, fileName: lrcFileURL, loadLrc: loadLrc)
                }
                else
                {
                    print("文件路径错误")
                    loadLrc("")
                }
            }
        }
        requestLrcURL.resume()
    }
    
    func downLRCFile(urlStr:String,fileName:String ,loadLrc:@escaping (String)->Void)
    {
        //http://www.jianshu.com/p/5445f2205f70 URLHostAllowedCharacterSet
        let urlStr1 = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = URL(string:urlStr1!)!
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        let downTask = URLSession.shared.downloadTask(with: request) { (location, response, err) in
            let responses = response as! HTTPURLResponse
            print("responses.statusCode：-----\(responses.statusCode)")
            if (responses.statusCode == 200)
            {
                let lrcFileURL = URL.init(fileURLWithPath: fileName)
                do{
                    try FileManager.default.copyItem(at: location!, to: lrcFileURL)
                    print("存盘路径：\(lrcFileURL.absoluteString)")
                    loadLrc(lrcFileURL.path)
                }
                catch
                {
                    print("存盘失败：\(err?.localizedDescription)")
                    loadLrc("")
                }
            }
            else
            {
                loadLrc("")
            }
        }
        //let downTask = URLSession.shared.downloadTask(with: url) { (location, response, err) in  }
        downTask.resume()
    }

    
    func downLRCByStringURL(urlStr:String,fileName:String ,loadLrc:@escaping (String)->Void)
    {
        //
        let urlStr1 = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = URL(string:urlStr1!)!
        do {
            let htmlsource = try NSString.init(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
            print(htmlsource)
            let lrcFileURL = URL.init(fileURLWithPath: fileName)
            try htmlsource.write(to: lrcFileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
            loadLrc(lrcFileURL.path)
        } catch
        {
            //
            loadLrc("")
        }
        
    }


    func createLRCDir()->URL
    {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let lrcDirURL = URL.init(fileURLWithPath: documentPath!)
        do
        {
            try FileManager.default.createDirectory(at: lrcDirURL, withIntermediateDirectories: true, attributes: nil)
        }catch{
            print("=====")
        }
        
        return lrcDirURL.appendingPathComponent("test.lrc")
    }
    
    //
    public func loadLrcBy(lrcModel:MusicLrcModel,player:AVAudioPlayer,lrcDelegate:MusicLrcDelegate,completion:@escaping (Bool)->Void)
    {
        MusicLrcView.shared().showindicatorView()
        downMusicLrcBy(lrcModel: lrcModel) { (lrcPath) in
            //
            OperationQueue.main.addOperation {
                let isCanLoad = MusicLrcView.shared().loadLrc(by: lrcPath, audioPlayer: player, lrcDedegate: lrcDelegate)
                completion(isCanLoad)
            }
        }
    }
}
