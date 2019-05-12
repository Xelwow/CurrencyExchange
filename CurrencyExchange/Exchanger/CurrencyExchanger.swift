//
//  CurrencyExchanger.swift
//  CurrencyExchange
//
//  Created by Admin on 11/05/2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation

struct ConfigurationInfo {
    var currency : String!
    var selectedCurrencyAccountAmount : String!
    var exchangeRate : String!
    var exchangeAmount : String!
    init(currency : String, selectedCurrencyAccountAmount: String, exhcangeRate: String, exchangeAmount: String) {
        self.currency = currency
        self.selectedCurrencyAccountAmount = selectedCurrencyAccountAmount
        self.exchangeRate = exhcangeRate
        self.exchangeAmount = exchangeAmount
    }
}

class CurrencyExchanger {
    var CurrancySymbols : [String : String] = ["EUR" : "€", "USD" : "$", "GBP" : "£"]
    var CurrencyAccountInfos : [CurrencyAccountInfo] = []
    var Rates = ExchangeRates()
    
    var DebitAccountIndex = 0
    var ReplenishmentAccountIndex = 1
    
    var DebitExchangeSum : Double = 0
    var ReplenishmentExchangeSum : Double = 0
    
    init(accounts : [CurrencyAccountInfo]) {
        CurrencyAccountInfos = accounts
        if(accounts.count > 1) {
            DebitAccountIndex = 0
            ReplenishmentAccountIndex = 0
        }
    }
    
    func rate(from: String, to: String) -> Double{
        return round(100 * Rates.rate(from: from, to: to)) / 100
    }
    
    func convertSum(sum: Double, debit: Bool) -> Double{
        var convertRate : Double = 0
        if debit {
            convertRate = rate(from: CurrencyAccountInfos[DebitAccountIndex].Currency, to: CurrencyAccountInfos[ReplenishmentAccountIndex].Currency)
        }
        else {
            convertRate = rate(from: CurrencyAccountInfos[ReplenishmentAccountIndex].Currency, to: CurrencyAccountInfos[DebitAccountIndex].Currency)
        }
        return round((100 * sum * convertRate))/100
    }
    func NextAccount(debitNotReplenishment : Bool){
        if debitNotReplenishment {
            DebitAccountIndex = (DebitAccountIndex + 1) % CurrencyAccountInfos.count
            if ReplenishmentExchangeSum != 0 {
                DebitExchangeSum = convertSum(sum: ReplenishmentExchangeSum, debit: false)
            }
        }
        else {
            ReplenishmentAccountIndex = (ReplenishmentAccountIndex + 1) % CurrencyAccountInfos.count
            if DebitExchangeSum != 0 {
                ReplenishmentExchangeSum = convertSum(sum: DebitExchangeSum, debit: true)
            }
        }
    }
    func PreviewAccount(debitNotReplenishment: Bool){
        if debitNotReplenishment {
            DebitAccountIndex = (DebitAccountIndex - 1) < 0 ? CurrencyAccountInfos.count - 1: DebitAccountIndex - 1
            if ReplenishmentExchangeSum != 0 {
                DebitExchangeSum = convertSum(sum: ReplenishmentExchangeSum, debit: false)
            }
        }
        else {
            ReplenishmentAccountIndex = (ReplenishmentAccountIndex - 1) < 0 ? CurrencyAccountInfos.count - 1: ReplenishmentAccountIndex - 1
            if DebitExchangeSum != 0 {
                ReplenishmentExchangeSum = convertSum(sum: DebitExchangeSum, debit: true)
            }
        }
    }
    func CurrencyConfigurationInfo(debitToReplenishment: Bool) -> ConfigurationInfo{
        var from = 0
        var to = 0
        if debitToReplenishment {
            from = DebitAccountIndex
            to = ReplenishmentAccountIndex
        }
        else {
            from = ReplenishmentAccountIndex
            to = DebitAccountIndex
        }
        let fromCurrency = CurrencyAccountInfos[from].Currency
        let toCurrency = CurrencyAccountInfos[to].Currency
        let selectedCurrencyAccountAmount = "Account amount: \(CurrancySymbols[fromCurrency]!)\(CurrencyAccountInfos[from].Amount)"
        let exchangeRate = rate(from: CurrencyAccountInfos[from].Currency
            , to: CurrencyAccountInfos[to].Currency)
        let exchangeRateInfoString = "\(CurrancySymbols[fromCurrency]!)1 = \(CurrancySymbols[toCurrency]!)\(exchangeRate)"
        var exchangeAmount = ""
        if DebitExchangeSum != 0 {
            exchangeAmount = debitToReplenishment ? "-\(DebitExchangeSum)" : "+\(ReplenishmentExchangeSum)"
        }
        return ConfigurationInfo(currency: fromCurrency, selectedCurrencyAccountAmount: selectedCurrencyAccountAmount, exhcangeRate: exchangeRateInfoString, exchangeAmount: exchangeAmount)
    }
    
    func UpdateExchangeSum(sum: Double, debit: Bool){
        if debit {
            DebitExchangeSum = sum
            ReplenishmentExchangeSum = convertSum(sum: sum, debit: true)
        }
        else {
            ReplenishmentExchangeSum = sum
            DebitExchangeSum = convertSum(sum: sum, debit: false)
        }
    }
    
    func Exchange() -> Bool {
        
        if DebitAccountIndex == ReplenishmentAccountIndex { return false }
        if DebitExchangeSum == 0 { return false }
        if DebitExchangeSum > CurrencyAccountInfos[DebitAccountIndex].Amount { return false }
        
        CurrencyAccountInfos[DebitAccountIndex].Amount -= DebitExchangeSum
        CurrencyAccountInfos[ReplenishmentAccountIndex].Amount += ReplenishmentExchangeSum
        
        DebitExchangeSum = 0
        ReplenishmentExchangeSum = 0
        return true
    }
    func AccountsInformation() -> [CurrencyAccountInfo]{
        return CurrencyAccountInfos
    }
}
