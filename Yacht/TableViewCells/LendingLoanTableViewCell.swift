//
//  LendingLoanTableViewCell.swift
//  YachtWallet
//
//  Created by Henry Minden on 8/18/22.
//

import UIKit

protocol ELCollectionViewCellDelegate: AnyObject {
    func elCollectionViewCellTapped(collectionviewcell: EulerLoanCollectionViewCell?, index: Int, didGetTappedInTableViewCell: LendingLoanTableViewCell)
}

class LendingLoanTableViewCell: UITableViewCell {

    var collectionView: UICollectionView?
    weak var elCellDelegate: ELCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 165, height: 168)
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 5.0
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 168), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = Constants.Colors.viewBackgroundColor
        addSubview(collectionView!)

        collectionView?.showsHorizontalScrollIndicator = false
        
        collectionView?.dataSource = self
        collectionView?.delegate = self

        let cellNib = UINib(nibName: "EulerLoanCollectionViewCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "EulerLoanCollectionViewCell")
        
        collectionView?.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension LendingLoanTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EulerLoanCollectionViewCell", for: indexPath) as? EulerLoanCollectionViewCell {
            
            let url = URL(string: "https://i.imgur.com/FntEEy0.png")
            loadData(url: url!) { (data, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.tokenImage.image = UIImage(data: data)
                    }
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as? EulerLoanCollectionViewCell
        self.elCellDelegate?.elCollectionViewCellTapped(collectionviewcell: cell, index: indexPath.item, didGetTappedInTableViewCell: self)
    }
    
}
