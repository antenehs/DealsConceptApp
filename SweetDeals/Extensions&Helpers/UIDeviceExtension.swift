//
//  UIDeviceExtension.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/14/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

extension UIDevice {
    static func asa_isiPhoneX() -> Bool {
        return UIDevice().userInterfaceIdiom == .phone &&
               UIScreen.main.nativeBounds.height == 2436
    }
}
