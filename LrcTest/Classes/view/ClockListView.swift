//
//  ClockListView.swift
//  LrcTest
//
//  Created by Xcode Server on 2017/3/24.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

public class ClockListView: UITableView,UITableViewDelegate{

    public var delayClockDelegate:DelayClockDelegate!
    private var delayTime:Int = 0
    
    var min = 0
    var seconds = 0
    
    var timer:Timer!
    
    public class var shareInstance:ClockListView
    {
        struct Singleton{
            
            public static let instance = { () -> UITableView in
                let bundle = Bundle.init(for: ClockListView.self)
                let board:UIStoryboard = UIStoryboard.init(name: "Main", bundle: bundle)
                let VC = board.instantiateViewController(withIdentifier: "ClockTableViewController") as! ClockTableViewController
                return VC.clockListView
            }()
            
        }
        return Singleton.instance as! ClockListView
    }
    
   
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        startClock()
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
    
    //定时事件：开启定时器
    public func startClock(delayTime:NSInteger = 0)
    {
        self.delayTime = delayTime
        if delayTime <= 0 {
            return;
        }
        cancelClock()
        
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
