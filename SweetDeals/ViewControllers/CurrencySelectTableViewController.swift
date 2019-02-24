//
//  CurrencySelectTableViewController.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

class CurrencySelectTableViewController: UITableViewController {
    
    var allCurrencies: [Currency]?
    var currentCurrencyId = SettingsManager.appCurrencyId

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "CURRENCY"

        DataManager.shared.fetchCurrencys { [weak self] (currencyDictionary, _) in
            if let currencyDictionary = currencyDictionary {
                self?.allCurrencies = Array(currencyDictionary.values)

                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCurrencies?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")

        let currency = allCurrencies![indexPath.row]
        
        cell.textLabel?.text = currency.name
        cell.accessoryType = currentCurrencyId == currency.id ? .checkmark : .none
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        currentCurrencyId = allCurrencies![indexPath.row].id
        SettingsManager.appCurrencyId = currentCurrencyId
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
