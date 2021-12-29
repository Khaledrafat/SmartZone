//
//  HomeVC.swift
//  Task
//
//  Created by Khaled on 24/12/2021.
//

import UIKit
import RxCocoa
import RxSwift

class HomeVC: BaseVC {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Variables
    var homeVM : HomeVM!

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()
        setupNavigationStyle()
        homeVM = HomeVM()
        bindVM()
        bindTable()
        bindingUI()
    }
    
    //MARK: - Navigation Style
    func setupNavigationStyle() {
        self.title = "Articles List"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "bolt.heart.fill"), style: .done, target: self, action: #selector(barButton))
        rightBarButtonItem.tintColor = .red

        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    //MARK: - Navigation Bar Button
    @objc func barButton() {
        self.homeVM.shouldopenFavVC.onNext(())
    }
    
    //MARK: - Bind VM
    func bindVM() {
        //Bind Loader
        homeVM.showLoader.bind(to: self.rx.showLoader).disposed(by: self.disposeBag)
        
        homeVM.openVC.subscribe(onNext: {[weak self] (vc) in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Bind Table
    func bindTable() {
        
        self.tableView.register(UINib(nibName: "HomeTableCell", bundle: nil), forCellReuseIdentifier: "HomeTableCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.homeVM.filteredData
            .observe(on: MainScheduler.instance)
            .bind(to: self.tableView.rx.items(cellIdentifier: "HomeTableCell" , cellType: HomeTableCell.self)) { (index , element , cell) in
                cell.setupCell(data: element)
                cell.selectionStyle = .none
            }
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(Article.self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (model) in
                guard let self = self else { return }
                self.homeVM.shouldopenDetailsVC.onNext(model)
            })
            .disposed(by: disposeBag)
        
        self.tableView.rx.willDisplayCell.subscribe(onNext: { ( _ , indexPath) in
            self.homeVM.startPaginating.onNext(indexPath.row)
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Binding UI
    func bindingUI() {
        searchBar.rx.text.orEmpty.distinctUntilChanged().throttle(.milliseconds(500), scheduler: MainScheduler.instance).bind(to: self.homeVM.searchText).disposed(by: disposeBag)
    }
    
}
