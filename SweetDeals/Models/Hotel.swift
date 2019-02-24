//
//  Hotel.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

typealias HotelDictionary = [String: Hotel]

struct Hotel: Codable {
    let id: String
    let name: String
    let rating: Double
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, rating
        case imageURL = "image_url"
    }
}
