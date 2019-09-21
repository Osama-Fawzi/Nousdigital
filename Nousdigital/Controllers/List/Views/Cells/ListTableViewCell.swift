//
//  ListTableViewCell.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/20/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var descriptionlbl: UILabel!
    
    override func awakeFromNib() {
        separatorInset = .zero
    }
    
    func loadContent(_ item:Item){
        if let imageUrl = URL(string:item.imageUrl ?? ""){
            cellImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        titlelbl.text = item.title
        descriptionlbl.text = item.description
    }
}
