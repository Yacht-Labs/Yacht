//
//  HomeViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import Foundation
import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Constants.Colors.viewBackgroundColor
        tabBar.tintColor = Constants.Colors.mediumRed
        setupVCs()
    }
    

    func setupVCs() {
        let storyboard1 = UIStoryboard(name: "Addresses", bundle: nil)
        let vc1 = storyboard1.instantiateViewController(identifier: "AddressesListViewController") as AddressesListViewController
        
        let storyboard2 = UIStoryboard(name: "Settings", bundle: nil)
        let vc2 = storyboard2.instantiateViewController(identifier: "SettingsViewController") as SettingsViewController
 

        viewControllers = [
            createNavController(for: vc1, tabTitle: "Accounts", viewTitle: "Accounts", image: UIImage(systemName: "house")!),
            createNavController(for: vc2, tabTitle: "Settings", viewTitle: "Settings", image: UIImage(systemName: "bolt.horizontal.circle.fill")!),
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                    tabTitle: String,
                                                    viewTitle: String,
                                                    image: UIImage) -> UIViewController {
          let navController = UINavigationController(rootViewController: rootViewController)
          navController.tabBarItem.title = tabTitle
          navController.tabBarItem.image = image
          navController.navigationBar.prefersLargeTitles = true
          rootViewController.navigationItem.title = viewTitle
          return navController
      }

}
