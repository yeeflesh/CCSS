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
    
    func isValidEmail() -> Bool {
        let emailRegularExpresion = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailChecker = NSPredicate(format:"SELF MATCHES %@", emailRegularExpresion)
        return emailChecker.evaluate(with: self.text)
    }
}
