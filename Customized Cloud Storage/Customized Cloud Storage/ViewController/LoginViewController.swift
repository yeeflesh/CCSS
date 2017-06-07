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
    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var registView: UIView!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
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
        
        //set subview
        passwordStackView.addSubview(registView)
        //registView.isUserInteractionEnabled = true
        
        //set regist button
        registButton.addTarget(self, action: #selector(regist), for: .touchUpInside)
        
        //set login button
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    func login(){
        print("login")
    }
    
    func regist(){
        print("regist")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

