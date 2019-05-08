//
//  ExchangeRates.swift
//  CurrencyExchange
//
//  Created by Admin on 05/05/2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation

class ExchangeRates : Codable {
    var base : String
    var rates : [String : Double] = [:]
    init(){
        base = "EUR"
        rates = ["BGN": 1.9558,"NZD": 1.6856,"ILS":4.0122,"RUB": 72.8703,"CAD": 1.5019,"USD": 1.1155,"PHP": 57.86,"CHF": 1.1383,"ZAR": 16.2072,"AUD": 1.5943,"JPY": 124.4,"TRY": 6.6644,"HKD": 8.7512,"MYR": 4.6187,"THB": 35.724,"HRK": 7.4143,"NOK": 9.7783,"IDR": 15901.45,"DKK": 7.4657,"CZK": 25.712,"HUF": 323.38,"GBP": 0.85785,"MXN": 21.3377,"KRW": 1305.08,"ISK": 136.6,"SGD": 1.5209,"BRL": 4.4194,"PLN": 4.2853,"INR": 77.259,"RON": 4.7553,"CNY": 7.5124,"SEK": 10.7043]
    }
    
    func rate(from: String, to: String) -> Double{
        if from == to { return 1 }
        if from != base && to != base{
            let fromRate = rates[from]
            let toRate = rates[to]
            if toRate != nil && fromRate != nil {
                return (toRate! / fromRate!)
            }
            else {
                return 0
            }
        }
        if from == base {
            return rates[to] != nil ? rates[to]! : 0
        }
        if to == base {
            return rates[to] != nil ? 1 / rates[from]! : 0
        }
        return 0
    }
    
}
