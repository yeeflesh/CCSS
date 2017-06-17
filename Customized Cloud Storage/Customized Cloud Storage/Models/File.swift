//
//  File.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/17.
//  Copyright © 2017年 MingE. All rights reserved.
//

import Foundation

public class File: NSObject, NSCoding{
    private var _name: String
    public var name: String{
        set {_name = newValue}
        get {return _name}
    }
    private var _path: String
    public var path: String{
        set {_path = newValue}
        get {return _path}
    }
    private var _size: Int
    public var size: Int{
        set {_size = newValue}
        get {return _size}
    }
    
    public init(name: String, path: String, size: Int) {
        _name = name
        _path = path
        _size = size
    }
    
    public required init?(coder aDecoder: NSCoder) {
        _name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        _path = aDecoder.decodeObject(forKey: "path") as? String ?? ""
        _size = aDecoder.decodeObject(forKey: "size") as? Int ?? 0
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: "name")
        aCoder.encode(_path, forKey: "path")
        aCoder.encode(_size, forKey: "size")
    }
}
