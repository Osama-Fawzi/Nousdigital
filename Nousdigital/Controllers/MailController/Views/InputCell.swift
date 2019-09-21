//
//  TableViewCell.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import UIKit

class InputCell: UITableViewCell {
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var inputTf: UITextField!
    
    //reserving value of textfield after reusability get applied.
    fileprivate lazy var value = String()
    fileprivate lazy var subject = String()
    
    override func awakeFromNib() {
        inputTf.delegate = self
    }
    
    func setupView(_ title:String){
    titlelbl.text = title
    inputTf.text = value
    }
    
    func loadContent(_ subject:String){
        guard self.subject.isEmpty else {return}
        self.subject = subject
        value = subject
        inputTf.text = subject
    }
}

extension InputCell:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        value = textField.text ?? ""
    }
}
