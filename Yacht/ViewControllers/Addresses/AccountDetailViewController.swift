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
    var isSearching: Bool = false
    var address: String?
    var nickname: String?
    var accountId: String?
    var deviceId: String?
    var allEulerTokens: [EulerToken] = []
    var shownEulerTokens: [EulerToken] = []
    var eulerAccounts: [EulerAccount] = []
    var shownEulerAccount: EulerAccount?
    var selectedAccountIndex: Int = 0
    let numberFormatter = NumberFormatter()
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        toastView = ToastView.init(frame: CGRect(x: self.view.frame.origin.x, y: self.view.bounds.height, width: self.view.frame.size.width, height: 80))
        toastView?.parentViewHeight = self.view.bounds.height
        self.view.addSubview(toastView!)
        
        navigationItem.title = nickname ?? "Unknown"
        yachtImage.alpha = 0
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.backgroundColor = Constants.Colors.viewBackgroundColor
        tableView.backgroundColor = Constants.Colors.viewBackgroundColor

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Assets"
        searchController?.searchBar.searchTextField.font = UIFont(name: "Akkurat-Regular", size: 14)
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchPressed))
        
        getEulerAccount()
    }
        
    func changeSubAccount(row: Int) {
        selectedAccountIndex = row
        shownEulerAccount = eulerAccounts[row]
        tableView.reloadData()
    }
    
    @objc
    func switchNetwork() {
        let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
        let pickerVC = storyboard.instantiateViewController(withIdentifier: "SubAccountSelectViewController") as! SubAccountSelectViewController
        pickerVC.parentVC = self
        pickerVC.eulerAccounts = eulerAccounts
        pickerVC.selectedAccountIndex = selectedAccountIndex
        self.present(pickerVC, animated: true)
    }
    
    @objc
    func searchPressed() {
        if isSearching {
            navigationItem.searchController = nil
            isSearching = false
        } else {
            navigationItem.searchController = searchController
            isSearching = true
        }
        
    }
    
    func getEulerAccount() {
        networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: true)
        networkManager.getEulerAccounts(address: address ?? "0x0000000000000000000000000000000000000000") { accounts, error in
            if error == nil {
                self.eulerAccounts = accounts?.sorted { $0.subAccountId < $1.subAccountId }  ?? []
                self.shownEulerAccount = self.eulerAccounts[0]
                if self.eulerAccounts.count > 1 {
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "tray.2"), style: .plain, target: self, action: #selector(self.switchNetwork)),
                                                              UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.searchPressed))]
                    }
                }
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
    
    func removeEmptyEntries(account: EulerAccount) -> EulerAccount {
   
        return account
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
            return 1
        case 2:
            return 1
        case 3:
            return 1
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
                if shownEulerAccount?.healthScore == nil  {
                    return 44
                } else {
                    return 60
                }
            } else {
                return 0
            }
        } else if indexPath.section == 2 {
            if !isAssetView {
                if shownEulerAccount?.supplies == nil || shownEulerAccount?.supplies.count == 0  {
                    return 44
                } else {
                    return 225
                }
            } else {
                return 0
            }
        } else if indexPath.section == 3 {
            if !isAssetView {
                if shownEulerAccount?.borrows == nil || shownEulerAccount?.borrows.count == 0 {
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
                let prefix = String((address ?? "0x0000000000000000000000000000000000000000").prefix(6))
                let suffix = String((address ?? "0x0000000000000000000000000000000000000000").suffix(4))
                cell.address.text = prefix + "..." + suffix
                if shownEulerAccount?.subAccountId == 0 || shownEulerAccount?.subAccountId == nil {
                    cell.account.text = "Main"
                } else {
                    cell.account.text = "Sub \(shownEulerAccount?.subAccountId ?? 0)"
                }
                return cell
            }
        }
        if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HealthScoreTableViewCell") as? HealthScoreTableViewCell {
                let healthScore = shownEulerAccount?.healthScore ?? 0
                if healthScore > 0 {
                    cell.healthScore = healthScore
                    cell.setHealthScore()
                }
                if shownEulerAccount?.healthScore == nil  {
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
                cell.deposits = shownEulerAccount?.supplies ?? []
                if shownEulerAccount?.supplies == nil || shownEulerAccount?.supplies.count == 0 {
                    cell.emptyLabel?.alpha = 1
                } else {
                    cell.emptyLabel?.alpha = 0
                }
                return cell
            }
        } else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LendingLoanTableViewCell") as? LendingLoanTableViewCell {
                cell.elCellDelegate = self
                cell.borrows = shownEulerAccount?.borrows ?? []
                if shownEulerAccount?.borrows == nil || shownEulerAccount?.borrows.count == 0 {
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
                cell.price.text = (numberFormatter.string(from: NSNumber(value: Float(eulerToken.price) ?? 0)) ?? "??")
                cell.totalSupplyUSD.text = "Total Supply: " + (numberFormatter.string(from: NSNumber(value: Float(eulerToken.totalSupplyUSD ?? "0") ?? 0)) ?? "$0")
                cell.tier.text = eulerToken.tier
                
                switch eulerToken.tier {
                case "collateral":
                    cell.tierContainer.backgroundColor = Constants.Colors.eulerCollateral
                case "cross":
                    cell.tierContainer.backgroundColor = Constants.Colors.eulerCross
                case "isolated":
                    cell.tierContainer.backgroundColor = Constants.Colors.eulerIsolated
                default:
                    break
                }
                
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
            vc.subAccountId = String(selectedAccountIndex)
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

extension AccountDetailViewController: UISearchResultsUpdating, UISearchControllerDelegate {
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
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchPressed()
    }

}


extension AccountDetailViewController: EDCollectionViewCellDelegate {
    func edCollectionViewCellTapped(collectionviewcell: EulerDepositCollectionViewCell?, index: Int, didGetTappedInTableViewCell: LendingDepositTableViewCell) {
        let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SetIRNotificationViewController") as SetIRNotificationViewController

        let deposit = shownEulerAccount?.supplies[index]
        vc.tokenAddress = deposit?.token.address ?? "0x0000000000000000000000000000000000000000"
        vc.supplyAPY = deposit?.token.supplyAPY ?? 0
        vc.borrowAPY = deposit?.token.borrowAPY ?? 0
        vc.symbolValue = deposit?.token.symbol ?? ""
        vc.accountId = accountId
        vc.deviceId = deviceId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AccountDetailViewController: ELCollectionViewCellDelegate {
    func elCollectionViewCellTapped(collectionviewcell: EulerLoanCollectionViewCell?, index: Int, didGetTappedInTableViewCell: LendingLoanTableViewCell) {
        let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SetIRNotificationViewController") as SetIRNotificationViewController

        let borrow = shownEulerAccount?.borrows[index]
        vc.tokenAddress = borrow?.token.address ?? "0x0000000000000000000000000000000000000000"
        vc.supplyAPY = borrow?.token.supplyAPY ?? 0
        vc.borrowAPY = borrow?.token.borrowAPY ?? 0
        vc.symbolValue = borrow?.token.symbol ?? ""
        vc.accountId = accountId
        vc.deviceId = deviceId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

