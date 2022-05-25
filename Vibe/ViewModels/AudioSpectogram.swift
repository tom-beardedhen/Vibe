//
//  AudioSpectogram.swift
//  Vibe
//
//  Created by Tom Johnson on 25/05/2022.
//

import AVFoundation
import Accelerate

public class AudioSpectagram: CALayer {
    
    static let sampleCount = 1024
    
    static let bufferCount = 768
    
    static let hopCount = 512
    
    let captureSession = AVCaptureSession()
    let audioOutput = AVCaptureAudioDataOutput()
    
    let captureQueue = DispatchQueue(label: "capturQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    let sessiosnQueue = DispatchQueue(label: "sessionQueue", qos: .userInitiated, attributes: [])
    
    let forwardDCT = vDSP.DCT(count: sampleCount, transformType: .II)
    
    let hanningWindow = vDSP.window(ofType: Float.self, usingSequence: .hanningDenormalized, count: sampleCount, isHalfWindow: false)
    
    let dispatchSemaphore = DispatchSemaphore(value: 1)
    
    var timeDomainBuffer = [Float](repeating: 0, count: sampleCount)
    
    var frequencyDomainBuffer = [Float](repeating: 0, count: sampleCount)
    
    func processData(values: [Int]) {
        
        dispatchSemaphore.wait()
        
//        vDSP.convertElements(of: values, to: &timeDomainBuffer)
        
        vDSP.multiply(timeDomainBuffer, hanningWindow, result: &timeDomainBuffer)
        
        forwardDCT?.transform(timeDomainBuffer, result: &frequencyDomainBuffer)
        
        
        
    }
    
}
