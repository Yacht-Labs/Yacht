//
//  EnterNicknameViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/24/22.
//

import UIKit
import CoreData

class EnterNicknameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var yachtImage: UIImageView!
    
    var address: String?
    
    @IBAction func continueTouched(_ sender: Any) {
        guard let address = address,
              let nickname = nicknameTextField.text else {
            return
        }
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard let deviceId = appDelegate.deviceId else {
            // TODO error message about notifications
            return
        }
        
        if checkIfValidNickname(nickname: nickname) {
            throbYacht()
            continueButton.isEnabled = false
            NetworkManager().postAccount(address: address, deviceId: deviceId, name: nickname) { account, error in
                if error == nil {
                    DispatchQueue.main.async {
                        self.createAddressInCoreData(address: address, nickname: nickname, deviceId: deviceId, id: account?.id ?? "")
                        let vc = HomeViewController()
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.stopThrob()
                        self.continueButton.isEnabled = true
                    }
                    // TODO give network fail error message
                }
            }
        } else {
            errorLabel.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.viewBackgroundColor
        errorLabel.alpha = 0
        nicknameTextField.delegate = self
        nicknameTextField.text = "Address \(getAddressCount()+1)"
        
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if checkIfValidNickname(nickname: nicknameTextField.text!) {
            errorLabel.alpha = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func checkIfValidNickname(nickname: String) -> Bool {
        return nickname.count <= 40
    }
    
    func createAddressInCoreData(address: String, nickname: String, deviceId: String, id: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedContext) else { return }
        let newAddress = NSManagedObject(entity: addressEntity, insertInto: managedContext)
        newAddress.setValue(address, forKeyPath: "address")
        newAddress.setValue(nickname, forKeyPath: "nickname")
        
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
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
    
    func throbYacht() {
        UIView.animate(withDuration: 1.0, delay:0, options: [.repeat, .autoreverse], animations: {
            self.yachtImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
    func stopThrob() {
        self.yachtImage.layer.removeAllAnimations()
    }
    
   
}
