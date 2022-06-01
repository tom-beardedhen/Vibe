//
//  AudioManager.swift
//  Vibe
//
//  Created by Tom Johnson on 30/05/2022.
//

import Foundation
import AVKit

// Good for playing and user experience, can use with microphone monitor, but won't be able to get info from it unlike engine
class AudioManager: ObservableObject {
    
    @Published var value: Double = 0.0
    
    @Published var isLooping: Bool = false
    @Published var playing: Bool = false
    @Published var isEditing: Bool = false
    
    var timer: Timer?
    
    static let shared = AudioManager()
    var player: AVAudioPlayer?
    
    func startPlayer(track:String) {
        
        // Get url for stored strack
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Resource not found: \(track)")
            return
        }
        
        do {
            // Create audiPlayer and start playing
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
            // Create timer to update the slider and time stamps periodically
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                guard let player = self.player, !self.isEditing else {
                    return
                }
                self.value = player.currentTime
            })
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

        // Option to loop track, -1 loops tracks indefinitely
        player.numberOfLoops = player.numberOfLoops == 0 ? -1 : 0
        self.isLooping.toggle()
    }
    
}
