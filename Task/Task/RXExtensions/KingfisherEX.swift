//
//  KingfisherEX.swift
//  Task
//
//  Created by Khaled on 27/12/2021.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base : UIImageView {
    
    var imageKF : Binder<String> {
        return Binder(self.base) { img, stURl in
            guard let url = URL(string: stURl) else {
                img.image = UIImage()
                return
            }
            img.kf.indicatorType = .activity
            img.kf.setImage(with: url)
        }
    }
    
}
