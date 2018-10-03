//
//  Resutl.swift
//  TaipeiZooDemo
//
//  Created by Din Din on 2018/10/3.
//  Copyright © 2018 DinDin. All rights reserved.
//

import Foundation

struct Result : Codable {
    
    let aBehavior: String?
    let aLocation: String?
    let aNameCh: String?
    let aPic01URL: String?
    let aInterpretation: String?
 
    enum CodingKeys: String, CodingKey {
   
        case aBehavior = "A_Behavior"
        case aLocation = "A_Location"
        case aNameCh = "A_Name_Ch"
        case aPic01URL = "A_Pic01_URL"
        case aInterpretation = "A_Interpretation"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aBehavior = try values.decodeIfPresent(String.self, forKey: .aBehavior)
        aLocation = try values.decodeIfPresent(String.self, forKey: .aLocation)
        aNameCh = try values.decodeIfPresent(String.self, forKey: .aNameCh)
        aPic01URL = try values.decodeIfPresent(String.self, forKey: .aPic01URL)
        aInterpretation = try values.decodeIfPresent(String.self, forKey: .aInterpretation)

    }
    
    
}
