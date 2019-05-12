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
    func PrevCardSelection(sender : CurrencyHorizontalScrollView)
    func NextCardSelection(sender : CurrencyHorizontalScrollView)
}

class CurrencyHorizontalScrollView : UIView {
    @IBOutlet weak var Preview_CurrencyCardView: CurrencyCardView!
    @IBOutlet weak var Selected_CurrencyCardView: CurrencyCardView!
    @IBOutlet weak var Next_CurrencyCardView: CurrencyCardView!
    var CurrencyCardViews : [CurrencyCardView] = []
    var selectedCurrencyCardIndex = 0
    var delegate : CurrencyHorizontalScrollViewDelegate?
    
    var distanceToEndOfScreen : CGFloat = 17
    var distanceBetweenCards : CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Setup()
    }
    func AdaptToScrinSize(){
        let cardsWidth = self.frame.width - distanceToEndOfScreen * 2
        let cardsHeight = Selected_CurrencyCardView.frame.height
        let cardsY = Selected_CurrencyCardView.frame.origin.y
        Selected_CurrencyCardView.frame = CGRect(x: distanceToEndOfScreen, y: cardsY, width: cardsWidth, height: cardsHeight)
        Preview_CurrencyCardView.frame = CGRect(x: Selected_CurrencyCardView.frame.origin.x - cardsWidth - distanceBetweenCards, y: cardsY, width: cardsWidth, height: cardsHeight)
        Next_CurrencyCardView.frame = CGRect(x: Selected_CurrencyCardView.frame.origin.x + cardsWidth + distanceBetweenCards, y: cardsY, width: cardsWidth, height: cardsHeight)
    }
    
    func Setup(){
        Bundle.main.loadNibNamed("CurrencyHorizontalScrollView", owner: self, options: nil)
        
        
        self.addSubview(Preview_CurrencyCardView)
        self.addSubview(Selected_CurrencyCardView)
        self.addSubview(Next_CurrencyCardView)
        CurrencyCardViews = [Preview_CurrencyCardView, Selected_CurrencyCardView, Next_CurrencyCardView]
        selectedCurrencyCardIndex = 1
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        leftSwipeGestureRecognizer.direction = .left
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        self.addGestureRecognizer(leftSwipeGestureRecognizer)
        self.addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    @objc func handleSwipe(recognizer: UISwipeGestureRecognizer){
        switch recognizer.direction {
        case .right:
            delegate?.PrevCardSelection(sender: self)
            SwipeAnimation(rightNotLeft: true)
        case .left:
            delegate?.NextCardSelection(sender: self)
            SwipeAnimation(rightNotLeft: false)
        default:
            break
        }
    }
    
    func SwipeAnimation(rightNotLeft : Bool){
        //First animation part
        var firstStep : CGFloat = 0
        var secondStep : CGFloat = 0
        if rightNotLeft {
            firstStep = distanceToEndOfScreen
            secondStep = Selected_CurrencyCardView.frame.width + 8 - firstStep
        }
        else {
            firstStep = -distanceToEndOfScreen
            secondStep = -(Selected_CurrencyCardView.frame.width + 8 + firstStep)
        }
        UIView.animate(withDuration: 0.3) {
            for card in self.CurrencyCardViews {
                card.frame.origin.x += firstStep
            }
        }
        //Magic
        if rightNotLeft {
            Next_CurrencyCardView.frame.origin.x = Preview_CurrencyCardView.frame.origin.x - Next_CurrencyCardView.frame.width - distanceBetweenCards
        }
        else {
            Preview_CurrencyCardView.frame.origin.x = Next_CurrencyCardView.frame.origin.x + Preview_CurrencyCardView.frame.width + distanceBetweenCards
        }
        //Second animation part
        UIView.animate(withDuration: 0.3) {
            for card in self.CurrencyCardViews {
                card.frame.origin.x += secondStep
            }
        }
        if rightNotLeft {
            let buffer = Preview_CurrencyCardView
            Preview_CurrencyCardView = Next_CurrencyCardView
            Next_CurrencyCardView = Selected_CurrencyCardView
            Selected_CurrencyCardView = buffer
        }
        else {
            let buffer = Next_CurrencyCardView
            Next_CurrencyCardView = Preview_CurrencyCardView
            Preview_CurrencyCardView = Selected_CurrencyCardView
            Selected_CurrencyCardView = buffer
        }
    }
    
    func DelegateAllCards(to viewController: ViewController){
        for card in CurrencyCardViews {
            card.delegate = viewController
        }
    }
}
