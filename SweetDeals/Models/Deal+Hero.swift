//
//  Deal+Hero.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

extension Deal {
    
    // This should potentially come from the api call
    var heroImage: UIImage {
        switch flights.outboundFlight.end.airport {
        case "SAN":
            return UIImage(named: "san-diego")!
        case "IAD":
            return UIImage(named: "washington-dc")!
        case "SEA":
            return UIImage(named: "seatle")!
        case "JFK":
            return UIImage(named: "newyork")!
        case "ATL":
            return UIImage(named: "atlanta")!
        case "BKK":
            return UIImage(named: "bangkok")!
        case "CNX":
            return UIImage(named: "chiang-mai")!
        case "HKT":
            return UIImage(named: "phuket")!
        case "NRT":
            return UIImage(named: "tokyo")!
        case "UKB":
            return UIImage(named: "kobe")!
        case "TXL":
            return UIImage(named: "berlin")!
        case "LHR":
            return UIImage(named: "london")!

        default:
            return UIImage(named: "travel")!
        }
    }
}
