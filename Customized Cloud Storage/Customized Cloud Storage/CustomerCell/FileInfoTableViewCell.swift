//
//  FileInfoTableViewCell.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/17.
//  Copyright © 2017年 MingE. All rights reserved.
//

import UIKit

class FileInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var pathLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
