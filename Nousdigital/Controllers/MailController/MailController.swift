//
//  MailDialogView.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/21/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import UIKit

class MailController: UIViewController {

    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dragingView: UIView!
    @IBOutlet weak var AnchorView: UIView!
    @IBOutlet weak var cardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    
    fileprivate var maxCardViewHeight:CGFloat {
        let screenheight = UIScreen.main.bounds.height
        return screenheight-100
    }
    fileprivate let inputCellId = String(describing: InputCell.self)
    fileprivate let bodyCellId = String(describing: BodyCell.self)
    lazy var tableViewCells:[TableviewCells] = TableviewCells.allCases
    var item:Item = Item()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        setupViews()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performCardViewAnimation(state: true)
    }
    
    fileprivate func loadViews(){
    cardView.layer.cornerRadius = 10
    cardView.clipsToBounds = true
        
    AnchorView.clipsToBounds = true
    AnchorView.layer.cornerRadius = 2
        
    cardViewHeight.constant = 0
    }
    
    fileprivate func setupViews() {
        darkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDarkView(_:))))
        dragingView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:))))
        AnchorView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:))))
    }
    
    fileprivate func setupTableView(){
        tableview.delegate = self
        tableview.dataSource = self
        
        var nib = UINib(nibName: inputCellId, bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: inputCellId)
        nib = UINib(nibName: bodyCellId, bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: bodyCellId)

        tableview.reloadData()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        performCardViewAnimation(state: false)
    }
}

// MARK :- Animation handling
extension MailController {
    fileprivate func performCardViewAnimation(state open:Bool) {
        self.cardViewHeight.constant = open ? maxCardViewHeight : 0
        self.darkView.alpha = open ? 0.7 : 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            
        }, completion: {[weak self](_) in
            guard let self = self else { return }
            if !open {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    @objc fileprivate func tapDarkView(_ sender: UITapGestureRecognizer) {
        performCardViewAnimation(state: false)
    }
    
    @objc fileprivate func dragAction(_ sender:UIPanGestureRecognizer) {
        guard let window = UIApplication.shared.keyWindow else { return }
        var y = sender.translation(in: window).y
        guard y > .zero else { return }
        cardView.transform = .init(translationX: 0, y: y)
        if y > .zero {
            UIView.animate(withDuration: 0.1) {[weak self] in
                guard let self = self else { return }
                y = max(y,205)
                let alpha = (1-(y/self.maxCardViewHeight))
                self.darkView.alpha = alpha
            }
        }
        
        if sender.state == .ended {
            if y < .zero {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {[weak self] in
                    guard let self = self else { return }
                    self.cardView.transform = .identity
                    self.darkView.alpha = 0.7
                })
            } else if y > (maxCardViewHeight / 2) {
                performCardViewAnimation(state: false)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {[weak self] in
                    guard let self = self else { return }
                    self.cardView.transform = .identity
                    self.darkView.alpha = 0.7
                })
            }
        }
    }
}

//MARK :- UITableViewDelegate,UITableViewDataSource
extension MailController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewCells[indexPath.row] {
        case .to,.from,.subject,.bcc,.cc:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId, for: indexPath) as! InputCell
            cell.setupView(tableViewCells[indexPath.row].title)
            guard tableViewCells[indexPath.row] == .subject else{return cell}
            cell.loadContent(item.title ?? "")
            return cell
        case .body:
            let cell = tableView.dequeueReusableCell(withIdentifier: bodyCellId, for: indexPath) as! BodyCell
            cell.textChanged {[weak tableView] (_) in
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
            cell.loadContent(item.description ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableViewCells[indexPath.row] {
        case .body:
           return max(500,UITableView.automaticDimension)

        default :
            return UITableView.automaticDimension

        }
    }
    
}
