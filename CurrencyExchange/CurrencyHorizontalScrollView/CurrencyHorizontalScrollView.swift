//
//  CurrencyHorizontalScrollView.swift
//  CurrencyExchange
//
//  Created by Admin on 03/05/2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencyHorizontalScrollViewDelegate {
    func PrevCardSelection(card : CurrencyCardView)
    func NextCardSelection(card : CurrencyCardView)
}

class CurrencyHorizontalScrollView : UIView {
    @IBOutlet weak var Preview_CurrencyCardView: CurrencyCardView!
    @IBOutlet weak var Selected_CurrencyCardView: CurrencyCardView!
    @IBOutlet weak var Next_CurrencyCardView: CurrencyCardView!
    var CurrencyCardViews : [CurrencyCardView] = []
    var selectedCurrencyCardIndex = 0
    var delegate : CurrencyHorizontalScrollViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Setup()
    }
    
    func Setup(){
        CurrencyCardViews = [Preview_CurrencyCardView, Selected_CurrencyCardView, Next_CurrencyCardView]
        selectedCurrencyCardIndex = 1
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        self.addGestureRecognizer(swipeGestureRecognizer)
        Bundle.main.loadNibNamed("CurrencyHorizontalScrollView", owner: self, options: nil)
    }
    
    @objc func handleSwipe(recognizer: UISwipeGestureRecognizer){
        if recognizer.direction == .left{
            delegate?.PrevCardSelection(card: Preview_CurrencyCardView)
            SwipeAnimation(leftNotRight: true)
        }
        if recognizer.direction == .right{
            delegate?.NextCardSelection(card: Next_CurrencyCardView)
            SwipeAnimation(leftNotRight: false)
        }
    }
    
    func SwipeAnimation(leftNotRight : Bool){
        
        //First animation part
        UIView.animate(withDuration: 1) {
            for card in self.CurrencyCardViews {
                card.frame.origin.x += 15
            }
        }
        
        //Magic
        Next_CurrencyCardView.frame.origin.x = Preview_CurrencyCardView.frame.origin.x - Next_CurrencyCardView.frame.width - 15
        
        //Second animation part
        UIView.animate(withDuration: 1) {
            for card in self.CurrencyCardViews {
                card.frame.origin.x += (card.frame.width - 15)
            }
        }
        
        let buffer: CurrencyCardView = Preview_CurrencyCardView
        Preview_CurrencyCardView = Next_CurrencyCardView
        Next_CurrencyCardView = Selected_CurrencyCardView
        Selected_CurrencyCardView = buffer
        
    }
}
