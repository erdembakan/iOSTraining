//
//  SoundManager.swift
//  MatchAppNew
//
//  Created by Erdem Bakan on 29.06.2020.
//  Copyright © 2020 Erdem Bakan. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
   static var audioPlayer : AVAudioPlayer?
    
    enum SoundEffect {
        case flip,shuffle,match,nomatch
    }
    
  static func playSound(_ effect:SoundEffect) {
        
        var soundFileName = ""
        
        // Determine which sound effect we want to play
        // And set the appropriate file name
        
        switch effect {
        case .flip:
            soundFileName = "cardflip"
            
        case .match:
            soundFileName = "dingcorrect"
            
        case .nomatch:
            soundFileName = "dingwrong"
            
        case .shuffle:
            soundFileName = "shuffle"
        }
        
        // Get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Could not find the sound file \(soundFileName) in the bundle")
            return
        }
        
        // Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create an audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play the sound
            audioPlayer?.play()
        }

        catch {
            // Couldn't create the audioPlayer object, log the error
            print("Couldn't create the audioPlayer object sound file \(soundFileName)")
        }
        
    }
}
