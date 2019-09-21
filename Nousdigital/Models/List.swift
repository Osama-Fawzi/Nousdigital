//
//  List.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import Foundation

class List:Decodable{
    var items:[Item]?
}

class Item: Decodable {
    var id:Int?
    var title:String?
    var description:String?
    var imageUrl:String?
}
