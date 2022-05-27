//
//  RowView.swift
//  Vibe
//
//  Created by Tom Johnson on 27/05/2022.
//

import SwiftUI

struct RowView: View {
    
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: Constants.samplesInUse)
    
    let ranges = ["Bass", "Mid bass", "Mid-Range", "Treble", "Brilliance"]
    var index: Int
    
    var body: some View {
        HStack (spacing: 2) {
            Text("\(ranges[index]): ")
                .font(Font.system(size: 18))
            Text(String(Int(mic.soundRanges[index])))
                .font(Font.system(size: 18))
                .padding(.trailing, 10)
            
            ForEach(0..<10) { j in
                BarView(value: CGFloat(mic.soundRangesWMem[index][j] * 2))
            }
        }
    }
}
