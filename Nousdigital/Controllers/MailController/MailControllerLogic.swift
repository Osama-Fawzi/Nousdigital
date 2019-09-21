//
//  MailControllerLogic.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import Foundation
enum TableviewCells:CaseIterable {
    case to
    case cc
    case bcc
    case from
    case subject
    case body
    var title:String{
        switch self{
        case .to: return "To:"
        case .cc: return "CC:"
        case .bcc: return "BCC:"
        case .from: return "From:"
        case .subject: return "Subject:"
        case .body: return "Body.."
        }
    }
}
