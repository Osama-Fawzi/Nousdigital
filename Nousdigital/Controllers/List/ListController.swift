//
//  ViewController.swift
//  Nousdigital
//
//  Created by Osama Fawzi on 9/20/19.
//  Copyright © 2019 Osama Fawzi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    lazy var searchResults:Observable<[Item]> = .just([])
    let disposeBag = DisposeBag()
    
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
        let nib = UINib(nibName: cellid, bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: cellid)
        tableview.keyboardDismissMode = .onDrag
    }
    
    private func fetchItemsList(){
        APIRequest.shared.fetch(with: API.listing, model: List.self) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let items):
                self.itemsList = items
                DispatchQueue.main.async {  self.addObservable()  }
            case .failure(let err):
                print("Fetching Error:\(err)")
            }
        }
    }
}

// MARK:- Handling Tableview using RX
extension ListController{
    fileprivate func addObservable(){
        guard let items = itemsList?.items else {return}
         searchResults = searchController.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[Item]> in
                if query.isEmpty {
                    return .just(items)
                }
                return  self.Searching(SearchWith: query)
            }
            .observeOn(MainScheduler.instance)
        tableViewBinding()
    }
    
    fileprivate func tableViewBinding() {
        searchResults.bind(to: tableview.rx.items(cellIdentifier: cellid)) {
                (_, item, cell) in
                let cell = cell as? ListTableViewCell
                cell?.loadContent(item)
            }.disposed(by: disposeBag)
        loadTableView()
    }
    
    fileprivate func loadTableView(){
        tableview.rx.itemSelected.subscribe(onNext: {[weak self] (indexPath) in
            self?.tableview.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        tableview.rx.modelSelected(Item.self).subscribe(onNext: {[weak self] (item) in
            self?.ModelMailDialog(with: item)
        }).disposed(by: disposeBag)
    }
    
    fileprivate func Searching(SearchWith term:String) -> Observable<[Item]>{
        guard let items = itemsList?.items else {return .just([])}
        let SearchingResults = items.filter({$0.title?.contains(term) ?? false || $0.description?.contains(term) ?? false})
        return .just(SearchingResults)
    }
}

//MARK :- ACTIONS
extension ListController{
    fileprivate func ModelMailDialog(with item:Item){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mailvc = storyboard.instantiateViewController(withIdentifier: "MailController") as! MailController
        mailvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mailvc.item = item
        //Security check for presented UISearchController
        if let presented = presentedViewController {
            presented.dismiss(animated: false) {
                self.searchController.searchBar.endEditing(true)
                self.present(mailvc, animated: false, completion: nil)
            }
        } else {
            present(mailvc, animated: false, completion: nil)
        }
    }
}
