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
        
        VStack (alignment: .leading) {
            
//            Text("\(mic.soundSamples.reduce(0,+)/1024)")
                
            Spacer()
            
            ForEach(0..<5, id: \.self) { i in
                
                HStack (spacing: 2) {
                    Text("\(ranges[i]): ")
                        .font(Font.system(size: 18))
//                    Text(String(Int(mic.soundRanges[i])))
//                        .font(Font.system(size: 18))
//                        .padding(.trailing, 10)
                    
                    ForEach(0..<10) { j in
                        BarView(value: CGFloat(mic.soundRangesWMem[i][j] * 2))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
                
        }
    }
}


