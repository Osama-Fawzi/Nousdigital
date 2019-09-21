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
    var textChanged: (() -> Void)?
    var desc = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyTv.delegate = self
    }
    
    func loadContent(_ desc:String){
        guard self.desc.isEmpty else {return}
        self.desc = desc
        bodyTv.text = desc
    }

}

extension BodyCell:UITextViewDelegate{
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged?()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?()
    }
}
