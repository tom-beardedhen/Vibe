//
//  PlayerView.swift
//  Vibe
//
//  Created by Tom Johnson on 31/05/2022.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var am = AudioManager()
    
    var body: some View {
        
        VStack {
            
            Button {
                am.startPlayer(track: "night_thunder")
                am.playing = true
            } label: {
                Text("night_thunder")
            }
            
            Spacer()
            
            Text("\(am.value)")
                .foregroundColor(.blue)
            
            if let player = am.player {
                Slider(value: $am.value, in: 0...player.duration) {
                    
                } minimumValueLabel: {
                    Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                        .foregroundColor(.blue)
                } maximumValueLabel: {
                    Text(DateComponentsFormatter.positional.string(from: player.duration - player.currentTime) ?? "1:00")
                        .foregroundColor(.blue)
                } onEditingChanged: { editing in
                    
                    am.isEditing = editing
                    
                    if !editing {
                        player.currentTime = am.value
                    }
                }

            }
            
            HStack (spacing: 20) {
                Button {
                    am.stop()
                } label: {
                    Image(systemName: "stop")
                        .font(.system(size: 28))
                        .offset(x: 0, y: 1)
                }
                
                Button {
                    am.player?.currentTime -= 10
                } label: {
                    Image(systemName: "gobackward.10")
                        .font(.system(size: 28))
                }
                
                Button {
                    am.playPause()
                    am.playing.toggle()
                } label: {
                    Image(systemName: am.playing ? "pause" : "play")
                        .font(.system(size: 36))
                }
                
                Button {
                    am.player?.currentTime += 10
                } label: {
                    Image(systemName: "goforward.10")
                        .font(.system(size: 28))
                }
                
                Button {
                    am.toggleLoop()
                } label: {
                    Image(systemName: "repeat")
                        .font(.system(size: 28))
                        .foregroundColor(am.isLooping ? .black : .blue)
                }
            }
            .padding()

        }
        .padding()
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
