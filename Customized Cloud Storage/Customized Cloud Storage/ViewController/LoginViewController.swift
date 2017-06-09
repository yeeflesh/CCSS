//
//  ViewController.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/6.
//  Copyright © 2017年 MingE. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var inputErrorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set email text field
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        
        //set password text field
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.keyboardType = .emailAddress
        passwordTextField.returnKeyType = .go
        
        //set input error message
        inputErrorMessageLabel.isHidden = true
        
        //set regist button
        registButton.addTarget(self, action: #selector(regist), for: .touchUpInside)
        
        //set login button
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        //hard code account(email, password) in login
        emailTextField.text = "test@gmail.com"
        passwordTextField.text = "test"
    }
    
    internal func login(){
        //check email not empty
        guard let email = emailTextField.text, !email.isEmpty else {
            inputErrorMessageLabel.isHidden = false
            inputErrorMessageLabel.text = "請輸入帳號"
            return
        }
        
        //check email format legal
        guard isValidEmail(testEmail: email) else {
            inputErrorMessageLabel.isHidden = false
            inputErrorMessageLabel.text = "Email格式不正確 \n參照:example@organization.com"
            return
        }
        
        //check password not empty
        guard let password = passwordTextField.text, !password.isEmpty else {
            inputErrorMessageLabel.isHidden = false
            inputErrorMessageLabel.text = "請輸入密碼"
            return
        }
        
        inputErrorMessageLabel.isHidden = true
        //print("login")
        let user = User(email: email, password: password)
        
        user.login(){loginStauts in
            print("UI login status: \(loginStauts)")
        }
        
    }
    
    internal func regist(){
        //print("regist")
    }
    
    private func isValidEmail(testEmail: String) -> Bool {
        let emailRegularExpresion = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailChecker = NSPredicate(format:"SELF MATCHES %@", emailRegularExpresion)
        return emailChecker.evaluate(with: testEmail)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

