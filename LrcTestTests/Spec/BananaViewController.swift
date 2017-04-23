//
//  BananaViewController.swift
//  MusicLrcUtil
//
//  Created by huoshuguang on 2017/4/23.
//  Copyright © 2017年 PBBReader. All rights reserved.
//

import UIKit

class BananaViewController: UIViewController {

    var bananaCountLabel:UILabel!
    var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labelFrame = CGRect.init(x: 100, y: 100, width: 100, height: 40)
        bananaCountLabel = UILabel.init(frame: labelFrame)
        bananaCountLabel.text = "0"
        bananaCountLabel.backgroundColor = UIColor.orange
        view.addSubview(bananaCountLabel)
        
        button = UIButton(type: .custom)
        view.addSubview(button)
        
        button.frame           = CGRect(x: 100, y: 200, width: 100, height: 40)
        button.backgroundColor = UIColor.black
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(BananaViewController.buttonAction), for: .touchUpInside)
    }

    func buttonAction() {
        
        let bananaCount = Int(bananaCountLabel.text!)
        bananaCountLabel.text = String(bananaCount! + 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
