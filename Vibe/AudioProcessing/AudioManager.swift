//
//  AudioManager.swift
//  Vibe
//
//  Created by Tom Johnson on 30/05/2022.
//

import Foundation
import AVKit

class AudioManager: ObservableObject {
    
    @Published var isLooping: Bool = true
    
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
    
    func playPause() {
        
        guard let player = player else {
            return
        }
        
        if player.isPlaying {
            player.pause()
        }
        else {
            player.play()
        }
    }
    
    func stop() {
        guard let player = player else {
            return
        }

        if player.isPlaying {
            player.stop()
        }
    }
    
    func toggleLoop() {
        guard let player = player else {
            return
        }

        player.numberOfLoops = player.numberOfLoops == 0 ? -1 : 0
        self.isLooping.toggle()
    }
    
}
