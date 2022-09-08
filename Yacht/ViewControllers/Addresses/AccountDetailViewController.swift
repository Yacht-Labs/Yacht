//
//  AccountDetailViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class AccountDetailViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yachtImage: UIImageView!
    var toastView: ToastView?
    var searchController: UISearchController?
    var isAssetView: Bool = false
    var address: String?
    var nickname: String?
    var accountId: String?
    var deviceId: String?
    var allEulerTokens: [EulerToken] = []
    var shownEulerTokens: [EulerToken] = []
    var eulerAccounts: [EulerAccount] = []
    let numberFormatter = NumberFormatter()
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        toastView = ToastView.init(frame: CGRect(x: self.view.frame.origin.x, y: -80, width: self.view.frame.size.width, height: 80))
        self.view.addSubview(toastView!)
        
        navigationItem.title = nickname ?? "Unknown"
        yachtImage.alpha = 0
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.backgroundColor = Constants.Colors.viewBackgroundColor
        tableView.backgroundColor = Constants.Colors.viewBackgroundColor

        getEulerAccount()

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Assets"
        searchController?.searchBar.searchTextField.font = UIFont(name: "Akkurat-Regular", size: 14)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func getEulerAccount() {
        networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: true)
        networkManager.getEulerAccounts(address: address ?? "0x0000000000000000000000000000000000000000") { accounts, error in
            if error == nil {
                self.eulerAccounts = accounts ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
 
            }
            DispatchQueue.main.async {
                self.getEulerTokens()
            }
        }
    }
    
    func getEulerTokens() {
        let networkManager = NetworkManager()
        networkManager.getEulerTokens { tokens, error in
            if error == nil {
                self.allEulerTokens = tokens ?? []
                self.shownEulerTokens = tokens ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {

            }
            DispatchQueue.main.async {
                self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
            }
        }
    }
}

extension AccountDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return eulerAccounts.count
        case 2:
            return eulerAccounts.count
        case 3:
            return eulerAccounts.count
        case 4:
            return shownEulerTokens.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if !isAssetView {
                return 34
            } else {
                return 0
            }
        } else if indexPath.section == 1 {
            if !isAssetView {
                if eulerAccounts.isEmpty  {
                    return 44
                } else {
                    return 60
                }
            } else {
                return 0
            }
        } else if indexPath.section == 2 {
            if !isAssetView {
                if eulerAccounts.isEmpty {
                    return 44
                } else {
                    return 215
                }
            } else {
                return 0
            }
        } else if indexPath.section == 3 {
            if !isAssetView {
                if eulerAccounts.isEmpty {
                    return 44
                } else {
                    return 168
                }
            } else {
                return 0
            }
        } else if indexPath.section == 4 {
            return 92
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 4 {
            return 60
        } else {
            if !isAssetView {
                return 60
            } else {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Constants.Colors.viewBackgroundColor
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 40))
        headerView.addSubview(titleLabel)
        titleLabel.textColor = Constants.Colors.deepRed
        titleLabel.font = UIFont(name: "Akkurat-Bold", size: 22)
        
        if section == 1 {
            titleLabel.text = "Health Score"
        } else if section == 2 {
            titleLabel.text = "Deposits"
        } else if section == 3 {
            titleLabel.text = "Outstanding Loans"
        } else if section == 4 {
            titleLabel.text = "Assets"
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CopyAddressTableViewCell") as? CopyAddressTableViewCell {
                let prefix = String((address ?? "0x0000000000000000000000000000000000000000").prefix(24))
                let suffix = String((address ?? "0x0000000000000000000000000000000000000000").suffix(4))
                cell.address.text = prefix + "..." + suffix
                return cell
            }
        }
        if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HealthScoreTableViewCell") as? HealthScoreTableViewCell {
                let healthScore = eulerAccounts[indexPath.row].healthScore
                if healthScore > 0 {
                    cell.healthScore = healthScore
                    cell.setHealthScore()
                }
                if eulerAccounts.isEmpty  {
                    cell.emptyLabel?.alpha = 1
                } else {
                    cell.emptyLabel?.alpha = 0
                }
                return cell
            }
        }
        if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LendingDepositTableViewCell") as? LendingDepositTableViewCell {
                cell.edCellDelegate = self
                cell.deposits = eulerAccounts[indexPath.row].supplies
                if eulerAccounts[indexPath.row].supplies.count == 0 {
                    cell.emptyLabel?.alpha = 1
                } else {
                    cell.emptyLabel?.alpha = 0
                }
                return cell
            }
        } else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LendingLoanTableViewCell") as? LendingLoanTableViewCell {
                cell.elCellDelegate = self
                cell.borrows = eulerAccounts[indexPath.row].borrows
                if eulerAccounts[indexPath.row].borrows.count == 0 {
                    cell.emptyLabel?.alpha = 1
                } else {
                    cell.emptyLabel?.alpha = 0
                }
                return cell
            }
        } else if indexPath.section == 4 {
            // Show search bar on first cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AssetTableViewCell") as? AssetTableViewCell {
                
                let eulerToken = shownEulerTokens[indexPath.row]
                
                numberFormatter.numberStyle = .currency
                numberFormatter.currencyCode = "USD"
                numberFormatter.maximumFractionDigits = 2
                
                cell.symbol.text = eulerToken.symbol
                cell.name.text = eulerToken.name
                cell.price.text = (numberFormatter.string(from: NSNumber(value: Float(eulerToken.price) ?? 0)) ?? "??") + " / \(eulerToken.symbol)"
                
                numberFormatter.numberStyle = .percent
                
                cell.borrowAPY.text = numberFormatter.string(from: NSNumber(value: (Float(eulerToken.borrowAPY) / 100)))
                cell.lendAPY.text = numberFormatter.string(from: NSNumber(value: (Float(eulerToken.supplyAPY) / 100)))
                
                guard let urlString = eulerToken.logoURI else { return cell }
                
                let url = URL(string: urlString)
                loadData(url: url!) { (data, _) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.tokenImage.layer.cornerRadius = cell.tokenImage.bounds.height / 2
                            cell.tokenImage.image = UIImage(data: data)
                        }
                    }
                }
                return cell
            }
 
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let address = address {
                UIPasteboard.general.string = address
                toastView?.titleLabel.text = "Success"
                toastView?.bodyText.text = "Address can now be pasted from the clipboard"
                toastView?.showToast()
            }
        case 1:
            let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HealthNotificationViewController") as HealthNotificationViewController
            vc.accountId = accountId
            vc.deviceId = deviceId
            vc.accountName = nickname
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "SetIRNotificationViewController") as SetIRNotificationViewController
            let token = shownEulerTokens[indexPath.row]
            vc.tokenAddress = token.address
            vc.supplyAPY = token.supplyAPY
            vc.borrowAPY = token.borrowAPY
            vc.symbolValue = token.symbol
            vc.accountId = accountId
            vc.deviceId = deviceId
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}

extension AccountDetailViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if !searchText.isEmpty {
            let lowersearch = searchText.lowercased()
            let results = allEulerTokens.filter { token in
                token.symbol.lowercased().contains(lowersearch) || token.name.lowercased().contains(lowersearch)
            }
            shownEulerTokens = results
            isAssetView = true
        } else {
            shownEulerTokens = allEulerTokens
            isAssetView = false
        }

        tableView.reloadData()
    }
}


extension AccountDetailViewController: EDCollectionViewCellDelegate {
    func edCollectionViewCellTapped(collectionviewcell: EulerDepositCollectionViewCell?, indexPath: IndexPath, didGetTappedInTableViewCell: LendingDepositTableViewCell) {
        let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SetIRNotificationViewController") as SetIRNotificationViewController

        let deposit = eulerAccounts[indexPath.section].supplies[indexPath.row]
        vc.tokenAddress = deposit.token.address
        vc.supplyAPY = deposit.token.supplyAPY
        vc.borrowAPY = deposit.token.borrowAPY
        vc.symbolValue = deposit.token.symbol
        vc.accountId = accountId
        vc.deviceId = deviceId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AccountDetailViewController: ELCollectionViewCellDelegate {
    func elCollectionViewCellTapped(collectionviewcell: EulerLoanCollectionViewCell?, indexPath: IndexPath, didGetTappedInTableViewCell: LendingLoanTableViewCell) {
        let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SetIRNotificationViewController") as SetIRNotificationViewController

        let borrow = eulerAccounts[indexPath.section].borrows[indexPath.row]
        vc.tokenAddress = borrow.token.address
        vc.supplyAPY = borrow.token.supplyAPY
        vc.borrowAPY = borrow.token.borrowAPY
        vc.symbolValue = borrow.token.symbol
        vc.accountId = accountId
        vc.deviceId = deviceId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

