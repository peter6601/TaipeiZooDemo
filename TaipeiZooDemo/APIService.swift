//
//  APIService.swift
//  TaipeiZooDemo
//
//  Created by PeterDing on 2018/10/2.
//  Copyright © 2018 DinDin. All rights reserved.
//
import Foundation

enum APIError: String, Error {
    case parsingError
    case statusError
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
    func getList(page: Int, completionHandler: @escaping ProviderCompletionHandler)
}

class Session: SessionProcotol {
    
    func requestData(url: URL, method: HTTPMethod, parameters: Parameters? = nil, header: HTTPHeaders? = nil ,completionHandler: @escaping ProviderCompletionHandler) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}

class Provider: ProviderProcotol  {
    
    private var domainString: String = ""
    private var sesion = Session()
    
    init(domainString: String) {
        self.domainString = domainString
    }
    
    //MARK: GET Method
    func getList(page: Int, completionHandler: @escaping ProviderCompletionHandler) {
        guard let url = URL(string: "") else {
            return
        }
        sesion.requestData(url: url , method: .GET, parameters: nil, header: nil, completionHandler: completionHandler)
    }
    
}


class APIManager {
    
    static let shared = APIManager()
    private var provider: Provider?
    
    func setProvider(session: ProviderProcotol? = nil, urlString: String) {
        self.provider = Provider(domainString: urlString)
    }
    
    func getSearchRequest( page: Int = 0, completion: @escaping (Data?, Error?) -> Void) {
        provider?.getList(page: page, completionHandler: { (data, response, error) in
        })
    }
}
