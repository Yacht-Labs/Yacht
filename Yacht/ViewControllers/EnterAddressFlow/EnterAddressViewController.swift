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
        let storyboard = UIStoryboard(name: "EnterAddressFlow", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "QRScannerViewController") as QRScannerViewController
        vc.parentVC = self
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

 
    }
    
    func updateAddress(address: String) {
        addressTextField.text = parseAddressFromQR(code: address)
    }

    func parseAddressFromQR(code: String) -> String {
        let splitAddress = code.split(separator: ":")
        
        if splitAddress.count > 1 {
            return String(splitAddress[1])
        } else {
            return code
        }
    }

}
