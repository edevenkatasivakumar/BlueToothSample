//
//  DeviceTableViewCell.swift
//  BlueToothSample
//
//  Created by Sivakumar on 01/03/19.
//  Copyright © 2019 Sivakumar. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblNameVal: UILabel!
    @IBOutlet weak var lblRssiVal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
