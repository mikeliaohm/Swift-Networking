//
//  APIClient.swift
//  Resources
//
//  Created by Hsin-Min Liao on 2019/11/25.
//  Copyright © 2019 Griffon. All rights reserved.
//

import Foundation

typealias ResultCallback<Value> = (Result<Value, NetworkError>) -> Void

protocol APIClientProtocol {
    func post<T: APIRequest>(
        apiRequest: T,
        body: T.Body,
        completion: @escaping ResultCallback<APIResponse<T.Response>>
    )
}

final class APIClient: APIClientProtocol {
    
    let domain: String
    private let baseURL: URL
    private let session = URLSession(configuration: .default)
    
    init(domain: String) {
        self.domain = domain
        self.baseURL = URL(string: domain)!
    }
    
}

extension APIClient {
    
    public func get<T: APIRequest>(apiRequest: T, completion: @escaping ResultCallback<T.Response>) {
        
        guard let fullURL = URL(string: apiRequest.resourceName, relativeTo: baseURL) else {
            completion(.failure(.urlError))
            return
        }
        
        let urlRequest = URLRequest(url: fullURL)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.cannotReachServer))
                return
            }
            
            if !(200...299).contains(response.statusCode) {

                if let data = data {
                    do {
                        let message = try JSONSerialization.jsonObject(with: data, options: [])
                        print(message)
                    } catch {
                        print("[APIClient]: cannot decode error message.")
                    }
                }
                
                completion(.failure(.responseError(code: response.statusCode, message: "server returns error code")))
                
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(T.Response.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}

// MARK: implement post method
extension APIClient {
    
    public func post<T: APIRequest>(apiRequest: T, body: T.Body, completion: @escaping ResultCallback<T.Response>) {
        
        guard let fullURL = URL(string: apiRequest.resourceName, relativeTo: baseURL) else {
            completion(.failure(.urlError))
            return
        }
        
        var urlRequest = URLRequest(url: fullURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonBody = try? JSONEncoder().encode(body) {
            urlRequest.httpBody = jsonBody
        }
        
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.cannotReachServer))
                return
            }
            
            if !(200...299).contains(response.statusCode) {

                if let data = data {
                    do {
                        let message = try JSONSerialization.jsonObject(with: data, options: [])
                        print(message)
                    } catch {
                        print("[APIClient]: cannot decode error message.")
                    }
                }
                
                completion(.failure(.responseError(code: response.statusCode, message: "server returns error code")))
                
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(T.Response.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }
        
        task.resume()
    }
}
