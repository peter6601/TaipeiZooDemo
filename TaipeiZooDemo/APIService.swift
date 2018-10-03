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
    case loading
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
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}

class Provider: ProviderProcotol  {
    
    private var domainString: String = ""
    private var session: SessionProcotol!
    init(domainString: String, session: SessionProcotol? = nil ) {
        self.domainString = domainString
        self.session = session != nil ? session! : Session() 
    }
    
    //MARK: GET Method
    func getList(limit: Int, offset: Int, completionHandler: @escaping ProviderCompletionHandler) {
        var components = URLComponents()
        var scheme = "https://"
        var host = domainString
        if domainString.contains("://") {
            let list = domainString.components(separatedBy: "://")
            if let first = list.first {
                scheme = first
            }
            if let last = list.last {
                host = last
            }
        }
        components.scheme = scheme
        components.host = host
        components.path = "/opendata/datalist/apiAccess"
        let queryItemScope = URLQueryItem(name: "scope", value: "resourceAquire")
        let queryItemRid = URLQueryItem(name: "rid", value: "a3e2b221-75e0-45c1-8f97-75acbd43d613")
        let queryItemLimit = URLQueryItem(name: "limit", value: String(limit))
        let queryItemOffset = URLQueryItem(name: "offset", value: String(offset))
        components.queryItems = [queryItemScope, queryItemRid, queryItemLimit, queryItemOffset ]
        guard let url =  components.url else {
            return
        }
        session.requestData(url: url , method: .GET, parameters: nil, header: nil, completionHandler: completionHandler)
    }
}

//https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613&limit=3

class APIManager {
    static let shared = APIManager()
    private var provider: ProviderProcotol?
    func setProvider(provider: ProviderProcotol? = nil, urlString: String) {
        if let _provider =  provider {
            self.provider = _provider
        } else {
            self.provider = Provider(domainString: urlString)
        }
    }
    
    func getSearchRequest( limit: Int = 0, offset: Int = 0, completion: @escaping (ResutlRoot?, Error?) -> Void) {

        provider?.getList(limit: limit, offset: offset, completionHandler: { (data, response, error) in
            guard let data = data else {
                completion(nil, APIError.parsingError)
                return 
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let result = try decoder.decode(ResutlRoot.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, APIError.parsingError)
            }
        })
    }
}
