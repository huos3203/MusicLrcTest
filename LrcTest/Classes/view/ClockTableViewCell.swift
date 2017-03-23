//
//  ClockTableViewCell.swift
//  LrcTest
//
//  Created by pengyucheng on 21/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

import UIKit

class ClockTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViews: UIImageView!
    
    @IBOutlet weak var textLabels: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if tag < 8
        {
            print("------")
            return
        }
        
        if selected
        {
            imageViews.isHidden = false
            UserDefaults.standard.set(true, forKey: "\(tag)")
            UserDefaults.standard.synchronize()
        }
        else
        {
            imageViews.isHidden = true
            UserDefaults.standard.set(false, forKey: "\(tag)")
            UserDefaults.standard.synchronize()
        }
    }
}
