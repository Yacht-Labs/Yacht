//
//  SubAccountSelectViewController.swift
//  Yacht
//
//  Created by Henry Minden on 9/8/22.
//

import UIKit

class SubAccountSelectViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    
    var eulerAccounts: [EulerAccount] = []
    var parentVC: AccountDetailViewController?
    var selectedAccountIndex: Int = 0
    
    @IBAction func selectTouched(_ sender: Any) {
        parentVC?.changeSubAccount(row: pickerView.selectedRow(inComponent: 0)) 
        self.dismiss(animated: true) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self

        pickerView.selectRow(selectedAccountIndex, inComponent: 0, animated: false)
        
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        selectButton.setAttributedTitle(NSAttributedString(string: "Select", attributes: attributes), for: .normal)
        
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = selectButton.bounds
        gradientLayer.colors = [Constants.Colors.mediumRed.cgColor, Constants.Colors.deepRed.cgColor]
        selectButton.layer.insertSublayer(gradientLayer, at: 0)
        
        selectButton.tintColor = Constants.Colors.viewBackgroundColor
        selectButton.clipsToBounds = true
        selectButton.layer.cornerRadius = 24
    }
   
}

extension SubAccountSelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eulerAccounts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerLabel = view as? UILabel;

        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            pickerLabel?.textColor = Constants.Colors.mediumRed
            pickerLabel?.font = UIFont(name: "Akkurat-Regular", size: 18)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }

        pickerLabel?.text = fetchLabelForRowNumber(row: row)

        return pickerLabel!;
    }
    
    func fetchLabelForRowNumber(row: Int) -> String {
        
        let account = eulerAccounts[row]
        
        if account.subAccountId == 0 {
            return "Main Account"
        } else {
            return "Sub-Account \(account.subAccountId)"
        }

        
        
    }
}
