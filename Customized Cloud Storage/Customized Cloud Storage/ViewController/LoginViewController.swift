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
        //set email TextField
        emailTextField.nextField = passwordTextField
        
        //set login Button
        loginButton.layer.cornerRadius = 5
        
        //hard code account(email, password) in login, help debug easier
//        emailTextField.text = "test@gmail.com"
//        passwordTextField.text = "test"
    }
    
    //TextField keyboard disappear when user click "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //in the password TextField, click "go" then login
        guard textField == passwordTextField else {
            textField.nextField?.becomeFirstResponder()
            return true
        }
        
        login()
        textField.resignFirstResponder()
        return true
    }
    
    //TextField keyboard disappear when user tap other side on screen
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
        guard emailTextField.isValidEmail() else {
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
        
        self.view.endEditing(true)
        errorMessageLabel.isHidden = true
        //print("login")
        let user = User(email: email, password: password)
        
        user.login(){loginStauts in
            print("UI login status: \(loginStauts)")
            //set login status in system
            UserDefaults.standard.setValue(loginStauts, forKey: "loginStatus")
            UserDefaults.standard.synchronize()
            
            guard loginStauts == true else{
                DispatchQueue.main.sync {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = "帳號或密碼錯誤"
                }
                return
            }
            
            //save user data in system
            let encodeUserData = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.setValue(encodeUserData, forKey: "userData")
            UserDefaults.standard.synchronize()
            
            //dismiss login page
            DispatchQueue.main.sync {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction internal func pushRegisterView(){
        //print("register")
        self.view.endEditing(true)
        //let registerView = self.storyboard?.instantiateViewController(withIdentifier: "registerView")
        //self.navigationController?.pushViewController(registerView!, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

