//
//  FirstPageViewModel.swift
//  TaipeiZooDemo
//
//  Created by Din Din on 2018/10/3.
//  Copyright © 2018 DinDin. All rights reserved.
//

import Foundation


class  FirstPageViewModel {
    
    enum Status {
        case finish
        case loading
        case fail
    }
    let apiManager: APIManager! 
    
    private var animalList: [Result] = [] {
        didSet {
            updateData?()
        }
    }
    
    var status: Status = .finish
    var updateData: (()->())?

    var count: Int {
        get {
            return  animalList.count
        }
    }
    
     var page: Int = 0
    
    private var limit: Int = 30
    private var offset: Int = 0

    subscript(_ number: Int) -> Result {
        return animalList[number]
    }
    
    init(apiManager: APIManager? = nil) {
        self.apiManager = apiManager != nil ? apiManager! : APIManager.shared
    }
    
    func requestAPI(completion: @escaping (Error?) -> Void) {
        guard  self.status != .loading else {
            completion(APIError.loading)
            return
        }
        self.status = .loading
        apiManager.getSearchRequest(limit: limit, offset: offset) { (resultsRoot, error) in
            guard let rootData = resultsRoot else {
                self.status = .fail
                completion(APIError.parsingError)
                return
            }
            guard let results = rootData.results else {
                self.status = .fail
                completion(APIError.parsingError)
                return
            }
            self.offset += rootData.limit ?? 0
            self.animalList += results
            self.status = .finish
            
        }
    }
    
}
