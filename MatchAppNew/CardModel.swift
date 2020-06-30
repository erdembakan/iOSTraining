//
//  CardModel.swift
//  MatchAppNew
//
//  Created by Erdem Bakan on 20.05.2020.
//  Copyright © 2020 Erdem Bakan. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards () -> [Card] {
        
        // Declare an empty array to store numbers that we've generated
        var generatedNumbers = [Int]()
        
        // Declare an empty array.
        var generatedCards = [Card]()

        // Randomly generate 8 pairs of cards
        while generatedNumbers.count < 8 {
            
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            // Make sure randomNumber doesn't contain duplicate numbers
            if generatedNumbers.contains(randomNumber) == false {
                generatedNumbers.append(randomNumber)
                
                                
                        // Generate two new card objects
                        let cardOne = Card()
                        let cardTwo = Card()
                           
                           
                        // Set their image names
                        cardOne.imageName = "card\(randomNumber)"
                        cardTwo.imageName = "card\(randomNumber)"
                                
                        // Add them to the array
                        generatedCards += [cardOne,cardTwo]
                
                        print("generatedNumber is \(randomNumber)")
            }
        }
        
        // Randomize the cards within the array.
        generatedCards.shuffle()
        
        print(generatedCards.count) // Logging
        
       // TODO: Randomize the array
        
        // Return the array.
        return generatedCards
    }
}
