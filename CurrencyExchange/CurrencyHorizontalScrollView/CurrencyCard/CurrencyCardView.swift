//
//  CurrencyCard.swift
//  CurrencyExchange
//
//  Created by Admin on 03/05/2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencyCardViewProtocol {
    func ExchangeSumChanged(from Card: CurrencyCardView, sum : String)
}

class CurrencyCardView : UIView, UITextFieldDelegate {
    @IBOutlet weak var Currency_Label: UILabel!
    @IBOutlet weak var ExchangeSum_TextField: UITextField!
    @IBOutlet weak var SelectedCurrencyAccountAmount_Label: UILabel!
    @IBOutlet weak var ExchangeRate_Label: UILabel!
    //@IBOutlet var view: UIView!
    
    var delegate : CurrencyCardViewProtocol?
    var lastExchangeSumText = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CurrencyCardView.", owner: self, options: nil)
        print("A")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("CurrencyCardView", owner: self, options: nil)
        self.addSubview(Currency_Label)
        self.addSubview(ExchangeSum_TextField)
        self.addSubview(SelectedCurrencyAccountAmount_Label)
        self.addSubview(ExchangeRate_Label)
        self.layer.cornerRadius = 10
        ExchangeSum_TextField.delegate = self
        print("B")
    }
    @IBAction func ExchangeSum_TextField_EditingChanged(_ sender: Any) {
        //print(ExchangeSum_TextField.text!)
        var text = ExchangeSum_TextField.text!
        //print(text)
        
        var shouldChangeCursorPosition = false
        if text.contains("-") && text.first != "-" || text.contains("+") && text.first != "+" {
            ExchangeSum_TextField.text = lastExchangeSumText
        }
        else {
            if text.first == "+" || text.first == "-" {
                text = String(text.dropFirst())
                if text.first == "." || text.last == "."{
                    if text.first == "."{
                        ExchangeSum_TextField.text = nil
                    }
                    else {
                        ExchangeSum_TextField.text = text + "0"
                        let newPosition = ExchangeSum_TextField.position(from: ExchangeSum_TextField.endOfDocument, offset: -2)
                        ExchangeSum_TextField.selectedTextRange = ExchangeSum_TextField.textRange(from: newPosition!, to: newPosition!)
                    }
                }
                else {
                    var range = NSRange(location: 0, length: text.utf16.count)
                    let doubleRegex = try! NSRegularExpression(pattern: "^[0-9]{1,7}[.][0-9]{1,2}$", options: [])
                    if doubleRegex.firstMatch(in: text, options: [], range: range) == nil {
                        text = String(text.dropLast())
                        range = NSRange(location: 0, length: text.utf16.count)
                        if doubleRegex.firstMatch(in: text, options: [], range: range) == nil {
                            ExchangeSum_TextField.text = lastExchangeSumText
                        }
                        else {
                            ExchangeSum_TextField.text = text
                        }
                    }
                }
            }
            else {
                let numbersRegEx = try! NSRegularExpression(pattern: "^[0-9]$", options: [])
                let range = NSRange(location: 0, length: text.utf16.count)
                if (numbersRegEx.firstMatch(in: text, options: [], range: range) != nil) {
                    shouldChangeCursorPosition = true
                }
                else {
                    ExchangeSum_TextField.text = ""
                }
                
            }
        }
        
        if delegate == nil  {return}
        delegate!.ExchangeSumChanged(from: self, sum: ExchangeSum_TextField.text!)
        if ExchangeSum_TextField.text == "" {return}
        if shouldChangeCursorPosition {
            let newPosition = ExchangeSum_TextField.position(from: ExchangeSum_TextField.beginningOfDocument, offset: 2)
            ExchangeSum_TextField.selectedTextRange = ExchangeSum_TextField.textRange(from: newPosition!, to: newPosition!)
        }
        lastExchangeSumText = ExchangeSum_TextField.text!
        
    }
    func Configure(Currency : String, SelectedCurrencyAccountAmount : String, ExchangeRate : String ){
        Currency_Label.text = Currency
        SelectedCurrencyAccountAmount_Label.text = SelectedCurrencyAccountAmount
        ExchangeRate_Label.text = ExchangeRate
        
    }
    func Configure(configInfo : ConfigurationInfo){
        Currency_Label.text = configInfo.currency
        SelectedCurrencyAccountAmount_Label.text = configInfo.selectedCurrencyAccountAmount
        ExchangeRate_Label.text = configInfo.exchangeRate
        ExchangeSum_TextField.text = configInfo.exchangeAmount
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(",")  {
            let text = ExchangeSum_TextField.text!
            let distance = text.distance(from: text.firstIndex(of: text.first!)! , to: text.firstIndex(of: ".")!)
            let currentPosition = ExchangeSum_TextField.offset(from: ExchangeSum_TextField.beginningOfDocument, to: ExchangeSum_TextField.selectedTextRange!.start)
            let toDecimals = currentPosition > distance ? false : true
            let offset = toDecimals ? -(text.count  - distance - 1) : distance
            let from = toDecimals ? ExchangeSum_TextField.endOfDocument : ExchangeSum_TextField.beginningOfDocument
            let newPosition = ExchangeSum_TextField.position(from: from, offset: offset)
            ExchangeSum_TextField.selectedTextRange = ExchangeSum_TextField.textRange(from: newPosition!, to: newPosition!)
            return false
        }
        return true
    }
    
}

