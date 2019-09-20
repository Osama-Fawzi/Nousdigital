//
//  API.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import Foundation
enum API {
    case listing
}

extension API: Endpoint{
    var base: String { // Switch case could be added in case of multiple hosts
            return Bundle.main.BaseURL
    }
    
    var prefix: String {
        return Bundle.main.PrefixURL
    }
    
    var path: String {
        switch self {
        case .listing:
            return "/sBDBJqFnfeBPrQR/download"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

}
// Could be uncommented with switch case in case of exitence of queryitems,headers or body parameters.
//    var queryItems: [URLQueryItem] {return [URLQueryItem(name:, value:)]}
//    var headers : [httpHeader] {return [httpHeader(key: , value:)]}
//        var body: Data? {return bodyJson(["":""])}

//struct httpHeader:Decodable {
//    var key:String
//    var value:String
//}

//private func bodyJson(_ bodyDic:[String: Any]) -> Data? {
//    return try? JSONSerialization.data(withJSONObject: bodyDic)
//}
