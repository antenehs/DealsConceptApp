//
//  ASAGradientView.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

@IBDesignable public class ASAGradientView: UIView {
    @IBInspectable public var startColor: UIColor = UIColor.white {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable public var endColor: UIColor = UIColor.black {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable public var isHorizontal: Bool = false {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable public var roundness: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    // MARK: Overrides
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // Setup the view appearance
    private func setupView() {
        
        let colors:Array = [startColor.cgColor, endColor.cgColor]
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = roundness
        
        if isHorizontal {
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        } else {
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        
        self.setNeedsDisplay()
    }
    
    public var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}
