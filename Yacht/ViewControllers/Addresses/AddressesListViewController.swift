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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.viewBackgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
          
        tableView.delegate = self
        tableView.dataSource = self

        loadAddresses()

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
}

extension AddressesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
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
        
        let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AccountDetailViewController") as AccountDetailViewController
        vc.address = address.value(forKey: "address") as? String
        vc.nickname = address.value(forKey: "nickname") as? String
        vc.accountId = address.value(forKey: "id") as? String
        vc.deviceId = address.value(forKey: "deviceId") as? String
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
