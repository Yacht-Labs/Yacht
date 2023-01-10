//
//  AssetManagerViewController.swift
//  Yacht
//
//  Created by Henry Minden on 12/13/22.
//

import UIKit

class AssetManagerViewController: UIViewController {

    var tokenAddress: String?
    var supplyAPY: Double = 0
    var borrowAPY: Double = 0
    var symbolValue: String?
    var deviceId: String?
    var token: EulerToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Asset Manager"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = getStatusBarHeight()
        let totalHeight = navHeight + statusBarHeight
        let reactView = getReactRootView(moduleName: "EulerAssetManager")
        reactView.frame = CGRect(x: 0, y: totalHeight, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(reactView)
    }

}
