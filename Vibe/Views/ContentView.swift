//
//  ContentView.swift
//  Vibe
//
//  Created by Tom Johnson on 24/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var mic = MicrophoneMonitor()
    
    var body: some View {
        
        ZStack {
        
            VStack (spacing: 30) {
                
                ForEach(0..<5, id: \.self) { i in
                    RowView(array: mic.soundRangesWMem, index: i)
                        .frame(height: i == 0 ? 150 : 100)
                }
                .padding(.horizontal)
                    
            }
            
//            VStack{
//                HStack {
//                    Button {
//                        mic.type = .stored
//                    } label: {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .foregroundColor(.purple)
//                                .opacity(0.8)
//                                .frame(width: 100, height: 50)
//
//                            Text(Hype.ambient.rawValue)
//                                .foregroundColor(.white)
//                                .bold()
//                        }
//                    }
//                    .padding()
//                    Spacer()
//                }
//                Spacer()
//            }
        }
        .task {
            AudioManager.shared.startPlayer(track: "night_thunder")
        }
    }
}


