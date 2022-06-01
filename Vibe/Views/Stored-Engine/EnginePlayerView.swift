//
//  EnginePlayerView.swift
//  Vibe
//
//  Created by Tom Johnson on 31/05/2022.
//

import SwiftUI

struct EnginePlayerView: View {
    @StateObject var am = AudioEngineStr()
    
    @State var value: Double = 0.0
    @State var playing: Bool = false
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        
        VStack {
            
            BarView(width: 50, height: CGFloat(am.meterLevel * 30))
                .padding(50)
            
            Spacer()
            
            Text("\(value)")
                .foregroundColor(.blue)
            
            ProgressView(value: am.playerProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding(.bottom, 8)
            
            HStack {
              Text(am.playerTime.elapsedText)

              Spacer()

              Text(am.playerTime.remainingText)
            }
            .font(.system(size: 14, weight: .semibold))
            
            HStack (spacing: 20) {
                
                Button {
                    am.skip(forwards: false)
                } label: {
                    Image(systemName: "gobackward.10")
                        .font(.system(size: 28))
                }
                
                Button {
                    am.playOrPause()
                    playing.toggle()
                } label: {
                    Image(systemName: playing ? "pause" : "play")
                        .font(.system(size: 36))
                }
                
                Button {
                    am.skip(forwards: true)
                } label: {
                    Image(systemName: "goforward.10")
                        .font(.system(size: 28))
                }
            }
            .padding()

        }
        .padding()
    }
}

struct EnginePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        EnginePlayerView()
    }
}
