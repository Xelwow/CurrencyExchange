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
    func ExchangeSumChanged(from Card: CurrencyCardView, sum : String) -> String
}

class CurrencyCardView : UIView {
    @IBOutlet weak var Currency_Label: UILabel!
    @IBOutlet weak var ExchangeSum_TextField: UITextField!
    @IBOutlet weak var SelectedCurrencyAccountAmount_Label: UILabel!
    @IBOutlet weak var ExchangeRate_Label: UILabel!
    
    var delegate : CurrencyCardViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CurrencyCardView", owner: self, options: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("CurrencyCardView", owner: self, options: nil)
    }
    @IBAction func ExchangeSum_TextField_EditingChanged(_ sender: Any) {
        if delegate == nil  {return}
        ExchangeSum_TextField.text = delegate!.ExchangeSumChanged(from: self, sum: ExchangeSum_TextField.text!)
    }
    func Configure(Currency : String, SelectedCurrencyAccountAmount : String, ExchangeRate : String ){
        Currency_Label.text = Currency
        SelectedCurrencyAccountAmount_Label.text = SelectedCurrencyAccountAmount
        ExchangeRate_Label.text = ExchangeRate
    }
}

