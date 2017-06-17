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
    private var _resolution: String
    public var resolution: String{
        set {_resolution = newValue}
        get {return _resolution}
    }
    private var _path: String
    public var path: String{
        set {_path = newValue}
        get {return _path}
    }
    private var _size: String
    public var size: String{
        set {_size = newValue}
        get {return _size}
    }
    
    public init(name: String, resolution: String, path: String, size: String) {
        _name = name
        _resolution = resolution
        _path = path
        _size = size
    }
    
    public required init?(coder aDecoder: NSCoder) {
        _name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        _resolution = aDecoder.decodeObject(forKey: "resolution") as? String ?? ""
        _path = aDecoder.decodeObject(forKey: "path") as? String ?? ""
        _size = aDecoder.decodeObject(forKey: "size") as? String ?? ""
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: "name")
        aCoder.encode(_resolution, forKey: "resolution")
        aCoder.encode(_path, forKey: "path")
        aCoder.encode(_size, forKey: "size")
    }
}
