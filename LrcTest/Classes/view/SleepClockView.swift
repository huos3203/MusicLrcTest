//
//  SleepClockView.swift
//  LrcTest
//
//  Created by pengyucheng on 20/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//
//chttp://www.cnblogs.com/QianChia/p/5777473.html
import UIKit
//委托延迟设置，取消延迟
@objc
protocol DelayDelegate
{
    //设置delay
    func setDelayToPerformCloseOperation()
    //开始
    func startCountingDownUntilExecution()
    //取消
    func cancelPerformCloseOperation()
}



class SleepClockView: UIAlertController {

    class var shareInstance:SleepClockView
    {
        struct Singleton{
            static let instance = SleepClockView()
        }
        return Singleton.instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //根据给定数组，定制View
    private var delayDelegate:DelayDelegate?
    private var delayTime:TimeInterval = 0.0
    @objc(setupBy:toTarget:)
    func setup(clockArr:[Int] = [1,2,3,4] ,toTarget Delgate:DelayDelegate)
    {
        self.delayDelegate = Delgate
        //
        let cancelAction = UIAlertAction.init(title: "暂时不取消设置", style: .default) { (acion) in
                self.delayTime = 0.0
                self.cancelClock()
        }
        self.addAction(cancelAction)
        let clock = clockArr.sorted(by: >)
        for(index,clock) in clock.enumerated()
        {
            let action = UIAlertAction.init(title: "\(clock) 分钟)",
                style: .default, handler: { (action) in
                    //事件
                    self.delayTime = TimeInterval(clockArr[index])
            })
            self.addAction(action)
        }
    }
    
    //创建定时器
    func createClock()
    {
        
        self.delayDelegate?.setDelayToPerformCloseOperation()
    }
    
    //定时事件：开启定时器，到时间关闭播放器
    func startClock()
    {
        self.perform(#selector(SleepClockView.createClock), with:nil, afterDelay: self.delayTime)
    }
    
    //取消定延迟调用
    func cancelClock()
    {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(SleepClockView.cancelByClock),
                                               object: nil)
    }
   
    //代理协议：宿主程序中代理关闭播放器事件
    func cancelByClock()
    {
        self.delayDelegate?.cancelPerformCloseOperation()
    }

}
