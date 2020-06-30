//
//  CardCollectionViewCell.swift
//  MatchAppNew
//
//  Created by Erdem Bakan on 20.05.2020.
//  Copyright © 2020 Erdem Bakan. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var FronImageView: UIImageView!
    
    @IBOutlet weak var BackImageView: UIImageView!
    
    
    var card:Card?
    
    func configureCell (card:Card) {
        
        // Keep track of the card that this cell represents
        self.card = card
        
        // Set the front image view to the image that represents the card
        FronImageView.image = UIImage(named: card.imageName)
        
        // Reset the state of the cell by checking the flipped status of the card and then showing the front or the back imageview accordingly
        
        if card.isMatched == true {
            
            // if cards are matched, make them invisible
            BackImageView.alpha = 0
            FronImageView.alpha = 0
            
            return
        }
        
        else {
            
            BackImageView.alpha = 1
            FronImageView.alpha = 1
        }
    
        
        if card.isFlipped == true {
            
            // Show the front image view
            flipUp(speed: 0)
            
        }
        
        else {
            // Show the back image view
            flipDown(speed: 0, delay: 0)
        }
    }
    
    // Flip up animation
    func flipUp(speed:TimeInterval = 0.3) {
        
        UIView.transition(from: BackImageView, to: FronImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        
        // Set isFlipped parameter as 'true'
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        
        
        // Adding delay if the cards won't matched
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            // Flip down animation
            UIView.transition(from: self.FronImageView, to: self.BackImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        }
        
        // Set isFlipped parameter as 'false'
        card?.isFlipped = false
    }
    
    func remove() {
        
        // Make the image invisible
        BackImageView.alpha = 0
        
        // Putting delay to the animation bec we don't want to matched card vanished too quickly
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.FronImageView.alpha = 0
            
        }, completion: nil)
        
    }
    
}

