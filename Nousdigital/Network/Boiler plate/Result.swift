//
//  Result.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import Foundation

enum Result<T, U> where T: Decodable, U: Error  {
    case success(T)
    case failure(U)
}

