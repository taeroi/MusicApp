//
//  TrackCell.swift
//  TutorialMusicApp
//
//  Created by 태로고침 on 2021/05/01.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    //MARK: Components
    @IBOutlet weak var _backgroundView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }

    //MARK: Private func

    
}

//MARK: Layout
extension TrackCell {
    func layout(){
        self._backgroundView.layer.shadowColor = UIColor.black.cgColor
        self._backgroundView.layer.shadowOffset = .zero
        self._backgroundView.layer.shadowOpacity = 0.45
        self._backgroundView.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self._backgroundView.layer.shouldRasterize = true
        self._backgroundView.layer.cornerRadius = 4
        self.layer.cornerRadius = 4
    }
}
