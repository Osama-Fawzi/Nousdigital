//
//  Endpoint.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var prefix: String { get }
    var method: HTTPMethod { get }
}


extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = prefix + path
//        components.queryItems = queryItems        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var request =  URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
