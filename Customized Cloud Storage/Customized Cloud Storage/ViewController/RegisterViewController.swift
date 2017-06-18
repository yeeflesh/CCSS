//
//  RegisterViewController.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/10.
//  Copyright © 2017年 MingE. All rights reserved.
//

import UIKit
import Toast_Swift

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set name TextField
        nameTextField.nextField = emailTextField
        
        //set email TextField
        emailTextField.nextField = passwordTextField
        
        //set password TextField
        passwordTextField.nextField = passwordConfirmTextField
        
        //set register Button
        registerButton.layer.cornerRadius = 5
        
        //hard code account(email, password) in login, help debug easier
//        nameTextField.text = "registerTest"
//        emailTextField.text = "registerTest@gmail.com"
//        passwordTextField.text = "test"
//        passwordConfirmTextField.text = "test"
    }
    
    //TextField keyboard disappear when user click "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //in the password TextField, click "go" then login
        guard textField == passwordConfirmTextField else {
            textField.nextField?.becomeFirstResponder()
            return true
        }
        
        register()
        textField.resignFirstResponder()
        return true
    }
    
    //TextField keyboard disappear when user tap other side on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction internal func register(){
        //check name not empty
        guard let name = nameTextField.text, !name.isEmpty else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "請輸入名字"
            return
        }
        
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
        
        //confirm password
        guard let passwordConfirm = passwordConfirmTextField.text, (!passwordConfirm.isEmpty && password == passwordConfirm) else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "請確認密碼"
            return
        }
        
        self.view.endEditing(true)
        errorMessageLabel.isHidden = true
        let user = User(name: name, email: email, password: password)
        
        user.register(){registerStatus in
            print("UI registerStatus status: \(registerStatus)")
            guard registerStatus == true else{
                DispatchQueue.main.sync {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = "用戶已存在"
                }
                return
            }
            DispatchQueue.main.sync {
                self.view.makeToast("註冊成功", duration: 3, position: .center, title: " ", image: UIImage(named: "Checkmark"), style: nil) {(didTap: Bool) -> () in
                    if didTap{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
