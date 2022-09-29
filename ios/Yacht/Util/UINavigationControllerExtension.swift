//
//  UINavigationControllerExtension.swift
//  Yacht
//
//  Created by Henry Minden on 8/31/22.
//
import UIKit

extension UINavigationController {
    func forceUpdateNavBar() {
        DispatchQueue.main.async {
            self.navigationBar.sizeToFit()
        }
    }
}
