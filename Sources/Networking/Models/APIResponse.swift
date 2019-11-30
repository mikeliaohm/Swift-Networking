//
//  APIResponse.swift
//  Resources
//
//  Created by Hsin-Min Liao on 2019/11/27.
//  Copyright © 2019 Griffon. All rights reserved.
//

import Foundation

struct APIResponse<Response: Decodable>: Decodable {
    let results: Response?
}
