//
//  File.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/7.
//  Copyright © 2017年 MingE. All rights reserved.
//

import Foundation

public class User: NSObject, NSCoding{
    private var _id: String? = nil
    public var id: String{
        get {return (_id ?? "")!}
    }
    private var _name: String? = nil
    public var name: String{
        set {_name = newValue}
        get {return (_name ?? "")!}
    }
    private let _email: String!
    public var email: String{
        get {return _email ?? ""}
    }
    private var _password: String! = nil
    public var password: String{
        set {_password = newValue}
        get {return _password ?? ""}
    }
    private var _clientServerList: [ClientServer] = []
    public var clientServerList: [ClientServer]{
        get {return _clientServerList}
    }
    
    public init(name: String? = nil, email: String, password:String) {
        _name = name
        _email = email
        _password = password
    }
    
    public required init?(coder aDecoder: NSCoder) {
        _id = aDecoder.decodeObject(forKey: "id") as? String
        _name = aDecoder.decodeObject(forKey: "name") as? String
        _email = aDecoder.decodeObject(forKey: "email") as? String
        _password = aDecoder.decodeObject(forKey: "password") as? String
        _clientServerList = aDecoder.decodeObject(forKey: "clientServerList") as? [ClientServer] ?? []
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "id")
        aCoder.encode(_name, forKey: "name")
        aCoder.encode(_email, forKey: "email")
        aCoder.encode(_password, forKey: "password")
        aCoder.encode(_clientServerList, forKey: "clientServerList")
    }
    
    public func login(success: @escaping (Bool) -> ()){
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
    
    public func register(success: @escaping (Bool) -> ()){
        //set url
        let baseUrl = "http://140.124.181.196:4000"
        let url = baseUrl + "/user/register"
        
        //set parameter with json
        let paramsJSONFormat: [String: Any] = ["name": _name!, "email": _email, "password": _password]
        
        httpRqeust(url: url, paramsJSONFormat: paramsJSONFormat){response in
            guard response != nil else{
                success(false)
                return
            }
            
            //print("register response: \(String(describing: response?["error"] as? Bool))")
            success(!(response?["error"] as? Bool)!)
        }
    }
    
    public func getClientServerList(success: @escaping (Bool) -> ()){
        //set url
        let baseUrl = "http://140.124.181.196:4000"
        let url = baseUrl + "/user/getClientServerList"
        
        //set parameter with json
        let paramsJSONFormat: [String: Any] = ["user_id": _id!]
        
        httpRqeust(url: url, paramsJSONFormat: paramsJSONFormat){response in
            guard response != nil else{
                success(false)
                return
            }
            
            let responseData = response?["data"] as? [String: Any]
            //print("getClientServerList response: \(String(describing: response?["data"]))")
            let clientServerListData = responseData?["clientServerList"] as? [[String: Any]]
            //print("clientServerList: \(String(describing: clientServerList))")
            
            //clear clientServerList
            if(self._clientServerList.count > 0){
                self._clientServerList.removeAll()
            }
            
            for clientServerData in clientServerListData!{
                let name = (clientServerData["name"] as? String)!
                let host = (clientServerData["host"] as? String)!
                let id = (clientServerData["_id"] as? String)!
                let token = (clientServerData["token"] as? String)!
                let clientServer = ClientServer(name: name, host: host, id: id, token: token)
 
                self._clientServerList.append(clientServer)
                //print("clentServerList.count: \(String(describing: self._clientServerList.count))\nclientServerList: \(String(describing: self._clientServerList[0].name))")
            }
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
        
        //set time out
        URLSessionConfiguration.default.timeoutIntervalForRequest = 10
        
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
