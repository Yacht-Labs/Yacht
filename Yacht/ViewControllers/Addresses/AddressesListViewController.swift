//
//  AddressesListViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/24/22.
//

import UIKit
import CoreData

class AddressesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var addresses: [NSManagedObject] = []

    let networkManager = NetworkManager()
    @IBOutlet weak var yachtImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yachtImage.alpha = 0
        view.backgroundColor = Constants.Colors.viewBackgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
          
        tableView.delegate = self
        tableView.dataSource = self

        loadAddresses()

        print(BuildConfiguration.shared.network)

    }
        
    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "EnterAddressFlow", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "EnterAddressViewController") as EnterAddressViewController
        vc.fromHome = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadAddresses() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Address")
        
        do {
            addresses = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            
        }
    }
    
    func deleteAddressInCoreData(atRow: Int) throws {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let addressToDelete = addresses[atRow]
        managedContext.delete(addressToDelete)
        do {
            try managedContext.save()
        } catch {
            throw error
        }
        
    }
}

extension AddressesListViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = UIView()
//        headerView.backgroundColor = Constants.Colors.viewBackgroundColor
//        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 40))
//        headerView.addSubview(titleLabel)
//        titleLabel.textColor = Constants.Colors.deepRed
//        titleLabel.font = UIFont(name: "Akkurat-Bold", size: 22)
//
//        if section == 0 {
//            titleLabel.text = "Euler"
//        } else if section == 1 {
//            titleLabel.text = "Compound"
//        } else if section == 2 {
//            titleLabel.text = "AAVE"
//        } else if section == 3 {
//            titleLabel.text = "Maker"
//        }
//
//        return headerView
//
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addresses.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as? AddressTableViewCell else {
            return UITableViewCell()
        }
        cell.contentView.backgroundColor = Constants.Colors.viewBackgroundColor
        
        let address = addresses[indexPath.row]
        cell.addressLabel.text = address.value(forKey: "address") as? String
        cell.nicknameLabel.text = address.value(forKey: "nickname") as? String
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let deviceId = appDelegate.deviceId ?? Constants.Demo.demoDeviceId
        
        let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AccountDetailViewController") as AccountDetailViewController
        vc.address = address.value(forKey: "address") as? String
        vc.nickname = address.value(forKey: "nickname") as? String
        vc.accountId = address.value(forKey: "id") as? String
        vc.deviceId = deviceId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: true)
            let account = addresses[indexPath.row]
            let id = account.value(forKey: "id") as? String
            
            guard let id = id
                    else { return }
            
            if id == Constants.Demo.demoId {
                do {
                    try deleteAddressInCoreData(atRow: indexPath.row)
                    self.addresses.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                } catch {
                    networkManager.showErrorAlert(title: "Core Data Error", message: "Failed to delete account.", vc: self)
                }
                return 
            }
            
            networkManager.deleteAccount(id: id) { account, error in
                if error == nil {
                    DispatchQueue.main.async { [self] in
                        do {
                            try deleteAddressInCoreData(atRow: indexPath.row)
                            self.addresses.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            tableView.reloadData()
                            self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                        } catch {
                            networkManager.showErrorAlert(title: "Core Data Error", message: "Failed to delete account.", vc: self)
                        }
                    }
                } else {
                    DispatchQueue.main.async { [self] in
                        self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                        self.networkManager.showErrorAlert(title: "Network Error", message: "Failed to delete account. Check your network connection", vc: self)
                    }
                }
            }
        }
    }
}
