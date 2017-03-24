//
//  ClockViewController.swift
//  LrcTest
//
//  Created by Xcode Server on 2017/3/24.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController,UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        //persentation按钮
        let ff = UIButton.init(frame: CGRect.init(origin: CGPoint.init(x: 100, y: 200), size: CGSize.init(width: 50, height: 25)))
        
        ff.setTitle("hello 动画 ", for: .normal)
        ff.setTitleColor(UIColor.red, for: .normal)
        ff.addTarget(self, action: #selector(ClockViewController.pushAnimar), for: .touchDown)
        self.view.addSubview(ff)
        
    }
    
    func pushAnimar() {
        //
         let animater = ClockTableViewController.shareInstance
        let delegate = ClockTransitioningDelegate()
        self.transitioningDelegate = delegate
        animater.transitioningDelegate = delegate
        animater.modalPresentationStyle = .custom
        self.present(animater, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let nav = UINavigationController.init(rootViewController: controller.presentedViewController)
        let barDone = UIBarButtonItem.init(title: "Donw", style: .done, target: self, action: #selector(ClockViewController.dismiss as (ClockViewController) -> () -> ()))
        nav.topViewController?.navigationItem.rightBarButtonItem = barDone
        return nav
    }

    func dismiss() {
        //
        dismiss(animated: true, completion: nil)
    }
}
