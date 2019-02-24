//
//  DealDetailViewController.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/12/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit
import PullToDismiss
import Hero

class DealDetailViewController: UIViewController {
    
    private let kFlightTableViewCellIdentifier = "flightCell"
    private let kHotelTableViewCellIdentifier = "hotelCell"

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bookButton: UIButton!
    
    private var pullToDismiss: PullToDismiss?
    private var notificationToken: NSObjectProtocol?
    
    var headerView: StretchyHeaderView!
    
    var deal: Deal!
    var airportDetails: AirportDictionary?
    var airlineDetails: AirlineDictionary?
    var hotel: Hotel?
    
    var headerHeroId: String?
    var titleHeroId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.modalAnimationType = .cover(direction: HeroDefaultAnimationType.Direction.up)
        pullToDismiss = PullToDismiss(scrollView: tableView)
        
        fetchDetails()
        
        setupTableView()
        setupBookButton()
        
        notificationToken = NotificationCenter.default.addObserver(forName: .defaultCurrencyChanged,
                                                                   object: nil,
                                                                   queue: OperationQueue.main) { [weak self] _ in
            self?.setupBookButton()
        }
    }
    
    deinit {
        if notificationToken != nil { NotificationCenter.default.removeObserver(notificationToken!) }
    }
    
    func setupTableView() {
        setupHeaderView()
        
        tableView.addSubview(headerView)
        
        tableView.register(UINib(nibName: "FlightTableViewCell", bundle: nil),
                           forCellReuseIdentifier: kFlightTableViewCellIdentifier)
        tableView.register(UINib(nibName: "HotelTableViewCell", bundle: nil),
                           forCellReuseIdentifier: kHotelTableViewCellIdentifier)
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.reloadData()
    }
    
    func setupHeaderView() {
        headerView = StretchyHeaderView.instantiateFromNib()
        headerView.backGroundImage = deal.heroImage
        headerView.minimumContentHeight = 200
        headerView.maximumContentHeight = 300
        headerView.titleLabel.text = deal.destinationCity
        headerView.maskBackgroundImage = false
        
        headerView.titleLabel.hero.id = titleHeroId
        headerView.hero.id = headerHeroId
        headerView.hero.modifiers = [.spring(stiffness: 250, damping: 20)]
    }
    
    func setupBookButton() {
        bookButton.setTitle("BOOK (\(deal.formattedPrice))", for: .normal)
    }
    
    func fetchDetails() {
        DataManager.shared.getDetailsForFlights(deal.flights) { [weak self] (airportDictionaries, airlineDictionaries) in
            self?.airportDetails = airportDictionaries ?? [:]
            self?.airlineDetails = airlineDictionaries ?? [:]
            
            self?.tableView.reloadData()
        }
        
        DataManager.shared.getHotelForName(deal.stay.hotelBrand) { [weak self] (hotel) in
            self?.hotel = hotel
            
            self?.tableView.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction func bookButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.google.com/flights")!,
                                  options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                  completionHandler: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension DealDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kFlightTableViewCellIdentifier,
                                                     for: indexPath) as! FlightTableViewCell
            let flight = indexPath.row == 0 ? deal.flights.outboundFlight : deal.flights.returnFlight
            
            cell.setupWith(flight: flight,
                           airportDetails: airportDetails ?? [:],
                           airlineDetails: airlineDetails ?? [:])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kHotelTableViewCellIdentifier,
                                                     for: indexPath) as! HotelTableViewCell
            
            cell.setUpWith(stay: deal.stay, hotel: hotel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "FLIGHT"
        } else {
            return "HOTEL"
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
