//
//  ClientServer.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/16.
//  Copyright © 2017年 MingE. All rights reserved.
//

import Foundation
import UIKit

public class ClientServer: NSObject, NSCoding{
    private var _id: String? = nil
    public var id: String{
        get {return (_id ?? "")!}
    }
    private var _name: String? = nil
    public var name: String{
        set {_name = newValue}
        get {return (_name ?? "")!}
    }
    private let _host: String!
    public var host: String{
        get {return _host ?? ""}
    }
    private var _token: String? = nil
    public var token: String{
        set {_token = newValue}
        get {return (_token ?? "")!}
    }
    private var _fileList: [File] = []
    public var fileList: [File]{
        get {return _fileList}
    }
    public init(name: String, host: String, id: String? = nil, token: String? = nil) {
        _name = name
        _host = host
        _id = id
        _token = token
    }
    
    public required init?(coder aDecoder: NSCoder) {
        _id = aDecoder.decodeObject(forKey: "id") as? String
        _name = aDecoder.decodeObject(forKey: "name") as? String
        _host = aDecoder.decodeObject(forKey: "host") as? String
        _token = aDecoder.decodeObject(forKey: "token") as? String
        _fileList = aDecoder.decodeObject(forKey: "fileList") as? [File] ?? []
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "id")
        aCoder.encode(_name, forKey: "name")
        aCoder.encode(_host, forKey: "host")
        aCoder.encode(_token, forKey: "token")
        aCoder.encode(_fileList, forKey: "fileList")
    }
    
    public func getFiles(success: @escaping (Bool) -> ()){
        //set url
        let baseUrl = "http://" + _host + ":3000"
        let url = baseUrl + "/file/getFiles"
        
        //set parameter with json
        let paramsJSONFormat: [String: Any] = ["target_path": "./public", "token": _token ?? ""]
        
        httpRqeust(url: url, paramsJSONFormat: paramsJSONFormat){response in
            guard response != nil else{
                success(false)
                return
            }
            
            //print("getClientServerList response: \(String(describing: response?["data"]))")
            let fileListData = response?["data"] as? [[String: Any]]
            //print("clientServerList: \(String(describing: clientServerList))")
            
            //clear clientServerList
            if(self._fileList.count > 0){
                self._fileList.removeAll()
            }
            
            for fileData in fileListData!{
                let name = (fileData["_name"] as? String)!
                let path = (fileData["_path"] as? String)!
                let size = (fileData["_size"] as? Int)!
                guard size > 0 else{continue}
                let file = File(name: name, path: path, size: size)
                
                self._fileList.append(file)
                //print("clentServerList.count: \(String(describing: self._clientServerList.count))\nclientServerList: \(String(describing: self._clientServerList[0].name))")
            }
            success(true)
        }

    }
    
    public func uploadFile(image: UIImage, filename: String, success: @escaping (Bool) -> ()){
        //set url
        let baseUrl = "http://" + _host + ":3000"
        let url = baseUrl + "/file/uploadFiles"
        
        //set parameter with json
        let params: [String: Any] = ["token": _token ?? "", "optimize": true]
        
        httpUploadImage(url: url, params: params, image: image, filename: filename){response in
            guard response != nil else{
                success(false)
                return
            }
            
            //print("getClientServerList response: \(String(describing: response?["data"]))")
            let message = response?["message"] as? String
            //print("clientServerList: \(String(describing: clientServerList))")
            
            success(message == "Upload File Success!")
        }

    }
    
    private func createBody(parameters: [String: Any], boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"files\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    private func httpUploadImage(url: String, params: [String: Any], image:UIImage, filename: String, completion: @escaping ([String: Any]?) -> ()){
        let url = URL(string: url)!
        //set http request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: params, boundary: boundary, data: UIImageJPEGRepresentation(image, 1.0)!, mimeType: "image/jpg", filename: filename)
        
        //set time out
        URLSessionConfiguration.default.timeoutIntervalForRequest = 10
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("upload error = \(String(describing: error))")
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
