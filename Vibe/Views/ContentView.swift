//
//  ContentView.swift
//  Vibe
//
//  Created by Tom Johnson on 24/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: Constants.numberOfSamples)
    
    private func soundLevel(level: Float) -> CGFloat {
        
        let level = max(0.2, CGFloat(level) + 50) / 2
        
        return CGFloat(level * 12 * 2)
    }
    
    var body: some View {
        
        VStack{
            
            HStack (spacing: 0.5) {
                ForEach(mic.soundSamples, id: \.self) { level in
                    
                    BarView(value: self.soundLevel(level: fabsf(level)))
                    
                }
            }
            
        }
        .padding(.horizontal)
    }
}


