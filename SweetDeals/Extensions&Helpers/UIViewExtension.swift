//
//  UIViewExtension.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

extension UIView {
    static func asa_popAnimate(view: UIView,
                               withScale scale: CGFloat = 0.2,
                               completion: (() -> Void)? = nil) {
        
        let poppedScale = 1 + scale
        UIView.asa_springAnimate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: poppedScale, y: poppedScale)
        }, completion: { _ in
            UIView.asa_springAnimate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { _ in
                completion?()
            })
        })
    }
    
    static func asa_springAnimate(withDuration duration: TimeInterval,
                              delay: TimeInterval = 0,
                              animations: @escaping (() -> Void),
                              completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseIn,
                       animations: animations,
                       completion: completion)
    }
}
