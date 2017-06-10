//
//  File.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/7.
//  Copyright © 2017年 MingE. All rights reserved.
//

import Foundation

public class User{
    private var _id: String? = nil
    var id: String{
        get {return (_id ?? "")!}
    }
    private let _email: String!
    var email: String{
        get {return _email ?? ""}
    }
    private var _password: String! = nil
    var password: String{
        set {_password = newValue}
        get {return _password ?? ""}
    }
    private var _name: String? = nil
    var name: String{
        set {_name = newValue}
        get {return (_name ?? "")!}
    }
    
    init(email: String, password:String) {
        _email = email
        _password = password
    }
    
    func login(success: @escaping (Bool) -> ()){
        //set url
        let baseUrl = "http://140.124.181.196:4000"
        let url = baseUrl + "/user/login"
        
        //set parameter with json
        let paramsJSONFormat: [String: Any] = ["email": _email, "password": _password]
        
        httpRqeust(url: url, paramsJSONFormat: paramsJSONFormat){response in
            guard response != nil else{
                success(false)
                return
            }
            //print("response: \(reponse)")
            let userInfo = response?["data"] as? [String: Any]
            //print("user information: \(String(describing: userInfo))")
            self._id = (userInfo?["_id"] as? String)
            self._name = (userInfo?["name"] as? String)
            //print("_id: \(userInfo?["_id"] as? String ?? "")")
            //print("name: \(userInfo?["name"] as? String ?? "")")
            
            //print("login response: \(String(describing: response?["error"] as? Bool))")
            success(!(response?["error"] as? Bool)!)
        }
    }
    
    private func httpRqeust(url: String, paramsJSONFormat: [String: Any], completion: @escaping ([String: Any]?) -> ()){
        let url = URL(string: url)!
        let paramsJSON = try? JSONSerialization.data(withJSONObject: paramsJSONFormat, options: .prettyPrinted)
        
        //set http request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramsJSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("login error = \(String(describing: error))")
                completion(nil)
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else{
                print("response = \(String(describing: response))")
                completion(nil)
                return
            }
            
            let dataJSON = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            //print("http response: \(String(describing: dataJSON))")
            completion(dataJSON!)
        }
        task.resume()
    }

}
