//
//  ClockTableViewController.swift
//  LrcTest
//
//  Created by pengyucheng on 21/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

import UIKit
//委托延迟设置，取消延迟
@objc(DelayClockDelegate)
public protocol DelayClockDelegate
{
    //设置delay
    func setDelayToPerformCloseOperation()
    //开始倒计时
    func startCountingDownUntilExecution()
    //取消
    func cancelPerformCloseOperation()
    
    //刷新View倒计时
    func CountingDownRefreshSencond(time:String)
    
    func currentMusicTime() -> Int
}
//@objc(ClockTableViewController)
public class ClockTableViewController: UITableViewController {

    public weak var delayClockDelegate:DelayClockDelegate!
    private var delayTime:Int = 0
    private var isDragMusic = false
    
    var min = 0
    var seconds = 0
    
    var timer:Timer!
    
    public class var shareInstance:ClockTableViewController
    {
        struct Singleton{
            
            static let instance = { () -> ClockTableViewController in
                let bundle = Bundle.init(for: ClockTableViewController.self)
                let board:UIStoryboard = UIStoryboard.init(name: "Main", bundle: bundle)
                let VC = board.instantiateViewController(withIdentifier: "ClockTableViewController") as! ClockTableViewController
                //设置默认选项不开启
                UserDefaults.standard.setValue(1, forKey: "isSelected")
                UserDefaults.standard.synchronize()
                VC.loadView()
                return VC
            }()
            
        }
        return Singleton.instance
    }

    public override func awakeFromNib() {
        //
        print("\(#function)")
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        //在此处无法实现透明效果，原因不明.最终在storyboard上设置解决
        //tableView.backgroundColor = UIColor.clear
        
        //tableView.backgroundColor = UIColor(white:255/255,alpha:0.9)//Color.colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha
        //tableView.backgroundColor = UIColor.clear//.white.withAlphaComponent(0.9)
        //tableView.alpha = 0.9
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        //tag定位到cell
        let index = UserDefaults.standard.integer(forKey: "isSelected")
        self.tableView.selectRow(at: IndexPath.init(row: index, section: 0) , animated: true, scrollPosition: .middle)
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
        if cell.isKind(of: ClockTableViewCell.self) && indexPath.row > 0
        {
            let celle = cell as! ClockTableViewCell
            let index = UserDefaults.standard.integer(forKey: "isSelected")
            if index == indexPath.row {
                celle.imageViews.isHidden = false
            }
        }
    }
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isDragMusic = false
        
        //
        switch indexPath.row
        {
        case 0:
            print("标题：定时关闭，误操作")
        case 1:
            //print("不开启，重置设置")
            delayTime = 0
            cancelClock()
        case 2:
            
            delayTime = self.delayClockDelegate.currentMusicTime()
            isDragMusic = true
            //print("当前音乐\(delayTime) 秒")
        default:
            let cell = tableView.cellForRow(at: indexPath)
            delayTime = {
                return (cell?.tag)!*60
            }()
        }
        
        UserDefaults.standard.setValue(indexPath.row, forKey: "isSelected")
        UserDefaults.standard.synchronize()
        ClockListView.shareInstance.chromeTap(UITapGestureRecognizer()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 )
        //开始倒计时
        startClock(delayTime: delayTime)
    }
    
    
    //倒计时结束时，关闭播放器
    func closeClock()
    {
        
        if timer != nil
        {
            timer.invalidate()
        }
        UserDefaults.standard.removeObject(forKey: "isSelected")
        //print("执行关闭音乐")
        self.delayClockDelegate?.setDelayToPerformCloseOperation()
    }
    
    public func dragMusicClock(delayTime:NSInteger = 0)
    {
        if(isDragMusic)
        {
            startClock(delayTime:delayTime)
        }
    }
    
    //定时事件：开启定时器
    func startClock(delayTime:NSInteger = 0)
    {
        cancelClock(reset: true)
        self.delayTime = delayTime
        if delayTime <= 0 {
            return;
        }
        
        self.perform(#selector(ClockTableViewController.closeClock), with:nil, afterDelay: TimeInterval(self.delayTime))
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ClockTableViewController.refresh), userInfo: nil, repeats: true)
        // 将定时器添加到运行循环
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    //取消定延迟调用
    public func cancelClock(reset:Bool = false)
    {
        if !reset
        {
            UserDefaults.standard.setValue(1, forKey: "isSelected")
            UserDefaults.standard.synchronize()
        }
        
        if timer != nil {
            timer.invalidate()
        }
        
        cancelByClock()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
//        NSObject.cancelPreviousPerformRequests(withTarget: self,
//                                               selector: #selector(SleepClockView.createClock),
//                                               object: nil)
    }
    
    //代理协议：宿主程序中代理关闭播放器事件
    func cancelByClock()
    {
        if(self.delayClockDelegate != nil)
        {
            self.delayClockDelegate?.cancelPerformCloseOperation()
        }
        
    }
    
    
    func refresh()
    {
        delayTime -= 1
        //分钟转为秒
        min = delayTime/60
        seconds = Int(delayTime%60)
        var time = ""
        
        if min > 0 {
            //
            time = "\(min):\(seconds)"
        }
        else
        {
            time = "\(seconds)"
        }
       //print("=============\(time)")
        
//        if self.delayClockDelegate.responds {
//            <#code#>
//        }
//        self.responds(to: <#T##Selector!#>)
//        if self.delayClockDelegate.responds(to:"CountingDownRefreshSencond")
//        {
//        
//        }
        if (self.delayClockDelegate != nil)
        {
            self.delayClockDelegate.CountingDownRefreshSencond(time: time)
        }
        
    }
}
