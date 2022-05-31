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
        }
    }
}


