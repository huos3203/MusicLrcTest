//
//  LayerTableView.swift
//  LrcTest
//
//  Created by huoshuguang on 2017/3/26.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

class LayerTableView: UIViewController {
    var sview:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //添加加载tableView 按钮，及View
        sview = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 300, height: 500))
        sview.addSubview(ClockListView.shareInstance)
        view.addSubview(sview)   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
