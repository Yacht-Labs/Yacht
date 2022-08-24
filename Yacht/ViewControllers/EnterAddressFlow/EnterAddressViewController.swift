//
//  EnterAddressViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/23/22.
//

import UIKit

class EnterAddressViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func continueTouched(_ sender: Any) {
        if checkIfValidEthAddress(address: addressTextField.text!) {
            let storyboard = UIStoryboard(name: "EnterAddressFlow", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "EnterNicknameViewController") as EnterNicknameViewController
            vc.address = addressTextField.text
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            errorLabel.alpha = 1
        }
    }
    
    @IBAction func qrTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EnterAddressFlow", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "QRScannerViewController") as QRScannerViewController
        vc.parentVC = self
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.viewBackgroundColor
        errorLabel.alpha = 0
        addressTextField.delegate = self
        
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        continueButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: attributes), for: .normal)
        
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = continueButton.bounds
        gradientLayer.colors = [Constants.Colors.mediumRed.cgColor, Constants.Colors.deepRed.cgColor]
        continueButton.layer.insertSublayer(gradientLayer, at: 0)
        
        continueButton.tintColor = Constants.Colors.viewBackgroundColor
        continueButton.clipsToBounds = true
        continueButton.layer.cornerRadius = 24
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
    
    func checkIfValidEthAddress(address: String) -> Bool {
        let range = NSRange(location: 0, length: address.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^0x[a-fA-F0-9]{40}$")
        return regex.firstMatch(in: address, options: [], range: range) != nil
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if checkIfValidEthAddress(address: addressTextField.text!) {
            errorLabel.alpha = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

}
