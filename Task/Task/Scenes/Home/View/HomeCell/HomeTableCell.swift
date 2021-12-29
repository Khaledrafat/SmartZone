//
//  HomeTableCell.swift
//  Task
//
//  Created by Khaled on 28/12/2021.
//

import UIKit

class HomeTableCell: UITableViewCell {
    
    @IBOutlet weak var premierLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Setup Data
    func setupCell(data : Article) {
        nameLbl.text = data.title
        premierLbl.text = "BY : \(data.author ?? "")"
        premierLbl.isHidden = data.author?.isEmpty ?? true
        
        if let stURL = data.urlToImage , let url = URL(string: stURL) {
            showImg.kf.setImage(with: url)
            showImg.kf.indicatorType = .activity
        } else {
            showImg.image = UIImage()
        }
    }
    
}
