//
//  IsCompressionSwitchTableViewCell.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/16.
//  Copyright © 2017年 MingE. All rights reserved.
//

import UIKit

class IsCompressionSwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var isCompressionSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction internal func isCompression(){
        print("UI side menu -> isCompression Switch: \(isCompressionSwitch.isOn)")
        UserDefaults.standard.setValue(isCompressionSwitch.isOn, forKey: "isCompression")
        UserDefaults.standard.synchronize()
    }
}
