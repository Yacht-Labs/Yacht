//
//  LendingDepositTableViewCell.swift
//  YachtWallet
//
//  Created by Henry Minden on 8/18/22.
//

import UIKit

protocol EDCollectionViewCellDelegate: AnyObject {
    func edCollectionViewCellTapped(collectionviewcell: EulerDepositCollectionViewCell?, index: Int, didGetTappedInTableViewCell: LendingDepositTableViewCell)
}

class LendingDepositTableViewCell: UITableViewCell {

    var collectionView: UICollectionView?
    weak var edCellDelegate: EDCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 165, height: 215)
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 215), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = Constants.Colors.viewBackgroundColor
        addSubview(collectionView!)

        collectionView?.showsHorizontalScrollIndicator = false
        
        collectionView?.dataSource = self
        collectionView?.delegate = self

        let cellNib = UINib(nibName: "EulerDepositCollectionViewCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "EulerDepositCollectionViewCell")
        
        collectionView?.reloadData()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension LendingDepositTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EulerDepositCollectionViewCell", for: indexPath) as? EulerDepositCollectionViewCell {
            
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
            let cell = collectionView.cellForItem(at: indexPath) as? EulerDepositCollectionViewCell
            self.edCellDelegate?.edCollectionViewCellTapped(collectionviewcell: cell, index: indexPath.item, didGetTappedInTableViewCell: self)
    }
    
}
