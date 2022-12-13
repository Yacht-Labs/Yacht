//
//  AssetManagerViewController.swift
//  Yacht
//
//  Created by Henry Minden on 12/13/22.
//

import UIKit

class AssetManagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Asset Manager"
        navigationController?.navigationBar.prefersLargeTitles = true
       
        let reactView = getReactRootView(moduleName: "AssetManager")
        
        self.view.addSubview(reactView)
    }
    
}
