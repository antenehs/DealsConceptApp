//
//  Airline.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

typealias AirlineDictionary = [String: Airline]

struct Airline: Codable {
    let id: String
    let name: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case imageURL = "image_url"
    }
}
