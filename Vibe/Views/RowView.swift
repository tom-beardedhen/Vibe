//
//  RowView.swift
//  Vibe
//
//  Created by Tom Johnson on 27/05/2022.
//

import SwiftUI

struct RowView: View {
    
    @StateObject private var mic = MicrophoneMonitor()
    
    var index: Int
    
    var body: some View {
        HStack (spacing: 2) {
            Text("\(Constants.rangeNames[index]): ")
                .font(Font.system(size: 18))
            
            Spacer()
            
            ForEach(0..<8) { j in
                BarView(value: CGFloat(mic.soundRangesWMem[index][j]))
            }
        }
    }
}
