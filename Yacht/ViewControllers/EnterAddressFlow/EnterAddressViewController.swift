//
//  EnterAddressViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/23/22.
//

import UIKit

class EnterAddressViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func qrTouched(_ sender: Any) {
        let vc = QRScannerViewController()
        vc.parentVC = self
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateAddress(address: String) {
        let splitAddress = address.split(separator: ":")
        
        if splitAddress.count > 1 {
            addressTextField.text = String(splitAddress[1])
        } else {
            addressTextField.text = address
        }
        
    }


}
