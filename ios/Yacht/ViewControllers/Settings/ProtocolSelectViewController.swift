//
//  ProtocolSelectViewController.swift
//  Yacht
//
//  Created by Henry Minden on 9/16/22.
//

import UIKit

class ProtocolSelectViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var toastView: ToastView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        toastView = ToastView.init(frame: CGRect(x: self.view.frame.origin.x, y: self.view.bounds.height, width: self.view.frame.size.width, height: 80))
        toastView?.parentViewHeight = self.view.bounds.height
        self.view.addSubview(toastView!)
        
        navigationItem.title = "Select DeFi Protocol"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

extension ProtocolSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.defiProtocolNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkSelectTableViewCell") as? NetworkSelectTableViewCell {
            cell.network.text = Constants.defiProtocolNames[indexPath.row]
            
            if indexPath.row == 0 {
                cell.checkImage.isHidden = false
            } else {
                cell.network.textColor = Constants.Colors.lightGray
                cell.checkImage.isHidden = true
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toastView?.titleLabel.text = "Coming Soon"
        toastView?.bodyText.text = "Support for additional DeFi protocols is on our roadmap! Follow us on twitter @Yacht_Labs for release updates"
        toastView?.showToast()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
