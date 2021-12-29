//
//  LoaderEX.swift
//  Task
//
//  Created by Khaled on 24/12/2021.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base : BaseVC {
    
    var showLoader : Binder<Bool> {
        return Binder(self.base, scheduler: MainScheduler.instance) { vc, status in
            vc.showLoader(status)
        }
    }
    
}

