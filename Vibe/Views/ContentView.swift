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
        
//        VStack (alignment: .leading) {
//
////            HStack (spacing: 0.5) {
////                ForEach(mic.soundSamples, id: \.self) { level in
////
////                    BarView(value: self.soundLevel(level: fabsf(level)))
////
////                }
////            }
//
////            ScrollView(.horizontal) {
//
////                HStack (alignment: .bottom, spacing: 1) {
////
////                    ForEach(0..<128, id: \.self) { i in
////
////                        Rectangle()
////                            .foregroundColor(.blue)
////                            .frame(width: 2, height: self.soundLevel(level: mic.soundSamples[i % Constants.numberOfSamples]))
////
////                    }
////
////                }
//
////            }
////            .frame(height: 200)
//        }
//        .padding(.horizontal)
        
        ScrollView {
            LazyVStack {
                
//                ForEach(0..<512, id:\.self) { i in
//
////                    HStack {
////                        Text("\(mic.amplitudeTime[i][0])")
////
////                        Text("\(self.soundLevel(level: mic.amplitudeTime[i][1]))")
////                    }
//
//                    HStack {
//                        Text("\((i + 1) * 40) Hz")
//
//                        Text(String(mic.soundSamples[i]))
//                    }
//                }
                
                ForEach(0..<5, id: \.self) { i in
                    
                    HStack {
                        Text("Range:")
                        Text(String(mic.soundRanges[i]))
                    }
                    .padding()
                }
                
            }
        }
    }
}


