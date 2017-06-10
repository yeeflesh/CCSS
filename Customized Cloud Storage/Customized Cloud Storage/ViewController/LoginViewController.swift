//
//  ViewController.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/6.
//  Copyright © 2017年 MingE. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set email text field
        emailTextField.nextField = passwordTextField
        
        //set login button
        loginButton.layer.cornerRadius = 5
        
        //hard code account(email, password) in login
        emailTextField.text = "test@gmail.com"
        passwordTextField.text = "test"
    }
    
    //textfield keyboard disappear when user click "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.nextField?.becomeFirstResponder()
        
        //in the password textfield, click "go" then login
        if textField == passwordTextField {
            login()
            textField.resignFirstResponder()
        }
        return true
    }
    
    //textfield keyboard disappear when user tap other side on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction internal func login(){
        //check email not empty
        guard let email = emailTextField.text, !email.isEmpty else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "請輸入帳號"
            return
        }
        
        //check email format legal
        guard isValidEmail(testEmail: email) else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "Email格式不正確 \n參照:example@organization.com"
            return
        }
        
        //check password not empty
        guard let password = passwordTextField.text, !password.isEmpty else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "請輸入密碼"
            return
        }
        
        errorMessageLabel.isHidden = true
        //print("login")
        let user = User(email: email, password: password)
        
        user.login(){loginStauts in
            print("UI login status: \(loginStauts)")
            guard loginStauts == true else{
                DispatchQueue.main.sync {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = "帳號或密碼錯誤"
                }
                return
            }
            
            
        }
        
    }
    
    @IBAction internal func register(){
        //print("register")
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

