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
    var toastView: ToastView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        toastView = ToastView.init(frame: CGRect(x: self.view.frame.origin.x, y: self.view.bounds.height, width: self.view.frame.size.width, height: 80))
        toastView?.parentViewHeight = self.view.bounds.height
        self.view.addSubview(toastView!)
        
        navigationItem.title = "Select Network"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never
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
            
            if indexPath.row != 0 {
                cell.network.textColor = Constants.Colors.lightGray
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* let chainTuple = Constants.evmChainNames[indexPath.row]
        chainId = chainTuple.0
        let lsm = LocalStorageManager()
        lsm.setSelectedChainId(chainId: chainId)
        tableView.reloadData() */
        
        toastView?.titleLabel.text = "Coming Soon"
        toastView?.bodyText.text = "Support for additional blockchains is on our roadmap! Follow us on twitter @Yacht_Labs for release updates"
        toastView?.showToast()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
