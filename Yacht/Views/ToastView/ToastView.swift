//
//  ToastView.swift
//  Simply Strong
//
//  Created by Henry Minden on 9/21/20.
//  Copyright © 2020 ProMeme. All rights reserved.
//

import UIKit

protocol ToastViewDelegate {
    func toastTouched()
}

class ToastView: UIView {

    var delegate: ToastViewDelegate?
    
    @IBOutlet private var contentView: UIView?
    // other outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var toastContainer: UIView!
    
    let toastHeight: CGFloat = 80
    let toastTopOffset: CGFloat = 140
    
    var beginY: CGFloat = 0
    var deltaY: CGFloat = 0
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ToastView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        
        toastContainer.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = content.bounds
        gradientLayer.colors = [Constants.Colors.mediumRed.cgColor,
                                Constants.Colors.deepRed.cgColor]
        toastContainer.layer.insertSublayer(gradientLayer, at: 0)
        toastContainer.layer.cornerRadius = 18
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(recognizer:)))
        pan.minimumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(recognizer:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if self.delegate != nil {
                self.delegate!.toastTouched()
            }
        }
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let touchLocation = recognizer.location(in: self)
        
        if recognizer.state == UIGestureRecognizer.State.began {
            beginY = touchLocation.y
        }
        
        if recognizer.state == UIGestureRecognizer.State.changed {
            deltaY = touchLocation.y - beginY
            if self.frame.origin.y + deltaY < toastTopOffset {
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + deltaY, width: self.frame.size.width, height: self.frame.size.height)
            }
        }
        
        if recognizer.state == UIGestureRecognizer.State.ended {
            
            let newPos = self.frame.origin.y + deltaY
            
            if newPos < (toastTopOffset - 40) {
                hideToast()
            } else {
                showToast()
            }
            beginY = 0
        }
        
    }
    
    func showToast () {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 18.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            
            self.frame = CGRect(x: self.frame.origin.x, y: self.toastTopOffset, width: self.frame.size.width, height: self.frame.size.height)
            
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                hideToast()
            }
        }
        
    }
    
    func hideToast () {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 18.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            
            self.frame = CGRect(x: self.frame.origin.x, y: -self.toastHeight, width: self.frame.size.width, height: self.frame.size.height)
            
        }) { (_) in
            
        }
        
    }

}
