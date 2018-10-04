//
//  URLSessionProtocol.swift
//  TaipeiZooDemo
//
//  Created by Din Din on 2018/10/4.
//  Copyright © 2018 DinDin. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case jsonParsingError
    case noNetworkingError
    case urlFailError
    case dataNilError
    
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
}
typealias ProviderCompletionHandler = (Data?, URLResponse?, Error?) -> Swift.Void
typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

protocol SessionProcotol {
    func requestData(url: URL, method: HTTPMethod, parameters: Parameters? ,header: HTTPHeaders? ,completionHandler: @escaping ProviderCompletionHandler)
}

protocol ProviderProcotol {
    func getList(limit: Int, offset: Int, completionHandler: @escaping ProviderCompletionHandler)
}

class Session: SessionProcotol {
    
    func requestData(url: URL, method: HTTPMethod, parameters: Parameters? = nil, header: HTTPHeaders? = nil, completionHandler: @escaping ProviderCompletionHandler) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        if let _parameters = parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: _parameters)
            request.httpBody = jsonData
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completionHandler(data, response, error)
            }
        }
        task.resume()
    }
}
