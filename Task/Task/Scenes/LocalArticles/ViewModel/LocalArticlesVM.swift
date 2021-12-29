//
//  LocalArticlesVM.swift
//  Task
//
//  Created by Khaled on 29/12/2021.
//

import UIKit.UIImage
import RxSwift
import RxCocoa

class LocalArticlesVM {
    
    var network : FavoriteNetworkProtocol!
    private var articlesData = BehaviorRelay<[Article]>(value: [Article]())
    var data : Observable<[Article]> {
        return articlesData.asObservable()
    }
    
    var shouldGetData = PublishSubject<Void>()
    
    var shouldopenDetailsVC = PublishSubject<Article>()
    var openVC = PublishSubject<ArticleDetailsVC>()
    var showLoader = PublishSubject<Bool>()
    var disposedBag = DisposeBag()
    
    //MARK: - INIT
    init(localNetwork : FavoriteNetworkProtocol = FavoriteNetwork()) {
        self.network = localNetwork
        binding()
    }
    
    //MARK: - Get Data
    func getData() {
        network.getLocalData {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error) :
                print(error.errorMessage)
            case .success(let data) :
                self.articlesData.accept(data)
            }
        }
    }
    
    //MARK: - Binding
    func binding() {
        self.shouldopenDetailsVC.subscribe(onNext: {[weak self] (model) in
            guard let self = self else { return }
            let vc = ArticleDetailsVC()
            let vm = ArticleDetailsVM(data: model)
            vc.showDetailsVM = vm
            self.openVC.onNext(vc)
        }).disposed(by: disposedBag)
        
        shouldGetData.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.getData()
        }).disposed(by: disposedBag)
    }
    
}
