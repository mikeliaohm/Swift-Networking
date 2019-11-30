//
//  File.swift
//  
//
//  Created by Mike Liao on 2019/11/30.
//

import Foundation

protocol GetAPIClientProtocol {
    func post<T: GetAPIRequest>(
        apiRequest: T,
        completion: @escaping ResultCallback<APIResponse<T.Response>>
    )
}
