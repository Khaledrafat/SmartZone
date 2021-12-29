//
//  ShowDetailsVC.swift
//  Task
//
//  Created by Khaled on 25/12/2021.
//

import UIKit
import RxCocoa
import RxSwift

class ArticleDetailsVC: BaseVC {
    
    //Outlets
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var linkBtn: UIButton!
    @IBOutlet weak var linkLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var showImg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Variables
    var showDetailsVM : ArticleDetailsVM?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindUI()
        bindBtn()
    }
    
    //MARK: - Bind Ui
    func bindUI() {
        self.showDetailsVM?.hasAuthor.asDriver()
            .drive(self.authorLbl.rx.isHidden).disposed(by: disposeBag)
        
        self.showDetailsVM?.name.asDriver()
            .drive(self.titleLbl.rx.text).disposed(by: disposeBag)
        
        self.showDetailsVM?.img.asDriver()
            .drive(self.showImg.rx.imageKF).disposed(by: disposeBag)
        
        self.showDetailsVM?.author.asDriver()
            .drive(self.authorLbl.rx.text)
            .disposed(by: disposeBag)
        
        self.showDetailsVM?.link.asDriver()
            .drive(self.linkLbl.rx.text)
            .disposed(by: disposeBag)
        
        self.showDetailsVM?.content.asDriver()
            .drive(self.contentLbl.rx.text)
            .disposed(by: disposeBag)
        
        self.showDetailsVM?.isfav.subscribe(onNext: { status in
            let img = status ? UIImage(systemName: "heart.fill")! : UIImage(systemName: "heart")!
            self.favBtn.setImage(img , for: .normal)
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Bind Button
    func bindBtn() {
        linkBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let st_url = self.linkLbl.text , let url = URL(string: st_url) else  { return }
            UIApplication.shared.open(url)
        }).disposed(by: disposeBag)
        
        favBtn.rx.tap.throttle(.milliseconds(1000) , scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.showDetailsVM?.favBtnClicked.onNext(())
        }).disposed(by: disposeBag)
    }

}
