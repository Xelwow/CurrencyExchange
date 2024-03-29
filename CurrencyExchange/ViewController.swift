//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Admin on 01/05/2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CurrencyCardViewProtocol, CurrencyHorizontalScrollViewDelegate, UIAlertViewDelegate {
    @IBOutlet weak var ReplenishmentAccountCards : CurrencyHorizontalScrollView!
    @IBOutlet weak var DebitAccountCards : CurrencyHorizontalScrollView!
    @IBOutlet weak var ExchangeButton : UIButton!
    var timer : Timer!
    var Exchanger : CurrencyExchanger!
    var DebitExchangeSum : Double = 0
    var ReplenishmentExchangeSum : Double = 0
    override func viewDidAppear(_ animated: Bool) {
        DebitAccountCards.AdaptToScrinSize()
        ReplenishmentAccountCards.AdaptToScrinSize()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExchangeButton.layer.cornerRadius = 8
        //ExchangeButton.layer.borderWidth = 2
        //ExchangeButton.layer.borderColor = ExchangeButton.backgroundColor?.cgColor
        
        let CurrencyAccountInfos = [CurrencyAccountInfo(Amount: 100, Currency: "EUR"), CurrencyAccountInfo(Amount: 100, Currency: "USD"), CurrencyAccountInfo(Amount: 100, Currency: "GBP")]
        Exchanger = CurrencyExchanger(accounts: CurrencyAccountInfos)
        testConfiguration()
        ReplenishmentAccountCards.delegate = self
        ReplenishmentAccountCards.DelegateAllCards(to: self)
        ReplenishmentAccountCards.SetCardsColor(color: UIColor(red: 128.0 / 255.0, green: 255.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0))
        DebitAccountCards.delegate = self
        DebitAccountCards.DelegateAllCards(to: self)
        DebitAccountCards.SetCardsColor(color: UIColor(red: 48.0 / 255.0, green: 78.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0))
        
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (schedTimer) in
            self.Exchanger.UpdateRates {
                self.updateTextFields()
            }
        })
        
    }
    
    func ExchangeSumChanged(from Card: CurrencyCardView, sum: String){
        var converted : Double = 0
        if sum.first == "-" || sum.first == "+"{
            converted = Double(sum.dropFirst())!
        }
        else {
            if sum != "" {converted = Double(sum)!}
        }
        if Card == DebitAccountCards.Selected_CurrencyCardView {
            Exchanger.UpdateExchangeSum(sum: converted, debit: true)
            DebitExchangeSum = converted
            ReplenishmentExchangeSum = Exchanger.convertSum(sum: DebitExchangeSum, debit: true)
            updateTextFields()
            return
        }
        if Card == ReplenishmentAccountCards.Selected_CurrencyCardView {
            Exchanger.UpdateExchangeSum(sum: converted, debit: false)
            ReplenishmentExchangeSum = converted
            DebitExchangeSum = Exchanger.convertSum(sum: ReplenishmentExchangeSum, debit: false)
            updateTextFields()
            return
        }
    }
    
    func PrevCardSelection(sender : CurrencyHorizontalScrollView) {
        switch sender {
        case ReplenishmentAccountCards:
            Exchanger.PreviewAccount(debitNotReplenishment: false)
            let debitConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: true)
            let replenishmentConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: false)
            DebitAccountCards.Selected_CurrencyCardView.Configure(configInfo: debitConfiguration)
            ReplenishmentAccountCards.Preview_CurrencyCardView.Configure(configInfo: replenishmentConfiguration)
            break
        case DebitAccountCards:
            Exchanger.PreviewAccount(debitNotReplenishment: true)
            let debitConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: true)
            let replenishmentConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: false)
            DebitAccountCards.Preview_CurrencyCardView.Configure(configInfo: debitConfiguration)
            ReplenishmentAccountCards.Selected_CurrencyCardView.Configure(configInfo: replenishmentConfiguration)
            break
        default:
            break
        }
    }
    
    func NextCardSelection(sender : CurrencyHorizontalScrollView) {
        switch sender {
        case ReplenishmentAccountCards:
            Exchanger.NextAccount(debitNotReplenishment: false)
            let debitConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: true)
            let replenishmentConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: false)
            DebitAccountCards.Selected_CurrencyCardView.Configure(configInfo: debitConfiguration)
            ReplenishmentAccountCards.Next_CurrencyCardView.Configure(configInfo: replenishmentConfiguration)
            break
        case DebitAccountCards:
            Exchanger.NextAccount(debitNotReplenishment: true)
            let debitConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: true)
            let replenishmentConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: false)
            DebitAccountCards.Next_CurrencyCardView.Configure(configInfo: debitConfiguration)
            ReplenishmentAccountCards.Selected_CurrencyCardView.Configure(configInfo: replenishmentConfiguration)
            break
        default:
            break
        }
    }
    
    func updateTextFields(){
        let debitConfig = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: true)
        let replenishmentConfig = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: false)
        DebitAccountCards.Selected_CurrencyCardView.Configure(configInfo: debitConfig)
        ReplenishmentAccountCards.Selected_CurrencyCardView.Configure(configInfo: replenishmentConfig)
    }
    
    func testConfiguration(){
        let debitConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: true)
        let replenishmentConfiguration = Exchanger.CurrencyConfigurationInfo(debitToReplenishment: false)
        DebitAccountCards.Selected_CurrencyCardView.Configure(configInfo: debitConfiguration)
        ReplenishmentAccountCards.Selected_CurrencyCardView.Configure(configInfo: replenishmentConfiguration)
    }
    
    @IBAction func Exchange_Button_TouchUpInside(_ sender: Any) {
        let message = Exchanger.Exchange()
        let alert = UIAlertController(title: "Exchange", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.updateTextFields()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

