//
//  Airport.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import Foundation

typealias AirportDictionary = [String: Airport]

struct Airport: Codable {
    let id: String
    let name: String
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, city
    }
    
    var shortCityName: String {
        let components = city.components(separatedBy: ",")
        return components.count == 2 ? components[0] : city
    }
}
