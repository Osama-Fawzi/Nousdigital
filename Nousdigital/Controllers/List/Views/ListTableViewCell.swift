//
//  ListTableViewCell.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/20/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var descriptionlbl: UILabel!
   

    
    func loadContent(_ item:item){
        cellImageView.backgroundColor = .cyan
        titlelbl.text = item.title
        descriptionlbl.text = item.description
        
    }
}
