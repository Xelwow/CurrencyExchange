//
//  CurrencyCardPresenter.swift
//  CurrencyExchange
//
//  Created by Admin on 04/05/2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencyCardPresenterProtocol {
    var router : CurrencyCardRouterProtocol! { get set }
    func configureView()
    func exchangeSumTextField(textField : UITextField, Sum : String)
}
