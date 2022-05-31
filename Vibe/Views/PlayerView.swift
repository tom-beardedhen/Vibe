//
//  PlayerView.swift
//  Vibe
//
//  Created by Tom Johnson on 31/05/2022.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var am = AudioManager()
    
    @State var value: Double = 0.0
    @State var playing: Bool = false
    
    @State private var isEditing: Bool = false
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        
        VStack {
            
            Button {
                am.startPlayer(track: "night_thunder")
                playing = true
            } label: {
                Text("night_thunder")
            }
            
            Spacer()
            
            Text("\(value)")
                .foregroundColor(.blue)
            
            if let player = am.player {
                Slider(value: $value, in: 0...player.duration) {
                    
                } minimumValueLabel: {
                    Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                        .foregroundColor(.blue)
                } maximumValueLabel: {
                    Text(DateComponentsFormatter.positional.string(from: player.duration - player.currentTime) ?? "1:00")
                        .foregroundColor(.blue)
                } onEditingChanged: { editing in
                    
                    isEditing = editing
                    
                    if !editing {
                        player.currentTime = value
                    }
                }

            }
            
            HStack (spacing: 20) {
                Button {
                    am.stop()
                } label: {
                    Image(systemName: "stop")
                        .font(.system(size: 28))
                }
                
                Button {
                    am.player?.currentTime -= 10
                } label: {
                    Image(systemName: "gobackward.10")
                        .font(.system(size: 28))
                }
                
                Button {
                    am.playPause()
                    playing.toggle()
                } label: {
                    Image(systemName: playing ? "pause" : "play")
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
        .onReceive(timer) { _ in
            guard let player = am.player, !isEditing else {
                return
            }
            value = player.currentTime
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
