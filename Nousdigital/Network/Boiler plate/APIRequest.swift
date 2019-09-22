//
//  APIRequest.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import Foundation
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case message(value: String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Request Failed"
        case .invalidData:
            return "Invalid Data"
        case .responseUnsuccessful:
            return "Response Unsuccessful"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case .jsonConversionFailure:
            return "JSON Conversion Failure"
        case .message(let value):
            return value
        }
    }
}

class APIRequest {
    // Our singletone
    static let shared:APIRequest = APIRequest()
    private var timer:Timer?
    private var sessionTask:URLSessionDataTask?
    private init(){}
    
    private func initRequest(_ clientRequest:API)->URLRequest {
        var request:URLRequest = clientRequest.request
        
        request.httpMethod = clientRequest.method.rawValue
//        uncomment to add body or headers to the request.
//        request.httpBody = clientRequest.body
//        request.addHeaders(clientRequest.headers)
        
        // canceling unintentional multiple request and return single response
        if sessionTask != nil {
            if (sessionTask?.originalRequest?.url?.absoluteString.contains(clientRequest.path) ?? false) {
                sessionTask?.cancel()
                sessionTask?.suspend()
            }
        }
        return request
    }
    
    private func JSONTask<T:Codable>(with request: URLRequest, decodingModel: T.Type, completion: @escaping (Result<T,APIError>)-> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }

            switch httpResponse.statusCode {
            case 200...204,400...504:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard JSONSerialization.isValidJSONObject(json) else {
                        completion(.failure(.invalidData))
                        return
                    }
                    let responseModel = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(responseModel))
                } catch let err {
                    print("request url:\(String(describing: request.url)) with serialization error \(err)")
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                
            default:
                completion(.failure(.responseUnsuccessful))
            }
        }
        return task
    }
    
    func fetch<T: Codable>(has loading:Bool = true, with clientRequest: API, model: T.Type, completion: ((Result<T,APIError>)->())?) {
        
        if loading {
            // Timer to show loader in case response takes more than 1 second
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showspinner), userInfo: nil, repeats: false)
        }
        
        let request:URLRequest = initRequest(clientRequest)
        sessionTask = JSONTask(with: request, decodingModel: model.self) {[weak self] (result)  in
            // invalidating the timer before get fired in case of fast response.
            self?.timer?.invalidate()
            self?.timer = nil
            completion?(result)
        }
        sessionTask?.resume()
    }
    
    @objc func showspinner(){
        Helper.shared.showSpinner()
    }
    
}
