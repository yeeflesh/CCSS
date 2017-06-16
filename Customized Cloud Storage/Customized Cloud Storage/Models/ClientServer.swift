//
//  ClientServer.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/16.
//  Copyright © 2017年 MingE. All rights reserved.
//

import Foundation

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
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "id")
        aCoder.encode(_name, forKey: "name")
        aCoder.encode(_host, forKey: "host")
        aCoder.encode(_token, forKey: "token")
    }
    
    
}
