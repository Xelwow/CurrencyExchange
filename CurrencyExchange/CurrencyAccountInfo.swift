//
//  CurrencyAccountInfo.swift
//  CurrencyExchange
//
//  Created by Admin on 04/05/2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation

class CurrencyAccountInfo {
    var Amount : Double = 100
    var Currency = "EUR"
    
    init(Amount : Double, Currency : String){
        self.Amount = Amount
        self.Currency = Currency
    }
}
