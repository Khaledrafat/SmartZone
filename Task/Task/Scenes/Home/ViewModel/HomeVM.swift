//
//  HomeVM.swift
//  Task
//
//  Created by Khaled on 24/12/2021.
//

import UIKit.UIImage
import RxSwift
import RxCocoa

class HomeVM {
    
    var homeNetwork : HomeNetworkProtocol!
    
    private var articleRoot : ArticleRoot?
    private var articlesData = BehaviorRelay<[Article]>(value: [Article]())
    var data : Observable<[Article]> {
        return articlesData.asObservable()
    }
    
    var startPaginating = PublishSubject<Int>()
    var showLoader = PublishSubject<Bool>()
    var disposedBag = DisposeBag()
    
    var shouldopenDetailsVC = PublishSubject<Article>()
    var shouldopenFavVC = PublishSubject<Void>()
    var openVC = PublishSubject<UIViewController>()
    
    var searchText = BehaviorRelay<String>(value: "")
    private var filterON = false
    
    var filteredData : Observable<[Article]> {
        return Observable.combineLatest(searchText, data) {[weak self] (text , articles) in
            if text.isEmpty {
                self?.filterON = false
                return articles
            } else {
                self?.filterON = true
                return articles.filter({ $0.title?.contains(text) ?? false })
            }
        }
    }
    
    private var page = 1
    var shouldPaginate = true
    
    lazy var date : String = {
       return TimeZone().getEgyTimeZone()
    }()
    
    //MARK: - INIT
    init(homeNet : HomeNetworkProtocol = HomeNetwork()) {
        self.homeNetwork = homeNet
        binding()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.getHomeData()
        }
    }
    
    //MARK: - Binding
    func binding() {
        self.startPaginating.subscribe(onNext: { [weak self] (index) in
            guard let self = self else { return }
            self.paginate(index: index)
        }).disposed(by: disposedBag)
        
        self.shouldopenDetailsVC.subscribe(onNext: {[weak self] (model) in
            guard let self = self else { return }
            let vc = ArticleDetailsVC()
            let vm = ArticleDetailsVM(data: model)
            vc.showDetailsVM = vm
            self.openVC.onNext(vc)
        }).disposed(by: disposedBag)
        
        self.shouldopenFavVC.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            let vc = LocalArticlesVC()
            let vm  = LocalArticlesVM()
            vc.localVM = vm
            self.openVC.onNext(vc)
        }).disposed(by: disposedBag)
    }
    
    //MARK: - Get Home Data
    func getHomeData() {
        showLoader.onNext(true)
        homeNetwork.getHomeTVShows(fromDate: date, page: page) {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error) :
                self.showLoader.onNext(false)
                print("error \(error.errorMessage)")
            case .success(let data) :
                guard let data = data , let artics = data.articles else {return}
                self.articleRoot = data
                self.page += 1
                var values = self.articlesData.value
                values = values + artics
                self.articlesData.accept(values)
                self.showLoader.onNext(false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.shouldPaginate = true
                }
            }
        }
    }
    
    //MARK: - Paginate
    func paginate(index : Int) {
        guard let root = articleRoot , let total = root.totalResults else { return }
        guard !filterON else { return }
        guard index == articlesData.value.count - 1 else { return }
        if total > articlesData.value.count , total != 0 , shouldPaginate {
            shouldPaginate = false
            getHomeData()
        }
    }
    
}
