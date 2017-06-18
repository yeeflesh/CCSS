//
//  ExtensionNsMutableData.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/18.
//  Copyright © 2017年 MingE. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
