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
        self.soundRangesWMem = [[Float]](repeating: ([Float](repeating: .zero, count: Constants.memoryNum)), count: 5)
        self.currentSample = 0
        self.sampleNumber = 0
        
        // Create instance of audio session and check microphone permission
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { isGranted in
                if !isGranted {
                    print("You must allow permission")
                }
            }
        }
        
        // Create a file to momentarily store audio recordings
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        
        // Set recorder settings
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        // Create recorder
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
        
        // Set up for FFT
        let fftSetup = vDSP_DFT_zop_CreateSetup(nil, vDSP_Length(Constants.samplesInUse), vDSP_DFT_Direction.FORWARD)
        let floatPointer = UnsafeMutablePointer<Float>.allocate(capacity: Constants.samplesInUse)
        
        // Start recording
        audioRecorder!.isMeteringEnabled = true
        audioRecorder!.record()
        
        // Create a holder for new samples
        var sampleHolder = [Float](repeating: .zero, count: Constants.samplesInUse)
        
        // Create timer
        fineTimer = Timer.scheduledTimer(withTimeInterval: 0.0005, repeats: true, block: { timer in
            
            self.audioRecorder!.updateMeters()
            
            // Get power of audio at current time interval
            sampleHolder[self.currentSample] = max(0.1, (self.audioRecorder!.averagePower(forChannel: 0) + 50))
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
            
            // Every 1/4 of second call FFT function to get frequency bins
            if self.currentSample == self.numberOfSamples - 1 {
                floatPointer.initialize(from: &sampleHolder, count: Constants.samplesInUse)
                self.soundSamples = SignalProcessing.fft(data: floatPointer, setup: fftSetup!)
                
                // Updating UI on main thread
                DispatchQueue.main.async {
                    self.orderSamples()
                }
            }
        })

    }
    
    // Set the power of each bin, keeping a backlog of 7 
    private func orderSamples() {
        
        let splitArrays = splitArraySmall()
        
        for i in 0..<5 {
            self.soundRanges[i] = splitArrays[i].reduce(0, +)
            self.soundRangesWMem[i][self.sampleNumber % Constants.memoryNum] = self.soundRanges[i]
        }
        
//        print(soundRanges)
        
        self.sampleNumber += 1
    }
    
    // Split frequency bins into the desired ranges
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
