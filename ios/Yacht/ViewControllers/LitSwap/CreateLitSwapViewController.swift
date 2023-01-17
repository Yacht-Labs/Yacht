//
//  CreateLitSwapViewController.swift
//  Yacht
//
//  Created by Henry Minden on 1/10/23.
//

import UIKit

class CreateLitSwapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = getStatusBarHeight()
        let totalHeight = navHeight + statusBarHeight
        let heightOffset = totalHeight + 60
        let reactView = getReactRootView(moduleName: "LitSwapNavigator")
//        reactView.frame = CGRect(x: 0, y: totalHeight, width: self.view.frame.width, height: self.view.frame.height - heightOffset)
        reactView.frame = self.view.frame
        self.view.addSubview(reactView)
    }

}
