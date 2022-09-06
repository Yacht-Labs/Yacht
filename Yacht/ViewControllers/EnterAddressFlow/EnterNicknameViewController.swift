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
    var deviceId: String = "NOTIFICATIONS_DISABLED"
    var address: String?
    var toastView: ToastView?
    
    @IBAction func continueTouched(_ sender: Any) {
        guard let address = address,
              let nickname = nicknameTextField.text else {
            return
        }
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let networkManager = NetworkManager()
        
        if appDelegate.deviceId == nil {
            toastView?.titleLabel.text = "Coming Soon"
            toastView?.bodyText.text = "Notifications must be enabled in order to receive alerts. Turn on notifications and hard restart app in order to enable active notifications"
            toastView?.showToast()
        } else if appDelegate.deviceId != nil {
            deviceId = appDelegate.deviceId!
        }
        
        if checkIfValidNickname(nickname: nickname) {
            networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: false)
            continueButton.isEnabled = false
            networkManager.postAccount(address: address, deviceId: deviceId, name: nickname) { account, error in
                if error == nil {
                    DispatchQueue.main.async { [self] in
                        createAddressInCoreData(address: address, nickname: nickname, deviceId: deviceId, id: account?.id ?? "")
                        let vc = HomeViewController()
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                    }
                } else {
                    DispatchQueue.main.async {
                        networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: false)
                        self.continueButton.isEnabled = true
                        networkManager.showErrorAlert(title: "Network Error", message: "Failed to save. Check your network connection", vc: self)
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
        
        toastView = ToastView.init(frame: CGRect(x: self.view.frame.origin.x, y: -80, width: self.view.frame.size.width, height: 80))
        self.view.addSubview(toastView!)
        
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
        newAddress.setValue(deviceId, forKeyPath: "deviceId")
        newAddress.setValue(id, forKeyPath: "id")
        newAddress.setValue(true, forKeyPath: "isActive")
        
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
}
