//
//  HotelTableViewCell.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit
import AlamofireImage

class HotelTableViewCell: UITableViewCell {
    
    @IBOutlet var hotelImageLabel: UIImageView!
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var numberOfNightsLabel: UILabel!
    @IBOutlet var starImageView: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpWith(stay: Stay, hotel: Hotel?) {
        
        hotelNameLabel.text = "\((hotel?.name ?? stay.hotelBrand).capitalized) Hotel".uppercased()
        
        numberOfNightsLabel.text = stay.formattedNightsString
        
        if let hotel = hotel {
            ratingLabel.text = "\(hotel.rating)"
            starImageView.isHidden = false
            starImageView.tintColor = hotel.rating >= 4 ? UIColor.green : UIColor.orange
            
            if let imageUrl = URL(string: hotel.imageURL) {
                hotelImageLabel.af_setImage(withURL: imageUrl,
                                            placeholderImage: #imageLiteral(resourceName: "hotel-placeholder"))
            }
        } else {
            ratingLabel.text = nil
            starImageView.isHidden = true
        }
    }
}
