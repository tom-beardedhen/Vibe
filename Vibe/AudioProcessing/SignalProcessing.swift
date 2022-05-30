//
//  SignalProcessing.swift
//  Vibe
//
//  Created by Tom Johnson on 25/05/2022.
//

import Foundation
import Accelerate

class SignalProcessing {
    
    // Fourier transform to get frequency bins
    static func fft(data: UnsafeMutablePointer<Float>, setup: OpaquePointer) -> [Float] {
        // Output setup
        var realIn = [Float](repeating: 0, count: 256)
        var imagIn = [Float](repeating: 0, count: 256)
        var realOut = [Float](repeating: 0, count: 256)
        var imagOut = [Float](repeating: 0, count: 256)
        
        // Fill in real input part with audio samples
        for i in 0..<256 {
            realIn[i] = data[i]
        }
        
        vDSP_DFT_Execute(setup, &realIn, &imagIn, &realOut, &imagOut)

        // Results are now inside realOut and imagOut
        
        // Package it inside a complex vector representation used in the vDSP framework
        var complex = DSPSplitComplex(realp: &realOut, imagp: &imagOut)
        
        // Setup magnitude output
        var magnitudes = [Float](repeating: 0, count: 128)
        
        // Calculate magnitude results
        vDSP_zvabs(&complex, 1, &magnitudes, 1, 128)
        
        // Normalize using a scaling factor
        var normalizedMagnitudes = [Float](repeating: 0.0, count: 128)
        var scalingFactor = Float(5.0/128)
        vDSP_vsmul(&magnitudes, 1, &scalingFactor, &normalizedMagnitudes, 1, 128)
        
        return normalizedMagnitudes
    }
    
}
