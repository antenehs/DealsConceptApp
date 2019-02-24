//
//  SettingsManager.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let defaultCurrencyChanged = Notification.Name("defaultCurrencyChanged")
    static let slowNetworkSimulationValueChanged = Notification.Name("slowNetworkSimulationValueChanged")
}

class SettingsManager {
    
    private static let kCurrencyIdDefaultsKey = "CurrencyIdDefaultsValue"
    private static let kSimulateSlowNetworkDefaultsKey = "SimulateSlowNetworkDefaultsValue"
    
    private static let defaultCurrency = "USD"
    
    static var appCurrencyId: String {
        get {
            return UserDefaults.standard.string(forKey: kCurrencyIdDefaultsKey) ?? defaultCurrency
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: kCurrencyIdDefaultsKey)
            UserDefaults.standard.synchronize()
            
            postNotification(forName: .defaultCurrencyChanged)
        }
    }
    
   static var simulateSlowNetwork: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kSimulateSlowNetworkDefaultsKey)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: kSimulateSlowNetworkDefaultsKey)
            UserDefaults.standard.synchronize()
            
            postNotification(forName: .slowNetworkSimulationValueChanged)
        }
    }
    
    private static func postNotification(forName name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }
}
