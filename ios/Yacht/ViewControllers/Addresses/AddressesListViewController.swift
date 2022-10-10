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
    
    func triggerLocalNetworkPrivacyAlert() {
        let sock4 = socket(AF_INET, SOCK_DGRAM, 0)
        guard sock4 >= 0 else { return }
        defer { close(sock4) }
        let sock6 = socket(AF_INET6, SOCK_DGRAM, 0)
        guard sock6 >= 0 else { return }
        defer { close(sock6) }
        
        let addresses = addressesOfDiscardServiceOnBroadcastCapableInterfaces()
        var message = [UInt8]("!".utf8)
        for address in addresses {
            address.withUnsafeBytes { buf in
                let sa = buf.baseAddress!.assumingMemoryBound(to: sockaddr.self)
                let saLen = socklen_t(buf.count)
                let sock = sa.pointee.sa_family == AF_INET ? sock4 : sock6
                _ = sendto(sock, &message, message.count, MSG_DONTWAIT, sa, saLen)
            }
        }
    }
    /// Returns the addresses of the discard service (port 9) on every
    /// broadcast-capable interface.
    ///
    /// Each array entry is contains either a `sockaddr_in` or `sockaddr_in6`.
    private func addressesOfDiscardServiceOnBroadcastCapableInterfaces() -> [Data] {
        var addrList: UnsafeMutablePointer<ifaddrs>? = nil
        let err = getifaddrs(&addrList)
        guard err == 0, let start = addrList else { return [] }
        defer { freeifaddrs(start) }
        return sequence(first: start, next: { $0.pointee.ifa_next })
            .compactMap { i -> Data? in
                guard
                    (i.pointee.ifa_flags & UInt32(bitPattern: IFF_BROADCAST)) != 0,
                    let sa = i.pointee.ifa_addr
                else { return nil }
                var result = Data(UnsafeRawBufferPointer(start: sa, count: Int(sa.pointee.sa_len)))
                switch CInt(sa.pointee.sa_family) {
                case AF_INET:
                    result.withUnsafeMutableBytes { buf in
                        let sin = buf.baseAddress!.assumingMemoryBound(to: sockaddr_in.self)
                        sin.pointee.sin_port = UInt16(9).bigEndian
                    }
                case AF_INET6:
                    result.withUnsafeMutableBytes { buf in
                        let sin6 = buf.baseAddress!.assumingMemoryBound(to: sockaddr_in6.self)
                        sin6.pointee.sin6_port = UInt16(9).bigEndian
                    }
                default:
                    return nil
                }
                return result
            }
    }
}

extension AddressesListViewController: UITableViewDelegate, UITableViewDataSource {
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
            networkManager.throbImageview(parentView: self.view, hiddenThrobber: true)
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
