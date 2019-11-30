//
//  APIRequest.swift
//  Resources
//
//  Created by Hsin-Min Liao on 2019/11/27.
//  Copyright © 2019 Griffon. All rights reserved.
//

import Foundation

public protocol GetAPIRequest: Encodable {
    
    associatedtype Response: Decodable
    var resourceName: String { get set }
    
}

public protocol PostAPIRequest: Encodable {
    
    associatedtype Response: Decodable
    associatedtype Body: Encodable
    var resourceName: String { get set }

}
