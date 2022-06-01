//
//  Extensions.swift
//  Vibe
//
//  Created by Tom Johnson on 31/05/2022.
//

import Foundation

// Formatting for time stamps on PlayerView
extension DateComponentsFormatter {
    
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }()
    
}
