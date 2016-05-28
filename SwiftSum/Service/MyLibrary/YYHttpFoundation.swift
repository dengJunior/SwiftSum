//
//  YYHttpFoundation.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/27.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public enum YYHttpMethod: String {
    case DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT
}

public struct YYHttpFile {
    public let name: String!
    public let url: NSURL!
    public init(name: String, url: NSURL) {
        self.name = name
        self.url = url
    }
}
