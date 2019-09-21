//
//  ViewController.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/20/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import UIKit

class ListController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    fileprivate lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.returnKeyType = .search
        return sc
    }()
    fileprivate let cellid = String(describing: ListTableViewCell.self)
    fileprivate var itemsList:List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItemsList()
        configTableView()
        configNavigation()

    }
    
    private func configNavigation(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    private func configTableView(){
        tableview.delegate = self
        tableview.dataSource = self
        let nib = UINib(nibName: cellid, bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: cellid)
    }
    
    private func fetchItemsList(){
        APIRequest.shared.fetch(with: API.listing, model: List.self) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let items):
                self.itemsList = items
                DispatchQueue.main.async {
                    self.tableview.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                }
            case .failure(let err):
                print("Error:\(err)")
            }
        }
    }

}

//Mark:- settingup Tableview
extension ListController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = itemsList?.items?[indexPath.row] else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid , for: indexPath) as!  ListTableViewCell
        cell.loadContent(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = itemsList?.items?[indexPath.row] else {return}
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mailvc = storyboard.instantiateViewController(withIdentifier: "MailController") as! MailController
        mailvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mailvc.item = item
        self.present(mailvc, animated: false, completion: nil)    }
}

