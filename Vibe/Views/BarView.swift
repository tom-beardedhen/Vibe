//
//  BarView.swift
//  Vibe
//
//  Created by Tom Johnson on 24/05/2022.
//

import SwiftUI

struct BarView: View {
    
    var value: CGFloat
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 5)
            .fill(.purple)
            .frame(width: (UIScreen.main.bounds.width - CGFloat(Constants.numberOfSamples)) / CGFloat(Constants.numberOfSamples), height: value)
    }
}

