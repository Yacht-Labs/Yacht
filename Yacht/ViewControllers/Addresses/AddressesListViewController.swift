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
    
//    func testjson() {
//        let test = "{\"loans\":[{\"token\":{\"address\":\"0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0\",\"name\":\"Wrapped liquid staked Ether 2.0\",\"symbol\":\"wstETH\",\"price\":\"1662.780791578909760493\",\"decimals\":18,\"tier\":\"collateral\",\"supplyAPY\":1.5,\"borrowAPY\":4.07,\"borrowFactor\":0.89,\"collateralFactor\":0.85,\"eulAPY\":0,\"createdAt\":\"2022-08-26T17:08:19.750Z\",\"updatedAt\":\"2022-08-26T17:08:19.751Z\"},\"amount\":\"0.183406631607940305\"}],\"borrows\":[{\"token\":{\"address\":\"0x6b175474e89094c44da98b954eedeac495271d0f\",\"name\":\"Dai Stablecoin\",\"symbol\":\"DAI\",\"price\":\"1.000959158461071673\",\"decimals\":18,\"tier\":\"collateral\",\"supplyAPY\":7.28,\"borrowAPY\":2.17,\"borrowFactor\":0.88,\"collateralFactor\":0.85,\"eulAPY\":0,\"createdAt\":\"2022-08-26T17:08:19.751Z\",\"updatedAt\":\"2022-08-26T17:08:19.751Z\"},\"amount\":\"100.214527591139626725\"},{\"token\":{\"address\":\"0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48\",\"name\":\"USD Coin\",\"symbol\":\"USDC\",\"price\":\"0.999999999999998936\",\"decimals\":6,\"tier\":\"collateral\",\"supplyAPY\":1.25,\"borrowAPY\":2.86,\"borrowFactor\":0.94,\"collateralFactor\":0.9,\"eulAPY\":0,\"createdAt\":\"2022-08-26T17:08:19.752Z\",\"updatedAt\":\"2022-08-26T17:08:19.752Z\"},\"amount\":\"39.292676\"}],\"healthScore\":1.6059411151752057}"
//        let apiResponse = try! JSONDecoder().decode(EulerAccount.self, from: test.data(using: .utf8)!)
//
//    }
    
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
