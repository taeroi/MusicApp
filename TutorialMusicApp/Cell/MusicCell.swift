//
//  MusicCell.swift
//  TutorialMusicApp
//
//  Created by 태로고침 on 2021/05/01.
//

import UIKit

protocol MusicCellProtocol {
    func didTapOnTrack(cell: MusicCell, indexPath: IndexPath)
}

class MusicCell: UITableViewCell{

    
    //MARK: Components
    @IBOutlet weak var _backgroundView: UIView!
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            let nib = UINib(nibName: "TrackCell", bundle: nil)
            self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        }
    }
    
    var indexPath: IndexPath?
    var topTracks: [TopTrack]?
    var delegate: MusicCellProtocol? = nil
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: Private func
    private func setCollectionViewDataSorceDelegate(index: IndexPath, tracks: [TopTrack]){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        indexPath = index
        topTracks = tracks
        self.collectionView.reloadData()
    }
    
}

extension MusicCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topTracks!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackCell else {return UICollectionViewCell()}
        
        let obj = topTracks?[indexPath.row]
        cell.artistNameLabel.text = obj?.artistName
        cell.trackNameLabel.text = obj?.trackName
//        cell.coverImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = delegate {
            delegate?.didTapOnTrack(cell: self, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 185)
    }
    
   
    
}
