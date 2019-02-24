//
//  Currency.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import Foundation

typealias CurrencyDictionary = [String: Currency]

struct Currency: Codable {
    let id: String
    let name: String
    let symbol: String
    let exchange: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, symbol, exchange
    }
}
