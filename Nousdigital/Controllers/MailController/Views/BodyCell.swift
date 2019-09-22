//
//  BodyCell.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import UIKit

class BodyCell: UITableViewCell {
    @IBOutlet weak var bodyTv: UITextView!
    
    func loadContent(_ desc:String){
        bodyTv.text = desc
    }

}

