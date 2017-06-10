//
//  ExtensionTextField.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/10.
//  Copyright © 2017年 MingE. All rights reserved.
//
import UIKit

private var kAssociationKeyNextField: UInt8 = 0

extension UITextField {
    var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
