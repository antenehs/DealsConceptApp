//
//  FlightTableViewCell.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit
import AlamofireImage

class FlightTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var airlineImageView: UIImageView!
    @IBOutlet var airlineNameLabel: UILabel!
    @IBOutlet var originLabel: UILabel!
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var airportsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWith(flight: Flight,
                   airportDetails: AirportDictionary,
                   airlineDetails: AirlineDictionary) {
        dateLabel.text = DateFormatHelper.shared.monthDateYearString(forDate: flight.start.datetime)
        
        let originAirportId = flight.start.airport
        let destinationAirportId = flight.end.airport
        
        if let originAirport = airportDetails[originAirportId],
            let destinationAirport = airportDetails[destinationAirportId] {
            originLabel.text = originAirport.shortCityName.uppercased()
            destinationLabel.text = destinationAirport.shortCityName.uppercased()
            
            airportsLabel.text = "\(originAirportId) - \(destinationAirportId)"
        } else {
            originLabel.text = originAirportId.uppercased()
            destinationLabel.text = destinationAirportId.uppercased()
            
            airportsLabel.text = nil
        }
        
        if let airline = airlineDetails[flight.airline] {
            if let imageUrl = URL(string: airline.imageURL) {
                airlineImageView.af_setImage(withURL: imageUrl,
                                             placeholderImage: #imageLiteral(resourceName: "airline-placeholder"))
            }
            
            airlineNameLabel.text = airline.name
        } else {
            airlineNameLabel.text = nil
        }
        
        durationLabel.text = DateFormatHelper.shared.durationString(fromDate: flight.start.datetime,
                                                                    toDate: flight.end.datetime)
    }
    
}
