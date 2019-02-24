//
//  DealTableViewCell.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/12/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

class DealTableViewCell: UITableViewCell {
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var nightsLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var heroImageView: UIImageView!
    
    var deal: Deal?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func setup(withDeal deal: Deal) {
        self.deal = deal
        
        cityLabel.text = deal.destinationCity ?? deal.flights.outboundFlight.end.airport
        
        priceLabel.text = deal.formattedPrice
        nightsLabel.text = deal.stay.formattedNightsString
        
        heroImageView.image = deal.heroImage
    }
}
