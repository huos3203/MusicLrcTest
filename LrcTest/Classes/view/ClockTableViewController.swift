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

    public var delayClockDelegate:DelayClockDelegate!
    private var delayTime:Int = 0
    
    var min = 0
    var seconds = 0
    
    var timer:Timer!
    
    public class var shareInstance:ClockTableViewController
    {
        struct Singleton{
            
        public static let instance = { () -> ClockTableViewController in
            let bundle = Bundle.init(for: ClockTableViewController.self)
                let board:UIStoryboard = UIStoryboard.init(name: "Main", bundle: bundle)
                return board.instantiateViewController(withIdentifier: "ClockTableViewController") as! ClockTableViewController
            }()
            
        }
        return Singleton.instance
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        switch indexPath.row
        {
        case 0:
            print("标题：定时关闭，误操作")
        case 1:
            print("不开启，重置设置")
            delayTime = 0
            cancelClock()
        case 2:
            
            delayTime = self.delayClockDelegate.currentMusicTime()
            print("当前音乐\(delayTime) 秒")
        default:
            let cell = tableView.cellForRow(at: indexPath)
            delayTime = {
                return (cell?.tag)!*60
            }()
        }
        
        //开始倒计时
        if delayTime > 0
        {
            cancelClock()
            startClock()
        }
    }
    
    
    //倒计时结束时，关闭播放器
    func closeClock()
    {
        
        if timer != nil
        {
            timer.invalidate()
        }
        print("执行关闭音乐")
        self.delayClockDelegate?.setDelayToPerformCloseOperation()
    }
    
    //定时事件：开启定时器，到时间关闭播放器
    func startClock()
    {
        self.perform(#selector(ClockTableViewController.closeClock), with:nil, afterDelay: TimeInterval(self.delayTime))
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ClockTableViewController.refresh), userInfo: nil, repeats: true)
        // 将定时器添加到运行循环
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    //取消定延迟调用
    public func cancelClock()
    {
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
        self.delayClockDelegate?.cancelPerformCloseOperation()
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
//        print("=============\(time)")
        
//        if self.delayClockDelegate.responds {
//            <#code#>
//        }
//        self.responds(to: <#T##Selector!#>)
 
        self.delayClockDelegate.CountingDownRefreshSencond(time: time)
    }
}
