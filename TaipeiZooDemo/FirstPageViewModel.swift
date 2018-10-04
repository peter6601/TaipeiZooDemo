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
        case fail(Error?)
        case empty
    }
    let apiManager: APIManager! 
    
    private var animalList: [Result] = []
    
    private(set) var status: Status = .finish {
        didSet {
            updateStatus?(status)
        }
    }
   
    var updateStatus: ((_ status: Status)->())?
    var count: Int {
        get {
            return  animalList.count
        }
    }
    
    private var limit: Int = 30
    private var offset: Int = 0

    subscript(_ number: Int) -> Result {
        return animalList[number]
    }
    
    init(apiManager: APIManager? = nil) {
        self.apiManager = apiManager != nil ? apiManager! : APIManager.shared
    }
    
    func refreshData() {
        offset = 0
        animalList.removeAll()
    }
    
    func requestAPI() {
        self.status = .loading
        apiManager.getSearchRequest(limit: limit, offset: offset) { (resultsRoot, error) in
            guard let rootData = resultsRoot else {
                self.status = .fail(error)
                return
            }
            guard let results = rootData.results else {
                self.status = .fail(APIError.dataNilError)
                return
            }
            self.animalList += results
            if !results.isEmpty {
                self.offset += rootData.limit ?? 0
                self.status = .finish
            } else {
                self.status = .empty
            }
        }
    }
}
