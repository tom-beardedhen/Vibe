//
//  AudioVisualiserView.swift
//  Vibe
//
//  Created by Tom Johnson on 25/05/2022.
//

import SwiftUI

struct AudioVisualiserView: View {
    
    @ObservedObject var notneeded = MicrophoneMonitor(numberOfSamples: 10)
    @StateObject var model = AudioEngine()
    
    var body: some View {
        
        VStack {
            HStack {
                ForEach(model.frequencyVertices, id: \.self) { v in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.purple)
                        .frame(width: 2, height: CGFloat(v))
                }
            }
        }
    }
}

struct AudioVisualiserView_Previews: PreviewProvider {
    static var previews: some View {
        AudioVisualiserView()
    }
}
