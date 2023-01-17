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
        
        let storyboard3 = UIStoryboard(name: "LitSwap", bundle: nil)
        let vc3 = storyboard3.instantiateViewController(identifier: "CreateLitSwapViewController") as CreateLitSwapViewController
 
        //let nc3 = UINavigationController(rootViewController: vc3)
        vc3.tabBarItem.title = "Swaps"
        vc3.tabBarItem.image = UIImage(systemName: "rectangle.2.swap")!
        
        viewControllers = [
            createNavController(for: vc1, tabTitle: "Accounts", viewTitle: "Accounts", image: UIImage(systemName: "house")!),
            createNavController(for: vc2, tabTitle: "Settings", viewTitle: "Settings", image: UIImage(systemName: "gearshape")!),
            vc3
//            createNavController(for: vc3, tabTitle: "Swaps", viewTitle: "New Lit Yacht Swap", image: UIImage(systemName: "rectangle.2.swap")!),
            
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                    tabTitle: String,
                                                    viewTitle: String,
                                                    image: UIImage) -> UIViewController {
          let navController = UINavigationController(rootViewController: rootViewController)
          navController.tabBarItem.title = tabTitle
          navController.tabBarItem.image = image
          //navController.navigationBar.prefersLargeTitles = true
          //rootViewController.navigationItem.title = viewTitle
          return navController
      }

}
