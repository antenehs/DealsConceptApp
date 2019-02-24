//
//  UIImageExtension.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

extension UIImage {

    func asa_masked(with maskImage: UIImage) -> UIImage? {
        let imgRef = self.cgImage!
        let maskImageRef = maskImage.cgImage
        
        guard let maskRef = maskImageRef else { return nil }
        
        let actualMask = CGImage(maskWidth: maskRef.width,
                                 height: maskRef.height,
                                 bitsPerComponent: maskRef.bitsPerComponent,
                                 bitsPerPixel: maskRef.bitsPerPixel,
                                 bytesPerRow: maskRef.bytesPerRow,
                                 provider: maskRef.dataProvider!, decode: nil, shouldInterpolate: false)
        
        guard let masked = imgRef.masking(actualMask!) else { return nil }
        
        return UIImage(cgImage: masked, scale: scale, orientation: imageOrientation)
    }
}
