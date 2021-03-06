//
//  HttpClientManager.swift
//  LrcTest
//
//  Created by pengyucheng on 22/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

import UIKit
import LogSwift
public class HttpClientManager:NSObject
{
    
    @objc public class var shareInstance:HttpClientManager
    {
        struct Singleton {
            static let instance = HttpClientManager()
        }
        return Singleton.instance
    }
    
    //下载歌词
    public func downMusicLrcBy(lrcModel model:MusicLrcModel , loadLrc:@escaping (String,String)->Void)
    {
        if (model.lrcURL == nil || (model.lrcURL?.isEmpty)!)                //model.lrcURL.utf16.count == 0
        || (model.musiclyric_id == nil || (model.musiclyric_id?.isEmpty)!)  //model.musiclyric_id.utf16.count == 0
        || (model.token == nil || (model.token?.isEmpty)!)                  //model.token.utf16.count == 0
        || (model.username == nil || (model.username?.isEmpty)!)            //model.username.utf16.count == 0
        || (model.localPath == nil || (model.localPath?.isEmpty)!)            //model.username.utf16.count == 0)
        {
            loadLrc("","请求数据不完整")
            PBBLogModel.init(.DEBUG, in: .SuiZhi, desc: "请求数据不完整").sendTo()
            return
        }
        
        //当文件存在时
        if(FileManager.default.fileExists(atPath: model.localPath!))
        {
            //try! FileManager.default.removeItem(atPath: model.localPath!)
            loadLrc(model.localPath!,"")
            return
        }
        //self.requestLRCURL(model: model, loadLrc: loadLrc)
        self.requestLRCURLBy(model: model, loadLrc: loadLrc)
    }
    

    /// 请求歌词路径
    func requestLRCURLBy(model:MusicLrcModel, loadLrc:@escaping (String,String)->Void)
    {
        ///此处无需转码：addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let urladd = "\(model.lrcURL!)?\(model.convertToJSON())"
        let url = URL(string:urladd)!
        do {
            let httpURL = try NSString.init(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
            //print(htmlsource)
            if (httpURL.lowercased.hasSuffix("lrc"))
            {
                //test
                //let lrcFileURL = self.createLRCDir().path
                let lrcFileURL = model.localPath!
                self.downLRCByStringURL(urlStr:  httpURL as String, fileName: lrcFileURL, loadLrc: loadLrc)
            }
            else
            {
                //print("文件路径错误")
                loadLrc("","lrc路径错误：\(httpURL)")
            }
            
        } catch
        {
            //
            loadLrc("","请求lrc文件路径：\(urladd)，错误\(error.localizedDescription)")
        }

    }
    /// 下载歌词
    func downLRCByStringURL(urlStr:String,fileName:String ,loadLrc:@escaping (String,String)->Void)
    {
        //   
        let urlStr1 = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = URL(string:urlStr1!)!
        let lrcFileURL = URL.init(fileURLWithPath: fileName)
        var encoding:UInt
        do
        {
            // 获得编码ID
            encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            try sourceByEncoding(sourceURL: url, lrcFileURL: lrcFileURL, encoding: encoding)
            loadLrc(lrcFileURL.path,"")
        }
        catch
        {
            do {
                encoding = String.Encoding.utf8.rawValue
                try sourceByEncoding(sourceURL: url, lrcFileURL: lrcFileURL, encoding: encoding)
                loadLrc(lrcFileURL.path,"下载歌词：\(urlStr1)，gbk失败：\(error.localizedDescription)\n 开始使用utf8格式下载")
            } catch
            {
                print(error.localizedDescription)
                loadLrc("","lrc文件：\(urlStr1)，存盘中失败:\(error.localizedDescription)")
            }
            
        }
        
    }
    
    /// 通过指定的编码格式下载歌词
    func sourceByEncoding(sourceURL:URL,lrcFileURL:URL,encoding:UInt) throws
    {
        let htmlsource = try NSString.init(contentsOf: sourceURL, encoding: encoding)
        try htmlsource.write(to: lrcFileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
    }
    
    
    
    //MARK: 测试
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
}



extension HttpClientManager
{
    
    ///下载完成后，同步歌词
    @objc public func loadLrcBy(lrcModel:MusicLrcModel,player:AVAudioPlayer,lrcDelegate:MusicLrcDelegate,completion:@escaping (Bool,String)->Void)
    {
        MusicLrcView.shared().showindicatorView()
        downMusicLrcBy(lrcModel: lrcModel) { (lrcPath,logmessage) in
            //
            OperationQueue.main.addOperation {
                let isCanLoad = MusicLrcView.shared().loadLrc(by: lrcPath, audioPlayer: player, lrcDedegate: lrcDelegate)
                completion(isCanLoad,logmessage)
            }
        }
    }
    
    ///移除歌词同步定时器
    public func removeLrcTimer()
    {
        MusicLrcView.shared().removeLrcTimer()
    }
}

extension HttpClientManager
{
    /// 访问请求歌词路径的接口，出现501的频率很高
    func downLRCFile(urlStr:String,fileName:String ,loadLrc:@escaping (String)->Void)
    {
        //http://www.jianshu.com/p/5445f2205f70 URLHostAllowedCharacterSet
        let urlStr1 = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = URL(string:urlStr1!)!
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        let downTask = URLSession.shared.downloadTask(with: request) { (location, response, err) in
            guard let responses = response as? HTTPURLResponse else
            {
                loadLrc("")
                return
            }
            print("responses.statusCode：-----\(responses.statusCode)")
            if (responses.statusCode == 200)
            {
                //正式
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
    
    /// 访问请求歌词路径的接口，出现501的频率很高
    func requestLRCURL(model:MusicLrcModel, loadLrc:@escaping (String,String)->Void)
    {
        var request = URLRequest(url: URL(string: model.lrcURL!)!)
        print(model.convertToJSON())
        let data = model.convertToJSON().data(using: .utf8)
        request.httpBodyStream = InputStream.init(data: data!)
        request.httpMethod = "GET"
        let requestLrcURL = URLSession.shared.dataTask(with: request) { (data, response, err) in
            //
            guard let responses = response as? HTTPURLResponse else
            {
                loadLrc("","访问网络失败")
                return
            }
            
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
                    //print("文件路径错误")
                    loadLrc("","lrc错误路径：\(httpURL!)")
                }
            }
            else
            {
                loadLrc("","lrc路径接口响应：\(responses.statusCode)")
            }
        }
        requestLrcURL.resume()
    }

}

///版本号验证
extension HttpClientManager
{
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
}
