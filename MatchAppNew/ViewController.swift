//
//  ViewController.swift
//  MatchAppNew
//
//  Created by Erdem Bakan on 20.05.2020.
//  Copyright © 2020 Erdem Bakan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    // To be able to keep track of if the user flipping over the first card or second, the property created below to detect it from the first card user has flipped. Value is optional because it will be nil at first.
    var firstFlippedCardIndex:IndexPath?
    
    var timer: Timer?
    var miliseconds:Float = 60 * 1000 // 60 seconds
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        
        // Set the view controller as the datasource and delegate of the collection view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerElapsed(){
        
        miliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", miliseconds/1000)
        
        // Set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // When the timer has reached 0...
        if miliseconds <= 0 {
            
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
        
    }

    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell // Treat the return object as cardcollectionview cell instead of uicollectionview
        
        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the card that it represents
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        // Finish configuring the cell
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Cell is tapped. No: \(indexPath.row)")
        
        // Check if there's any time left
        if miliseconds <= 0 {
            return
        }
        
        // Get a reference to the cell was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check to status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // Flip up the card
            cell?.flipUp()
            SoundManager.playSound(.flip)
            
            // Check if it's is the first or second card that was flipped
            if firstFlippedCardIndex == nil {
                
                firstFlippedCardIndex = indexPath
            }
            
            else {
                
                // Second card that is flipped
                
                // Run the comparison logic
                checkForMatch(indexPath)
            }
        }
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objects for the two indicies and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        
        // Compare two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            
            // Play sound
            SoundManager.playSound(.match)
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
        
        else {
            
            // It's not a match
            
            // Play sound
            SoundManager.playSound(.nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded(){
        
        // Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardsArray {
            
            if card.isMatched == false {
                
                isWon = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        // If not, then user has won, stop the timer
        if isWon == true {
            
            if miliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won"
        }
        
        else {
        // If there are unmatched cards, check if there's any time left
            if miliseconds > 0 {
                return
            }
            
            title = "Game over"
            message = "You've lost"
        }
        
        // Show won/lost messaging
        showAlert(title,message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}

