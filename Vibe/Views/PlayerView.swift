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
                    Text("0:00")
                        .foregroundColor(.blue)
                } maximumValueLabel: {
                    Text("1:00")
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
                    
                } label: {
                    Image(systemName: "backward")
                        .font(.system(size: 28))
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "gobackward.10")
                        .font(.system(size: 28))
                }
                
                Button {
                    playing.toggle()
                } label: {
                    Image(systemName: playing ? "pause" : "play")
                        .font(.system(size: 36))
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "goforward.10")
                        .font(.system(size: 28))
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "forward")
                        .font(.system(size: 28))
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
