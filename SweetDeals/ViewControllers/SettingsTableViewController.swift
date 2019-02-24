//
//  SettingsViewController.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var currencyCell: UITableViewCell!
    @IBOutlet var slowNetworkSwitch: UISwitch!
    
    @IBInspectable
    var modeName = "matches"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currencyCell.detailTextLabel?.text = SettingsManager.appCurrencyId
        slowNetworkSwitch.isOn = SettingsManager.simulateSlowNetwork
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func slowNetworkSwitchChanged(_ uiSwitch: UISwitch) {
        SettingsManager.simulateSlowNetwork = uiSwitch.isOn
    }
    
    func presentCurrencySelection() {
        let currencySelectionTVC = CurrencySelectTableViewController(style: .grouped)
        self.navigationController?.show(currencySelectionTVC, sender: self)
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presentCurrencySelection()
        }
    }
}
