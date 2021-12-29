//
//  ShowDetailsVM.swift
//  Task
//
//  Created by Khaled on 25/12/2021.
//

import UIKit.UIImage
import RxSwift
import RxCocoa

class ArticleDetailsVM {
    
    private var articeDetails : Article!
    private var selectedCoreData : ArticleCD?
    
    private var showDetails_PS = PublishSubject<Article>()
    var showDetails : Observable<Article> {
        return showDetails_PS.asObservable()
    }
    
    var coreData = [ArticleCD]()
    
    var name = BehaviorRelay<String>(value: "")
    var link = BehaviorRelay<String>(value: "")
    var img = BehaviorRelay<String>(value: "")
    var author = BehaviorRelay<String>(value: "")
    var content = BehaviorRelay<String>(value: "")
    var hasAuthor = BehaviorRelay<Bool>(value: false)
    
    var favBtnClicked = PublishSubject<Void>()
    var disposedBag = DisposeBag()
    
    var isfav = BehaviorRelay<Bool>(value: false)
    
    //MARK: - INIT
    init(data : Article) {
        self.articeDetails = data
        passData(data: data)
        binding()
        getCoreData()
    }
    
    //MARK: - Pass Data
    func passData(data : Article) {
        self.showDetails_PS.onNext(data)
        self.img.accept(data.urlToImage ?? "")
        self.name.accept(data.title ?? "")
        self.link.accept(data.url ?? "")
        self.author.accept("BY : \(data.author ?? "")")
        self.content.accept(data.content ?? "")
        self.hasAuthor.accept(data.author?.isEmpty == false)
    }
    
    //MARK: - Binding
    func binding() {
        favBtnClicked.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            if self.isfav.value == true {
                self.deleteCoreDataItem()
            } else {
                self.addCoreDataItem()
            }
        }).disposed(by: disposedBag)
    }
    
    //MARK: - Get Core Data
    func getCoreData() {
        if let data = CoreDataBase().getAllData() {
            self.coreData = data
            let nameV = name.value
            let imgURLV = img.value
            self.coreData.forEach {[weak self] (articleData) in
                if articleData.name == nameV , imgURLV == articleData.imgURL {
                    self?.selectedCoreData = articleData
                    self?.isfav.accept(true)
                }
            }
        }
    }
    
    //MARK: - Add CoreData Item
    func addCoreDataItem() {
        CoreDataBase().createItem(item: articeDetails)
        isfav.accept(true)
    }
    
    //MARK: - Delete CoreData Item
    func deleteCoreDataItem() {
        guard let item = selectedCoreData else { return }
        CoreDataBase().deleteItem(item: item)
        isfav.accept(false)
    }
    
}
