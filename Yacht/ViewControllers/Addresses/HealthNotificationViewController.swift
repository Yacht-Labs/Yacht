//
//  HealthNotificationViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class HealthNotificationViewController: UIViewController {
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveTouched(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.viewBackgroundColor
        navigationItem.title = "Health Score Notification"
        healthScoreLabel.text = String(round(slider.value * 100) / 100.0)
        slider.addTarget(self, action: #selector(onSlide), for: UIControl.Event.valueChanged)
        
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        saveButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributes), for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = saveButton.bounds
        gradientLayer.colors = [Constants.Colors.mediumRed.cgColor, Constants.Colors.deepRed.cgColor]
        saveButton.layer.insertSublayer(gradientLayer, at: 0)
        
        saveButton.tintColor = Constants.Colors.viewBackgroundColor
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 24
    }

    @objc func onSlide(){
        healthScoreLabel.text = String(round(slider.value * 100) / 100.0)
    }

}
