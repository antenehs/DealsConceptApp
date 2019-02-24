//
//  DataManager.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

class DataManager {
    
    static let shared = DataManager()
    
    // MARK: Private constants
    private let kDealsUrl = "https://antenehs.github.io/sweetdeals/deals.json"
    private let kHotelsUrl = "https://antenehs.github.io/sweetdeals/hotels.json"
    private let kAirportsUrl = "https://antenehs.github.io/sweetdeals/airports.json"
    private let kAirlinesUrl = "https://antenehs.github.io/sweetdeals/airlines.json"
    private let kCurrencyUrl = "https://antenehs.github.io/sweetdeals/currency.json"
    
    
    // MARK: Caches
    private var cachedAirports: AirportDictionary?
    private var cachedAirlines: AirlineDictionary?
    private var cachedHotels: HotelDictionary?
    private var cachedCurrencys: CurrencyDictionary?
    
    private init() {}
    
    // MARK: Public methods
    
    /// Fetches deals, airports and currencies
    ///
    /// - Parameter completion: Completion block with the list of deals.
    public func fetchDeals(withCompletion completion: @escaping ([Deal]?, Error?) -> Void) {
        
        var allDeals: [Deal]?
        var fetchDealsError: Error?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchObjects(fromUrl: kDealsUrl) { (deals: [Deal]?, error) in
            allDeals = deals
            fetchDealsError = error
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchAirports { (_, _) in dispatchGroup.leave() }
        
        dispatchGroup.enter()
        fetchCurrencys { (_, _) in dispatchGroup.leave() }
        
        dispatchGroup.notify(queue: .main) {
            guard let deals = allDeals else {
                completion(nil, fetchDealsError)
                return
            }
            
            for i in 0..<deals.count {
                let deal = deals[i]
                guard let destinationAirport = self.cachedAirports?[deal.flights.outboundFlight.end.airport] else {
                    continue
                }
                
                deal.destinationCity = destinationAirport.city
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (SettingsManager.simulateSlowNetwork ? 2 : 0),
                                          execute: {
                                            completion(deals, nil)
            })
        }
        
    }
    
    
    /// Gets detail airport and airline info related to flights object
    ///
    /// - Parameters:
    ///   - flights: `Flights` object with the outbound and return `Flight`s
    ///   - completion: Completion block called once the details are fetched with the
    ///                 detail airport and airline dictionaries for the flights
    public func getDetailsForFlights(_ flights: Flights,
                                     completion: @escaping (AirportDictionary?, AirlineDictionary?) -> Void) {
        var airportsDictionary: AirportDictionary? = [:]
        var airlinesDictionary: AirlineDictionary? = [:]
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchAirports { (airports, _) in
            if let airports = airports {
                airportsDictionary?[flights.outboundFlight.start.airport] = airports[flights.outboundFlight.start.airport]
                airportsDictionary?[flights.outboundFlight.end.airport] = airports[flights.outboundFlight.end.airport]
                airportsDictionary?[flights.returnFlight.start.airport] = airports[flights.returnFlight.start.airport]
                airportsDictionary?[flights.returnFlight.end.airport] = airports[flights.returnFlight.end.airport]
            } else {
                airportsDictionary = nil
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchAirlines { (airlines, _) in
            if let airlines = airlines {
                airlinesDictionary?[flights.outboundFlight.airline] = airlines[flights.outboundFlight.airline]
                airlinesDictionary?[flights.returnFlight.airline] = airlines[flights.returnFlight.airline]
            } else {
                airlinesDictionary = nil
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            
            // Note: Not really required. Only to simulate slow network response
            DispatchQueue.main.asyncAfter(deadline: .now() + (SettingsManager.simulateSlowNetwork ? 2 : 0),
                                          execute: {
                completion(airportsDictionary, airlinesDictionary)
            })
        }
    }
    
    
    /// Gets either cached hotel details or fetch from API using name
    ///
    /// - Parameters:
    ///   - hotelName: Name of the hotell
    ///   - completion: Completion block called once fetching is complete with the
    ///                 `Hotel` object
    /// - Note(to self): Method can be modified to take cachePolicy argument to decide
    ///                  whether to return cached or always fetch from API
    public func getHotelForName(_ hotelName: String,
                                completion: @escaping (Hotel?) -> Void)  {
        fetchHotels { (hotelDictionary, error) in
            var hotel: Hotel? = nil
            if let hotels = hotelDictionary {
                hotel = hotels[hotelName]
            }
            
            // Note: Not really required. Only to simulate slow network response
            DispatchQueue.main.asyncAfter(deadline: .now() + (SettingsManager.simulateSlowNetwork ? 2 : 0),
                                          execute: {
                completion(hotel)
            })
        }
    }
    
    
    /// Returns formatted currency string exchanged to the user's prefered currency.
    /// Conversion can only be done once `fetchDeals(withCompletion:)` or
    /// `fetchCurrencys(withCompletion:)` is called and completed.
    ///
    /// - Parameters:
    ///   - value: value
    ///   - currencyId: current currency for the value
    /// - Returns: Formatted string of converted value to the users prefered currency. Default is USD
    /// - Note: All decimal points are dropped from the fomatted money for the convinience of this app. 
    public func formattedPriceInCurrentCurrency(value: Double,
                                                currencyId: String) -> String? {
        let desiredCurrencyId = SettingsManager.appCurrencyId
        
        guard let currencies = DataManager.shared.cachedCurrencys,
                let currency = currencies[currencyId],
                let desiredCurrency = currencies[desiredCurrencyId] else {
            return nil
        }
        
        if desiredCurrencyId == currencyId {
            return String(format: "%@%d", currency.symbol, Int(value))
        }

        // Conversion logic is - divide by exchange rate to get dollar value then
        // multiply by desired currency exchange
        let desiredValue = ( value/currency.exchange ) * desiredCurrency.exchange
        
        return String(format: "%@%d", desiredCurrency.symbol, Int(desiredValue))
    }
    
    /// Gets either cached currency conversion details or fetch from API
    ///
    /// - Parameters:
    ///   - completion: Completion block called once fetching is complete with the
    ///                 dictionary of currencies
    /// - Note(to self): Method can be modified to take cachePolicy argument to decide
    ///                  whether to return cached or always fetch from API
    public func fetchCurrencys(withCompletion completion: @escaping (CurrencyDictionary?, Error?) -> Void) {
        
        if let cached = cachedCurrencys {
            completion(cached, nil)
            return
        }
        
        fetchObjects(fromUrl: kCurrencyUrl) { [weak self] (currencies: CurrencyDictionary?, error) in
            self?.cachedCurrencys = currencies
            completion(currencies, error)
        }
    }
    
    // MARK: Private methods
    
    /// - Note(to self): Method can be modified to take cachePolicy argument to decide
    ///                  whether to return cached or always fetch from API
    private func fetchAirports(withCompletion completion: @escaping (AirportDictionary?, Error?) -> Void) {
        
        if let cached = cachedAirports {
            completion(cached, nil)
            return
        }
       
        fetchObjects(fromUrl: kAirportsUrl) { [weak self] (airports: AirportDictionary?, error) in
            self?.cachedAirports = airports
            completion(airports, error)
        }
    }
    
    /// - Note(to self): Method can be modified to take cachePolicy argument to decide
    ///                  whether to return cached or always fetch from API
    private func fetchAirlines(withCompletion completion: @escaping (AirlineDictionary?, Error?) -> Void) {
        
        if let cached = cachedAirlines {
            completion(cached, nil)
            return
        }
        
        fetchObjects(fromUrl: kAirlinesUrl) { [weak self] (airlines: AirlineDictionary?, error) in
            self?.cachedAirlines = airlines
            completion(airlines, error)
        }
    }
    
    /// - Note(to self): Method can be modified to take cachePolicy argument to decide
    ///                  whether to return cached or always fetch from API
    private func fetchHotels(withCompletion completion: @escaping (HotelDictionary?, Error?) -> Void) {
        
        if let cached = cachedHotels {
            completion(cached, nil)
            return
        }
        
        fetchObjects(fromUrl: kHotelsUrl) { [weak self] (hotels: HotelDictionary?, error) in
            self?.cachedHotels = hotels
            completion(hotels, error)
        }
    }
    
    private func fetchObjects<T: Codable>(fromUrl urlString: String,
                                          completion: @escaping (T?, Error?) -> Void) {
        let request = APIRequest()
        request.apiUrlString = urlString
        
        request.responseCodable { (objects: T?, error) -> () in
            if let objects = objects, error == nil {
                completion(objects, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
