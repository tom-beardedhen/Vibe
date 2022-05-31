//
//  RowView.swift
//  Vibe
//
//  Created by Tom Johnson on 27/05/2022.
//

import SwiftUI

struct RowView: View {
    
    var array: [[Float]]
    var index: Int
    
    var body: some View {
        HStack (spacing: 2) {
            ForEach(0..<Constants.memoryNum, id: \.self) { j in
                BarView(value: CGFloat(array[index][j]))
            }
        }
    }
}
