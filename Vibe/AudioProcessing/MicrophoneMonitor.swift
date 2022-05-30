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
    
    var soundSamples: [Float]
    var soundRanges: [Float]
    @Published var soundRangesWMem: [[Float]]
    
    init() {
        
        self.numberOfSamples = Constants.samplesInUse
        self.soundSamples = [Float](repeating: .zero, count: Constants.samplesInUse/2)
        self.soundRanges = [Float](repeating: .zero, count: 5)
        self.soundRangesWMem = [[Float]](repeating: ([Float](repeating: .zero, count: 8)), count: 5)
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
        
//        broadTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
//            floatPointer.initialize(from: &sampleHolder, count: Constants.samplesInUse)
//            self.soundSamples = SignalProcessing.fft(data: floatPointer, setup: fftSetup!)
//            self.orderSamples()
//        })
        
        fineTimer = Timer.scheduledTimer(withTimeInterval: 0.0005, repeats: true, block: { timer in
            
            self.audioRecorder!.updateMeters()
            
            sampleHolder[self.currentSample] = max(0.1, (self.audioRecorder!.peakPower(forChannel: 0) + 100))
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
            
            if self.currentSample == self.numberOfSamples - 1 {
                floatPointer.initialize(from: &sampleHolder, count: Constants.samplesInUse)
                self.soundSamples = SignalProcessing.fft(data: floatPointer, setup: fftSetup!)
                DispatchQueue.main.async {
                    self.orderSamples()
                }
            }
        })

    }
    
    private func orderSamples() {
        
        let splitArrays = splitArraySmall()
        
        for i in 0..<5 {
            self.soundRanges[i] = splitArrays[i].reduce(0, +)
            self.soundRangesWMem[i][self.sampleNumber % 8] = self.soundRanges[i]
        }
        
        self.sampleNumber += 1
    }
    
    private func splitArraySmall() -> [[Float]] {
        
        let firstSplit = Array(self.soundSamples[0..<Constants.rangeNums[0]])
        let secondSplit = Array(self.soundSamples[Constants.rangeNums[0]..<Constants.rangeNums[1]])
        let thirdSplit = Array(self.soundSamples[Constants.rangeNums[1]..<Constants.rangeNums[2]])
        let fourthSplit = Array(self.soundSamples[Constants.rangeNums[2]..<Constants.rangeNums[3]])
        let finalSplit = Array(self.soundSamples[Constants.rangeNums[3]..<Constants.rangeNums[4]])
        
        return [firstSplit, secondSplit, thirdSplit, fourthSplit, finalSplit]
    }
    
    deinit {
        fineTimer?.invalidate()
        broadTimer?.invalidate()
        audioRecorder!.stop()
    }
    
}
