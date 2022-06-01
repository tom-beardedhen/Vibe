//
//  AudioKitView.swift
//  Vibe
//
//  Created by Tom Johnson on 01/06/2022.
//

import SwiftUI

struct AudioKitView: View {
    
    @StateObject var vm = Conductor()
    
    var body: some View {
        VStack {
            HStack {
                ForEach(vm.amplitudes, id: \.self) { i in
                    BarView(width: 10, height: CGFloat(i))
                }
            }
        }
    }
}

struct AudioKitView_Previews: PreviewProvider {
    static var previews: some View {
        AudioKitView()
    }
}
