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
    var chrome:UIView!
    public class var shareInstance:ClockListView
    {
        struct Singleton{
            
            public static let instance = {
                return ClockListView()
            }()
            
        }
        return Singleton.instance
    }

    init()
    {
        super.init(frame: CGRect.zero)
        delayClockVC = ClockTableViewController.shareInstance
        let clockTable = delayClockVC.tableView
        clockTable?.alpha = 0
        //遮罩
        chrome = UIView()
        chrome.backgroundColor = UIColor.black
        chrome.alpha = 0
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
    
    var selfHeight:NSLayoutConstraint!
    public func addIntoView(_ inView:UIView)
    {
        inView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let hVF = "H:|-0-[cview(==superview)]-0-|"
        let Hconstraint = NSLayoutConstraint.constraints(withVisualFormat: hVF,
                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: nil,
                                                         views: ["cview":self,"superview":inView])
        
        //纵向高度等于父视图
        let vVF = "V:[cview(==selfHeight)]-0-|"
        let Vconstraint = NSLayoutConstraint.constraints(withVisualFormat: vVF,
                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: ["selfHeight":UIScreen.main.bounds.height],
                                                         views: ["cview":self,"superview":inView])
        let constraint = Vconstraint[0]
        if constraint.firstItem.isKind(of: ClockListView.self)
        {
            selfHeight = constraint
        }
        inView.addConstraints(Hconstraint)
        inView.addConstraints(Vconstraint)
        //setNeedsUpdateConstraints()
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.chrome.alpha = 0.7
            self.selfHeight.constant = UIScreen.main.bounds.height  //rootView高度
            self.layoutIfNeeded()
        }) { (bo) in
            //
            UIView.animate(withDuration: 0.3, animations: {
                self.tableHeight.constant = 352    //tableView 高度
                ClockTableViewController.shareInstance.tableView.alpha = 1
                self.layoutIfNeeded()
            }, completion: { (boo) in
                 print("tableView动画-----")
            })
            
        }
    }
    
    func chromeTap(_ tap:UITapGestureRecognizer)
    {
        if tap.state == .ended
        {
            //从父视图移除
            //self.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                self.chrome.alpha = 0
                self.tableHeight.constant = 0
                ClockTableViewController.shareInstance.tableView.alpha = 0
                self.setNeedsUpdateConstraints()
                
            }, completion: { (bo) in
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.selfHeight.constant = 0
                    self.setNeedsUpdateConstraints()
                }, completion: { (bo) in
                    //
                    print("定时器消失")
                    self.removeFromSuperview()
                })
            })
        }
    }
    
    public override func updateConstraints()
    {
        //
        print("\(#function)")
        super.updateConstraints()
    }

    func addAnimation()
    {
        UIView.transition(from: superview!, to: self, duration: 0.5, options: .transitionFlipFromBottom) { (bool) in
            //
            //print("转场完成")
        }
    }
    
    
    //添加遮罩约束
    func addMyConstraints(_ superView:UIView,constraintView:UIView)
    {
        //H
        superView.addSubview(constraintView)
        constraintView.translatesAutoresizingMaskIntoConstraints = false
        
        let hVF = "H:|-0-[cview(==superview)]-0-|"
        let Hconstraint = NSLayoutConstraint.constraints(withVisualFormat: hVF,
                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: nil,
                                                         views: ["cview":constraintView,"superview":superView])
        
        //纵向高度等于父视图
        let vVF = "V:|-0-[cview]-0-|"
        let Vconstraint = NSLayoutConstraint.constraints(withVisualFormat: vVF,
                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: nil,
                                                         views: ["cview":constraintView,"superview":superView])
        superView.addConstraints(Hconstraint)
        superView.addConstraints(Vconstraint)
    }
    
    //tableView约束
    var tableHeight:NSLayoutConstraint!
    func chromeAddClockView(chrome:UIView,ClockView:UIView)
    {
        //
        chrome.addSubview(ClockView)
        ClockView.translatesAutoresizingMaskIntoConstraints = false
        let Hconstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[clock]-0-|",
                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: nil,
                                                         views: ["clock":ClockView])
        
        let Vconstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0@700-[clock(==0)]-0-|",
                                                         options:  NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: nil,
                                                         views: ["clock":ClockView])
        let constraint = Vconstraint[1]
        if(constraint.firstItem.isKind(of: UITableView.self))
        {
            tableHeight = constraint
        }
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
            return true
        }
        return false
    }
    
}
