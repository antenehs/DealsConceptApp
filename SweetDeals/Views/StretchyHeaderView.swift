//
//  StretchyHeaderView.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

struct StretchyHeaderViewButtonInfo {
    var icon: UIImage
    var action: (() -> Void)
}

class StretchyHeaderView: GSKStretchyHeaderView {
    
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var gradientView: ASAGradientView!
    
    var backGroundImage: UIImage? {
        didSet {
            setup()
        }
    }
    
    var solidColorWhenCompacted: Bool = false
    var gradientColor: UIColor = UIColor.black {
        didSet {
            setup()
        }
    }
    
    var leftHeaderViewButtonInfo: StretchyHeaderViewButtonInfo? {
        didSet {
            setup()
        }
    }
    
    var maskBackgroundImage = true {
        didSet {
            setup()
        }
    }
    
    static func instantiateFromNib() -> StretchyHeaderView {
        let nibViews = Bundle.main.loadNibNamed("StretchyHeaderView", owner: self, options: nil)
        return nibViews!.first as! StretchyHeaderView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set defaults
        minimumContentHeight = UIDevice.asa_isiPhoneX() ? 90 : 100
        maximumContentHeight = 380
        contentShrinks = true
        contentExpands = true
        
        setup()
    }
    
    private func setup() {
        var bgImage = backGroundImage ?? UIImage(named: "travel")
        
        gradientView.endColor = gradientColor
        gradientView.startColor = gradientColor.withAlphaComponent(0)
        
        if maskBackgroundImage {
            bgImage = bgImage?.asa_masked(with: UIImage(named: "maskImage")!)
        }
        
        backgroundImageView.image = bgImage
        
        leftButton.isHidden = leftHeaderViewButtonInfo == nil
        leftButton.setImage(leftHeaderViewButtonInfo?.icon, for: .normal)
    }
    
    @IBAction func didTapLeftButton(_ sender: Any) {
        leftHeaderViewButtonInfo?.action()
    }
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        super .didChangeStretchFactor(stretchFactor)
        
        guard solidColorWhenCompacted else { return }
        
        // Start solidifying gradientView from stretchFactor 0.2, and end at 0.0
        let shiftedStretchFactor = Int(stretchFactor * 50)
        if shiftedStretchFactor < 10 {
            gradientView.startColor = gradientColor.withAlphaComponent(1.0 - (CGFloat(shiftedStretchFactor)/10.0))
        } else {
            gradientView.startColor = gradientColor.withAlphaComponent(0)
        }
    }
}
