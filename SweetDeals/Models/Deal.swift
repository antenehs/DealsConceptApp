//
//  Deal.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import Foundation

class Deal: Codable {
    let price: Double
    let currency: String
    let flights: Flights
    let stay: Stay
    
    var destinationCity: String?
    
    var formattedPrice: String {
        if let formatted = DataManager.shared.formattedPriceInCurrentCurrency(value: price, currencyId: currency) {
            return formatted
        } else {
            return String(format: "%@%d", currency, Int(price))
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case price, currency, flights
        case stay = "hotel"
    }
}

struct Flights: Codable {
    let outboundFlight: Flight
    let returnFlight: Flight
    
    enum CodingKeys: String, CodingKey {
        case outboundFlight = "outbound"
        case returnFlight = "return"
    }
}

struct Flight: Codable {
    let airline: String
    let start: AirportTime
    let end: AirportTime
}

struct AirportTime: Codable {
    let datetime: Date
    let airport: String
}

struct Stay: Codable {
    let hotelBrand: String
    let nights: Int
    
    var formattedNightsString: String {
        let nightsString = nights > 1 ? "NIGHTS" : "NIGHT"
        return "\(nights) \(nightsString)"
    }
    
    enum CodingKeys: String, CodingKey {
        case hotelBrand = "brand"
        case nights = "nights"
    }
}
