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
        if model.lrcURL.utf16.count == 0
        || model.musiclyric_id.utf16.count == 0
        || model.token.utf16.count == 0
        || model.username.utf16.count == 0
        {
            return
        }
        
        //当文件存在时
        if(FileManager.default.fileExists(atPath: model.localPath))
        {
            loadLrc(model.localPath)
            return
        }
        
        var request = URLRequest(url: URL(string: model.lrcURL)!)
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
                    self.downLRCFile(urlStr: httpURL!,
                                   fileName: model.localPath,
                                    loadLrc: loadLrc)
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
        let urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        print("lujing: === \(urlStr)")
        let url = URL(string:urlStr!)!
        let downTask = URLSession.shared.downloadTask(with: url) { (location, response, err) in
            
            
            let responses = response as! HTTPURLResponse
            print("responses.statusCode：-----\(responses.statusCode)")
            if (responses.statusCode == 200)
            {
                //正式
                let lrcFileURL = URL.init(fileURLWithPath: fileName)
                
                //test
                //let lrcFileURL = self.createLRCDir()
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
        downTask.resume()
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
