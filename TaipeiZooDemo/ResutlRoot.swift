//
//  ResutlRoot.swift
//  TaipeiZooDemo
//
//  Created by Din Din on 2018/10/3.
//  Copyright © 2018 DinDin. All rights reserved.
//

import Foundation

struct ResutlRoot: Codable {
    let count : Int?
    let limit : Int?
    let offset : Int?
    let results : [Result]?
    let sort : String?
    
    enum CodingKeys: String, CodingKey {
        case count
        case limit
        case offset
        case results
        case sort
    }
    
    enum RootKeys: String, CodingKey {
        case result
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let values = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
        results = try values.decodeIfPresent([Result].self, forKey: .results)
        sort = try values.decodeIfPresent(String.self, forKey: .sort)
    }
    
}
