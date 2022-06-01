//
//  BarView.swift
//  Vibe
//
//  Created by Tom Johnson on 24/05/2022.
//

import SwiftUI

struct BarView: View {
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 5)
            .fill(.purple)
            .frame(width: width, height: height)
    }
}

