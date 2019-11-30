//
//  NetworkError.swift
//  Resources
//
//  Created by Hsin-Min Liao on 2019/11/25.
//  Copyright © 2019 Griffon. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case noData
    case cannotReachServer
    case responseError(code: Int, message: String)
    case decodingError
    case urlError
}
