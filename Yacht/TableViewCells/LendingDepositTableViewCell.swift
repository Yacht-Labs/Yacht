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
    var emptyLabel: UILabel?
    var collectionView: UICollectionView?
    weak var edCellDelegate: EDCollectionViewCellDelegate?
    var deposits: [EulerLoan] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        
        emptyLabel = UILabel(frame: CGRect(x: 40, y: 4, width: self.bounds.width - 80, height: self.bounds.height - 8))
        emptyLabel?.text = "Active deposits on Euler associated with this address will appear here"
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

extension LendingDepositTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deposits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EulerDepositCollectionViewCell", for: indexPath) as? EulerDepositCollectionViewCell {
            
            let deposit = deposits[indexPath.row]
            
            if let urlString = deposit.token.logoURI {
                let url = URL(string: urlString)
                loadData(url: url!) { (data, _) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.tokenImage.image = UIImage(data: data)
                        }
                    }
                }
            }
            cell.tokenName.text = deposit.token.name
            
            let formatter = NumberFormatter()
            
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            
            let riskAdjustedValue = (Float(deposit.amount) ?? 0) * Float(deposit.token.collateralFactor)
            cell.amountDeposited.text = (formatter.string(from: NSNumber(value: (Float(deposit.amount) ?? 0))) ?? "??") + " \(deposit.token.symbol)"
            cell.riskAdjustedValue.text = (formatter.string(from: NSNumber(value: riskAdjustedValue)) ?? "??") + " \(deposit.token.symbol)"
            
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            formatter.maximumFractionDigits = 0
            
            cell.amountDepositedDollars.text = formatter.string(from: NSNumber(value: ((Float(deposit.amount) ?? 0) * (Float(deposit.token.price) ?? 0))))
            cell.riskAdjustedValueDollars.text = formatter.string(from: NSNumber(value: riskAdjustedValue * (Float(deposit.token.price) ?? 0)))
            
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            
            cell.lendAPY.text = formatter.string(from: NSNumber(value: deposit.token.supplyAPY / 100))
            
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            
            cell.collateralFactor.text = formatter.string(from: NSNumber(value: deposit.token.collateralFactor))
            
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
