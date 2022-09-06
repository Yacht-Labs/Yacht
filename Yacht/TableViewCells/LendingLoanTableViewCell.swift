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
    var emptyLabel: UILabel?
    var collectionView: UICollectionView?
    weak var elCellDelegate: ELCollectionViewCellDelegate?
    var borrows: [EulerLoan] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        
        emptyLabel = UILabel(frame: CGRect(x: 40, y: 4, width: self.bounds.width - 80, height: self.bounds.height - 8))
        emptyLabel?.text = "Active loans on Euler associated with this address will appear here"
        emptyLabel?.textColor = Constants.Colors.oliveDrab
        emptyLabel?.font = UIFont(name: "Akkurat-LightItalic", size: 14)
        emptyLabel?.numberOfLines = 2
        emptyLabel?.alpha = 0
        if let emptyLabel = emptyLabel {
            addSubview(emptyLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
        return borrows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EulerLoanCollectionViewCell", for: indexPath) as? EulerLoanCollectionViewCell {
            
            let borrow = borrows[indexPath.row]
            
            if let urlString = borrow.token.logoURI {
                let url = URL(string: urlString)
                loadData(url: url!) { (data, _) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.tokenImage.image = UIImage(data: data)
                        }
                    }
                }
            }
            cell.tokenName.text = borrow.token.name
            
            let formatter = NumberFormatter()
            
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            
            cell.amountOwed.text = (formatter.string(from: NSNumber(value: (Float(borrow.amount) ?? 0))) ?? "??") + " \(borrow.token.symbol)"
            
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            formatter.maximumFractionDigits = 0
            
            cell.amountOwedDollars.text = formatter.string(from: NSNumber(value: ((Float(borrow.amount) ?? 0) * (Float(borrow.token.price) ?? 0))))
            
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            
            cell.borrowAPY.text = formatter.string(from: NSNumber(value: borrow.token.borrowAPY / 100))
            cell.eulAPY.text = formatter.string(from: NSNumber(value: borrow.token.eulAPY / 100))
            
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
