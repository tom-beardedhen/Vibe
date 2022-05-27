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
    private var fineTimer: Timer?
    private var broadTimer: Timer?
    
    private var currentSample: Int
    private var numberOfSamples: Int
    private var sampleNumber: Int
    
    @Published var soundSamples: [Float]
    @Published var soundRanges: [Float]
    @Published var soundRangesWMem: [[Float]]
    
    init(numberOfSamples: Int) {
        
        self.numberOfSamples = numberOfSamples
        self.soundSamples = [Float](repeating: .zero, count: Constants.samplesInUse/2)
        self.soundRanges = [Float](repeating: .zero, count: 5)
        self.soundRangesWMem = [[Float]](repeating: ([Float](repeating: .zero, count: 10)), count: 5)
        self.currentSample = 0
        self.sampleNumber = 0
        
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
        
        let fftSetup = vDSP_DFT_zop_CreateSetup(nil, vDSP_Length(Constants.samplesInUse), vDSP_DFT_Direction.FORWARD)
        let floatPointer = UnsafeMutablePointer<Float>.allocate(capacity: Constants.samplesInUse)
        
        audioRecorder!.isMeteringEnabled = true
        audioRecorder!.record()
        
        var sampleHolder = [Float](repeating: .zero, count: Constants.samplesInUse)
        
        broadTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            floatPointer.initialize(from: &sampleHolder, count: Constants.samplesInUse)
            self.soundSamples = SignalProcessing.fft(data: floatPointer, setup: fftSetup!)
            self.orderSamples()
            print(sampleHolder[100])
        })
        
        fineTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1/Constants.samplesInUse), repeats: true, block: { timer in
            
            self.audioRecorder!.updateMeters()
            
            sampleHolder[self.currentSample] = max(0.1, (self.audioRecorder!.averagePower(forChannel: 0) + 50)) * 2
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })

    }
    
    private func orderSamples() {
        
        let splitArrays = splitArraySmall()
        
        self.soundRanges[0] = splitArrays[0].reduce(0, +)
        self.soundRanges[1] = splitArrays[1].reduce(0, +)
        self.soundRanges[2] = splitArrays[2].reduce(0, +)
        self.soundRanges[3] = splitArrays[3].reduce(0, +)
        self.soundRanges[4] = splitArrays[4].reduce(0, +)
        
        self.soundRangesWMem[0][self.sampleNumber % 10] = self.soundRanges[0]
        self.soundRangesWMem[1][self.sampleNumber % 10] = self.soundRanges[1]
        self.soundRangesWMem[2][self.sampleNumber % 10] = self.soundRanges[2]
        self.soundRangesWMem[3][self.sampleNumber % 10] = self.soundRanges[3]
        self.soundRangesWMem[4][self.sampleNumber % 10] = self.soundRanges[4]
        
        self.sampleNumber += 1
        
    }
    
    private func splitArray() -> [[Float]] {
        
        let firstSplit = Array(self.soundSamples[0..<4])
        let secondSplit = Array(self.soundSamples[4..<8])
        let thirdSplit = Array(self.soundSamples[8..<60])
        let fourthSplit = Array(self.soundSamples[60..<120])
        let finalSplit = Array(self.soundSamples[120..<512])
        
        return [firstSplit, secondSplit, thirdSplit, fourthSplit, finalSplit]
    }
    
    private func splitArraySmall() -> [[Float]] {
        
        let firstSplit = Array(self.soundSamples[0..<1])
        let secondSplit = Array(self.soundSamples[1..<2])
        let thirdSplit = Array(self.soundSamples[2..<16])
        let fourthSplit = Array(self.soundSamples[16..<32])
        let finalSplit = Array(self.soundSamples[33..<128])
        
        return [firstSplit, secondSplit, thirdSplit, fourthSplit, finalSplit]
    }
    
    deinit {
        fineTimer?.invalidate()
        broadTimer?.invalidate()
        audioRecorder!.stop()
    }
    
}
