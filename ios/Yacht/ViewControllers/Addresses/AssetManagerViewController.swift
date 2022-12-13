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
    @IBOutlet weak var reactSkeletonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Asset Manager"
        navigationController?.navigationBar.prefersLargeTitles = true
       
        let reactView = getReactRootView(moduleName: "EulerAssetManager")
        reactView.frame = reactSkeletonView.frame
        self.view.addSubview(reactView)
    }
    
}
