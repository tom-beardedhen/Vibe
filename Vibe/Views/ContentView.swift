//
//  ContentView.swift
//  Vibe
//
//  Created by Tom Johnson on 24/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 30) {
            
            ForEach(0..<5, id: \.self) { i in
                RowView(index: i)
                    .frame(height: i == 0 ? 150 : 100)
            }
            .padding(.horizontal)
                
        }
    }
}


