//
//  BaseVC.swift
//  Task
//
//  Created by Khaled on 24/12/2021.
//

import UIKit
import SwiftSpinner
import RxSwift
import RxCocoa

class BaseVC: UIViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Show Loader
    func showLoader(_ show : Bool) {
        print("Should Show \(show)")
        if show {
            SwiftSpinner.show("Loading ...", animated: true)
        } else {
            SwiftSpinner.hide()
        }
    }

}
