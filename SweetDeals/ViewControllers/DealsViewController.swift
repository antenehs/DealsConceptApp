//
//  ViewController.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/12/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class DealsViewController: UIViewController {
    
    private let kDealTableViewCellIdentifier = "dealsCell"
    private let kShowDetailSegueIdentifier = "showDetail"
    private let kShowSettingsSegueIdentifier = "showSettings"
    
    @IBOutlet var activityView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var deals: [Deal] = []
    private var notificationToken: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchDeals()
        
        notificationToken = NotificationCenter.default.addObserver(forName: .defaultCurrencyChanged,
                                                                   object: nil,
                                                                   queue: OperationQueue.main) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    deinit {
        if notificationToken != nil { NotificationCenter.default.removeObserver(notificationToken!) }
    }
    
    func setupTableView() {
        let headerView = StretchyHeaderView.instantiateFromNib()
        headerView.leftHeaderViewButtonInfo = StretchyHeaderViewButtonInfo(icon: #imageLiteral(resourceName: "settings-light"),
                                                                           action: showSettings)
        headerView.solidColorWhenCompacted = true
        headerView.maximumContentHeight = 380
        
        tableView.addSubview(headerView)
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.register(UINib(nibName: "DealTableViewCell", bundle: nil), forCellReuseIdentifier: kDealTableViewCellIdentifier)
        
        tableView.reloadData()
    }
    
    func fetchDeals() {
        activityView.isHidden = false
        DataManager.shared.fetchDeals { [weak self] (deals, error) in
            if error == nil, deals != nil {
                self?.deals = deals!
                self?.tableView.reloadData()
            } else {
                // TODO: handle error
            }
            
            self?.activityView.isHidden = true
        }
    }
    
    func showSettings() {
        performSegue(withIdentifier: kShowSettingsSegueIdentifier, sender: self)
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowDetailSegueIdentifier {
            guard let senderCell = sender as? DealTableViewCell,
                  let deal = senderCell.deal  else { return }
            
            let detailController = segue.destination as! DealDetailViewController
            
            detailController.deal = deal
            
            let headerHeroId = "cell-hero-\(UUID().uuidString)"
            senderCell.hero.id = headerHeroId
            detailController.headerHeroId = headerHeroId
            
            let titleHeroId = "cell-title-\(UUID().uuidString)"
            senderCell.cityLabel.hero.id = titleHeroId
            detailController.titleHeroId = titleHeroId
        }
     }
}

// MARK: UITableViewDataSource

extension DealsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return deals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDealTableViewCellIdentifier, for: indexPath) as! DealTableViewCell
        
        cell.setup(withDeal: deals[indexPath.section])
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension DealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Sometimes there is a delay for selection if cell.selectionType is .none
        DispatchQueue.main.async {
            let cell = tableView.cellForRow(at: indexPath)!
            UIView.asa_popAnimate(view: cell, withScale: -0.1, completion: {
                self.performSegue(withIdentifier: self.kShowDetailSegueIdentifier, sender: tableView.cellForRow(at: indexPath))
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 15.0 : 2.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
