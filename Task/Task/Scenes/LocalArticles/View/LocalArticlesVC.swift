//
//  LocalArticlesVC.swift
//  Task
//
//  Created by Khaled on 29/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class LocalArticlesVC: BaseVC {
    
    //Variables
    var localVM : LocalArticlesVM!
    
    //Outlets
    @IBOutlet weak var favTableView: UITableView!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationStyle()
        bindVM()
        bindTable()
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.localVM.shouldGetData.onNext(())
    }
    
    //MARK: - Navigation Style
    func setupNavigationStyle() {
        self.title = "Favorite List"
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - Bind VM
    func bindVM() {
        //Bind Loader
        localVM.showLoader.bind(to: self.rx.showLoader).disposed(by: self.disposeBag)
        
        localVM.openVC.subscribe(onNext: {[weak self] (vc) in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Bind Table
    func bindTable() {
        
        self.favTableView.register(UINib(nibName: "HomeTableCell", bundle: nil), forCellReuseIdentifier: "HomeTableCell")
        
        self.favTableView.rowHeight = UITableView.automaticDimension
        
        self.localVM.data
            .observe(on: MainScheduler.instance)
            .bind(to: self.favTableView.rx.items(cellIdentifier: "HomeTableCell" , cellType: HomeTableCell.self)) { (index , element , cell) in
                cell.setupCell(data: element)
                cell.selectionStyle = .none
            }
            .disposed(by: self.disposeBag)
        
        self.favTableView.rx.modelSelected(Article.self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (model) in
                guard let self = self else { return }
                self.localVM.shouldopenDetailsVC.onNext(model)
            })
            .disposed(by: disposeBag)
    }

}
