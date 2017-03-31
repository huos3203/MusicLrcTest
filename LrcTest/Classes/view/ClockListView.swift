//
//  ClockListView.swift
//  LrcTest
//
//  Created by Xcode Server on 2017/3/24.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

public class ClockListView: UIView,UIGestureRecognizerDelegate
{

    public var delayClockVC:ClockTableViewController!
    
    public class var shareInstance:ClockListView
    {
        struct Singleton{
            
            public static let instance = {
                return ClockListView()
            }()
            
        }
        Singleton.instance.setNeedsUpdateConstraints()
        return Singleton.instance
    }

    init()
    {
        super.init(frame: CGRect.zero)
        delayClockVC = ClockTableViewController.shareInstance
        let clockTable = delayClockVC.tableView
        //遮罩
        let chrome = UIView()
        chrome.backgroundColor = UIColor.black
        chrome.alpha = 0.4
        addMyConstraints(self,constraintView: chrome)
        //底部，左右对齐，高度：352
        chromeAddClockView(chrome: self,ClockView: clockTable!)
        
        //点击遮罩消失事件列表
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(ClockListView.chromeTap(_:)))
        tap.delegate = self
        chrome.addGestureRecognizer(tap)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func chromeTap(_ tap:UITapGestureRecognizer)
    {
        //
        if tap.state == .ended
        {
            //从父视图移除
            self.removeFromSuperview()
        }
    }
    
    public override func updateConstraints()
    {
        //
        print("\(#function)")
        if (superview != nil)
        {
            addMyConstraints(superview!,constraintView: self)
        }
        super.updateConstraints()
        UIView.animate(withDuration: 1.0) { 
            //
            
        }
        
        UIView.animate(withDuration: 1.0, animations: { 
            self.layoutIfNeeded()
        }) { (bo) in
            //
            print("-----")
        }
    }
    

    //
    
    func addAnimation()
    {
        UIView.transition(from: superview!, to: self, duration: 0.5, options: .transitionCurlDown) { (bool) in
            //
            //print("转场完成")
        }
    }
    
    
    //添加约束
    func addMyConstraints(_ superView:UIView,constraintView:UIView)
    {
        //H
        superView.addSubview(constraintView)
        constraintView.translatesAutoresizingMaskIntoConstraints = false
        let Hconstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["cview":constraintView])
        let Vconstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["cview":constraintView])
        superView.addConstraints(Hconstraint)
        superView.addConstraints(Vconstraint)
    }
    
    func chromeAddClockView(chrome:UIView,ClockView:UIView)
    {
        //
        chrome.addSubview(ClockView)
        ClockView.translatesAutoresizingMaskIntoConstraints = false
        let Hconstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[clock]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["clock":ClockView])
        let Vconstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0@700-[clock(==352)]-0-|", options:  NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["clock":ClockView])
        chrome.addConstraints(Hconstraint)
        chrome.addConstraints(Vconstraint)
    }
    
    public override func awakeFromNib() {
        //
        print("\(#function)===\(self)")
    }
    
    
    //:
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        let inval = self.frame.size.height - 352
        if gestureRecognizer.location(in: self).y < inval
        {
            //print("合法区域")
            return true
        }
        return false
    }
    
}
