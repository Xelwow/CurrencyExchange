//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Admin on 01/05/2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CurrencyCardViewProtocol, CurrencyHorizontalScrollViewDelegate {
    
    @IBOutlet weak var ReplenishmentAccountCards : CurrencyHorizontalScrollView!
    @IBOutlet weak var DebitAccountCards : CurrencyHorizontalScrollView!
    @IBOutlet weak var ExchangeButton : UIButton!
    
    var CurrencyAccountInfos : [CurrencyAccountInfo] = []
    
    var exchangeRates = ExchangeRates()
    var CurrancySymbols : [String : String] = ["EUR" : "€", "USD" : "$", "GPN" : "£"]
    
    var SelectedDebitAccountIndex : Int = 0
    var SelectedReplenishmentIndex : Int = 0
    var CurrentExchangeRate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CurrencyAccountInfos = [CurrencyAccountInfo(Amount: 100, Currency: "EUR"), CurrencyAccountInfo(Amount: 100, Currency: "USD"), CurrencyAccountInfo(Amount: 100, Currency: "GPN")]
        testConfiguration()
        // Do any additional setup after loading the view.
    }
    
    func ExchangeSumChanged(from Card: CurrencyCardView, sum: String) -> String{
        var symbol = ""
        if Card == ReplenishmentAccountCards.Selected_CurrencyCardView {
           symbol = "+"
        }
        else {
            if Card == DebitAccountCards.Selected_CurrencyCardView {
                symbol = "-"
            }
            else {
                return sum
            }
        }
        return symbol + sum
    }
    
    func PrevCardSelection(card : CurrencyCardView) {
        if card == ReplenishmentAccountCards.Preview_CurrencyCardView {
            SelectedDebitAccountIndex = (SelectedDebitAccountIndex - 1) < 0 ? CurrencyAccountInfos.count - 1 : SelectedDebitAccountIndex - 1
            CardConfiguration(index: SelectedDebitAccountIndex, index: SelectedReplenishmentIndex, card: card)
        }
        if card == DebitAccountCards.Preview_CurrencyCardView {
            SelectedReplenishmentIndex = (SelectedReplenishmentIndex - 1) < 0 ? CurrencyAccountInfos.count - 1 : SelectedReplenishmentIndex - 1
            CardConfiguration(index: SelectedReplenishmentIndex, index: SelectedDebitAccountIndex, card: card)
        }
    }
    
    func NextCardSelection(card: CurrencyCardView) {
        if card == ReplenishmentAccountCards.Preview_CurrencyCardView {
            SelectedDebitAccountIndex = (SelectedDebitAccountIndex + 1) % CurrencyAccountInfos.count
            CardConfiguration(index: SelectedDebitAccountIndex, index: SelectedReplenishmentIndex, card: card)
        }
        if card == DebitAccountCards.Preview_CurrencyCardView {
            SelectedReplenishmentIndex = (SelectedReplenishmentIndex + 1) % CurrencyAccountInfos.count
            CardConfiguration(index: SelectedReplenishmentIndex, index: SelectedDebitAccountIndex, card: card)
        }
    }
    
    func CardConfiguration(index From : Int, index To : Int, card : CurrencyCardView){
        let fromCurrency = CurrencyAccountInfos[From].Currency
        let toCurrency = CurrencyAccountInfos[To].Currency
        let selectedCurrencyAccountAmount = "Account amount: \(CurrencyAccountInfos[From].Currency)\(CurrencyAccountInfos[From].Amount)"
        let exchangeRate = exchangeRates.rate(from: CurrencyAccountInfos[From].Currency
            , to: CurrencyAccountInfos[To].Currency)
        let exchangeRateInfoString = "\(CurrancySymbols[fromCurrency]!)1 = \(CurrancySymbols[toCurrency]!)\(exchangeRate)"
        card.Configure(Currency: fromCurrency, SelectedCurrencyAccountAmount: selectedCurrencyAccountAmount, ExchangeRate: exchangeRateInfoString)
        
    }
    
    func testConfiguration(){
        SelectedDebitAccountIndex = 0
        SelectedReplenishmentIndex = 1
        CardConfiguration(index: 0, index: 1, card: DebitAccountCards.Selected_CurrencyCardView)
        CardConfiguration(index: 1, index: 0, card: ReplenishmentAccountCards.Selected_CurrencyCardView)
    }
}

