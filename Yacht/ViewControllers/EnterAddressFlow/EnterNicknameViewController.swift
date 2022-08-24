//
//  EnterNicknameViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/24/22.
//

import UIKit

class EnterNicknameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var address: String?
    
    @IBAction func continueTouched(_ sender: Any) {
        if checkIfValidNickname(nickname: nicknameTextField.text!) {
            
        } else {
            errorLabel.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.viewBackgroundColor
        errorLabel.alpha = 0
        nicknameTextField.delegate = self
        
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
   
}
