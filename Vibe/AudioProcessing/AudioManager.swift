//
//  AudioManager.swift
//  Vibe
//
//  Created by Tom Johnson on 30/05/2022.
//

import Foundation
import AVKit

class AudioManager {
    
    static let shared = AudioManager()
    var player: AVAudioPlayer?
    
    func startPlayer(track:String) {
        
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Resource not found: \(track)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            player?.play()
        }
        catch {
            print("Failed to initialise player", error)
        }
    }
    
}
