//
//  ContentView.swift
//  Vibe
//
//  Created by Tom Johnson on 24/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: Constants.numberOfSamples)
    
    let ranges = ["Bass", "Mid bass", "Mid-Range", "Treble", "Brilliance"]
    
    var body: some View {
        
        VStack {
                
            Spacer()
            
            ForEach(0..<5, id: \.self) { i in
                
                HStack {
                    Text("\(ranges[i]): ")
//                    Text(String(mic.soundRanges[i]))
                    Text(String(Int(mic.soundRanges[i])))
                    
                    BarView(value: CGFloat(mic.soundRanges[i] / 10))
                }
                .padding(.horizontal)
                
                Spacer()
            }
                
        }
    }
}


