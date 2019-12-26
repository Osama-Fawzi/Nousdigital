//
//  File.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import Foundation
extension Bundle {
    
    var PrefixURL: String {
        return object(forInfoDictionaryKey: "apiPrefix") as? String ?? ""
    }
    
    var BaseURL: String {
        return object(forInfoDictionaryKey: "apiBase") as? String ?? ""
    }
    
}
