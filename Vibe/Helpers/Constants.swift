//
//  Constants.swift
//  Vibe
//
//  Created by Tom Johnson on 24/05/2022.
//

import Foundation
import CoreData

struct Constants {
    static let samplesInUse = 256
    static let rangeNames = ["Bass", "Mid bass", "Mid-Range", "Treble", "Brilliance"]
    static let rangeNums = [1, 2, 16, 32, 128]
    static let memoryNum = 12
}

enum Hype: String {
    case ambient = "Ambient"
    case stored = "Stored"
    case streamed = "Streamed"
}
