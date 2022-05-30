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
            .frame(width: (UIScreen.main.bounds.width - 200) / CGFloat(10), height: value * 5)
    }
}

