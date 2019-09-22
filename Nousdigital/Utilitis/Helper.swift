//
//  Helper.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/22/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import UIKit

class Helper{
    static let shared = Helper()
    let blackView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return v
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let i = UIActivityIndicatorView()
        i.startAnimating()
        i.style = .white
        return i
    }()
    func showSpinner(){
        if let window = UIApplication.shared.keyWindow{
            window.addSubview(blackView)
            blackView.translatesAutoresizingMaskIntoConstraints = false
            blackView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            blackView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            blackView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            blackView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
            blackView.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            blackView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.blackView.alpha = 1
            }
        }
    }
    func hideSpinner(){
        DispatchQueue.main.async {
            self.blackView.removeFromSuperview()
        }
    }
}
