//
//  EnterAddressViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/23/22.
//

import UIKit
import CoreData

class EnterAddressViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    var fromHome: Bool = false
    let demoAddress: String = "0xB84Cd93582Cf94B0625C740F7EA441E33bC6FD6F"
    let demoNickname: String = "Demo Account"
    let demoDeviceId: String = "NOTIFICATIONS_DISABLED"
    let demoId: String = "DEMO_ID"
    
    @IBAction func skipTouched(_ sender: Any) {
        let vc = HomeViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
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
        
        skipButton.isEnabled = false
        
        if !fromHome {
            if getAddressCount() > 0 {
                let vc = HomeViewController()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            } else {
                createDemoAccount()
                skipButton.isEnabled = true
            }
        }

        skipButton.isEnabled = true
        view.backgroundColor = Constants.Colors.viewBackgroundColor
        errorLabel.alpha = 0
        addressTextField.delegate = self
        
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        continueButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: attributes), for: .normal)
        
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
        
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    func getAddressCount() -> Int {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return 0
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Address")
        
        do {
            let addresses = try managedContext.fetch(fetchRequest)
            return addresses.count
        } catch {
            return 0
        }
    }

    func createDemoAccount() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedContext) else { return }
        let newAddress = NSManagedObject(entity: addressEntity, insertInto: managedContext)
        newAddress.setValue(demoAddress, forKeyPath: "address")
        newAddress.setValue(demoNickname, forKeyPath: "nickname")
        newAddress.setValue(demoDeviceId, forKeyPath: "deviceId")
        newAddress.setValue(demoId, forKeyPath: "id")
        newAddress.setValue(true, forKeyPath: "isActive")
        
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
        
        
    }
    
    func deleteAllAccountsInLocalDb()  {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(batchDeleteRequest)

        } catch {
            
        }
    }
}
