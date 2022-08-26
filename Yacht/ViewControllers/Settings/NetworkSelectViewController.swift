//
//  NetworkSelectViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import UIKit

class NetworkSelectViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var chainId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension NetworkSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.evmChainNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkSelectTableViewCell") as? NetworkSelectTableViewCell {
            let chainTuple = Constants.evmChainNames[indexPath.row]
            if chainTuple.0 != chainId {
                cell.checkImage.isHidden = true
            } else {
                cell.checkImage.isHidden = false
            }
            cell.network.text = chainTuple.1
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chainTuple = Constants.evmChainNames[indexPath.row]
        chainId = chainTuple.0
        let lsm = LocalStorageManager()
        lsm.setSelectedChainId(chainId: chainId)
        tableView.reloadData()
    }
}
