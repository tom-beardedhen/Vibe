//
//  MicrophoneMonitor.swift
//  Vibe
//
//  Created by Tom Johnson on 24/05/2022.
//

import Foundation
import AVFoundation
import Accelerate

class MicrophoneMonitor: ObservableObject {
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    private var currentSample: Int
    private var numberOfSamples: Int
    
    @Published var soundSamples: [Float]
    
    init(numberOfSamples: Int) {
        
        self.numberOfSamples = numberOfSamples
        self.soundSamples = [Float](repeating: .zero, count: Constants.numberOfSamples)
        self.currentSample = 0
        
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { isGranted in
                if !isGranted {
                    print("You must allow permission")
                }
            }
        }
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [])
            
            startMonitoring()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    private func startMonitoring() {
        audioRecorder!.isMeteringEnabled = true
        audioRecorder!.record()
        var sampleHolder = [Float](repeating: .zero, count: Constants.numberOfSamples)
        timer = Timer.scheduledTimer(withTimeInterval: Double(1/Constants.numberOfSamples), repeats: true, block: { timer in
            self.audioRecorder!.updateMeters()
            sampleHolder[self.currentSample] = self.audioRecorder!.averagePower(forChannel: 0)
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })
        
        let fftSetup = vDSP_DFT_zop_CreateSetup(nil, 1024, vDSP_DFT_Direction.FORWARD)
        
        let floatPointer = UnsafeMutablePointer<Float>.allocate(capacity: 1024)
        floatPointer.initialize(from: &sampleHolder, count: 1024)
        
        self.soundSamples = SignalProcessing.fft(data: floatPointer, setup: fftSetup!)
        
    }
    
    deinit {
        timer?.invalidate()
        audioRecorder!.stop()
    }
    
}
