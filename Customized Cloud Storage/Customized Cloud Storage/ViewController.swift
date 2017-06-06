//
//  ViewController.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/6.
//  Copyright © 2017年 MingE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set login button
        loginButton.layer.cornerRadius = 5        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

