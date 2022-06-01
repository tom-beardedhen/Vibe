//
//  Scraps.swift
//  Vibe
//
//  Created by Tom Johnson on 27/05/2022.
//

import SwiftUI
import MediaPlayer

// Just all the unused code that ive torn out and replaced, incase i needed it again 
class Scraps {
    
    // MARK: Audio Engine
//    @Published var frequencyVertices: [Float] = [Float](repeating: 0, count: 361)
    
//    var engine: AVAudioEngine!
    
//    init() {
//        setUpAudio()
//    }
    
//    func setUpAudio() {
//
//        engine = AVAudioEngine()
//
//        _ = engine.mainMixerNode
//
//        engine.prepare()
//        do {
//            try engine.start()
//        }
//        catch {
//            print(error)
//        }
//
//        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
//
//        let player = AVAudioPlayerNode()
//
//        do {
//            let audioFile = try AVAudioFile(forReading: url)
//
//            let format = audioFile.processingFormat
//            print(format)
//
//            engine.attach(player)
//            engine.connect(player, to: engine.mainMixerNode, format: format)
//
//            player.scheduleFile(audioFile, at: nil, completionHandler: nil)
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//
////        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, time in
////            self.processAudioData(buffer: buffer)
//        }
        
//        player.play()
        
//    }
    
//    var prevRMSValue: Float = 0.3
    
//    let fftSetup = vDSP_DFT_zop_CreateSetup(nil, 1024, vDSP_DFT_Direction.FORWARD)
    
//    func processAudioData(buffer: AVAudioPCMBuffer) {
//        guard let channelData = buffer.floatChannelData?[0] else {return}
//        let frames = buffer.frameLength
        
        //rms
//        let rmsValue = SignalProcessing.rms(data: channelData, frameLength: UInt(frames))
//        let interpolatedResults = SignalProcessing.interpolate(current: rmsValue, previous: prevRMSValue)
//        prevRMSValue = rmsValue
        
        //pass values to the audiovisualizer for the rendering
//        for rms in interpolatedResults {
//            audioVisualizer.loudnessMagnitude = rms
//        }
        
        //fft
//        let fftMagnitudes =  SignalProcessing.fft(data: channelData, setup: fftSetup!)
//        self.frequencyVertices = fftMagnitudes
//    }
    
    // MARK: rms
    
//    static func rms(data: UnsafeMutablePointer<Float>, frameLength: UInt) -> Float {
//        var val : Float = 0
////        vDSP_measqv(data, 1, &val, frameLength)
//
//        var db = 10*log10f(val)
//        //inverse dB to +ve range where 0(silent) -> 160(loudest)
//        db = 160 + db;
//        //Only take into account range from 120->160, so FSR = 40
//        db = db - 120
//
//        let dividor = Float(40/0.3)
//        var adjustedVal = 0.3 + db/dividor
//
//        //cutoff
//        if (adjustedVal < 0.3) {
//            adjustedVal = 0.3
//        } else if (adjustedVal > 0.6) {
//            adjustedVal = 0.6
//        }
//
//        return adjustedVal
//    }
    
    //MARK: interpolate
    
//    static func interpolate(current: Float, previous: Float) -> [Float]{
//        var vals = [Float](repeating: 0, count: 11)
//        vals[10] = current
//        vals[5] = (current + previous)/2
//        vals[2] = (vals[5] + previous)/2
//        vals[1] = (vals[2] + previous)/2
//        vals[8] = (vals[5] + current)/2
//        vals[9] = (vals[10] + current)/2
//        vals[7] = (vals[5] + vals[9])/2
//        vals[6] = (vals[5] + vals[7])/2
//        vals[3] = (vals[1] + vals[5])/2
//        vals[4] = (vals[3] + vals[5])/2
//        vals[0] = (previous + vals[1])/2
//
//        return vals
//    }
    
    // MARK: AudioVisualiser
    
//    VStack {
//        HStack {
//            ForEach(model.frequencyVertices, id: \.self) { v in
//                RoundedRectangle(cornerRadius: 5)
//                    .fill(.purple)
//                    .frame(width: 2, height: CGFloat(v))
//            }
//        }
//    }
    
    // MARK: ContentView
    
//    (UIScreen.main.bounds.width - 200) / CGFloat(10)
    
//    ForEach(0..<512, id:\.self) { i in
//
//        HStack {
//            Text("\(mic.amplitudeTime[i][0])")
//
//            Text("\(self.soundLevel(level: mic.amplitudeTime[i][1]))")
//        }
//
//        HStack {
//            Text("\((i + 1) * 40) Hz")
//
//            Text(String(mic.soundSamples[i]))
//        }
//    }
    
//    VStack (alignment: .leading) {
//
//        HStack (spacing: 0.5) {
//            ForEach(mic.soundSamples, id: \.self) { level in
//
//                BarView(value: self.soundLevel(level: fabsf(level)))
//
//            }
//        }
//
//        ScrollView(.horizontal) {
//
//            HStack (alignment: .bottom, spacing: 1) {
//
//                ForEach(0..<128, id: \.self) { i in
//
//                    Rectangle()
//                        .foregroundColor(.blue)
//                        .frame(width: 2, height: self.soundLevel(level: mic.soundSamples[i % Constants.numberOfSamples]))
//
//                }
//
//            }
//
//        }
//        .frame(height: 200)
//    }
//    .padding(.horizontal)
    
    //                    BarView(value: CGFloat(mic.soundRanges[i] / 10))
    
//    private func soundLevel(level: Float) -> CGFloat {
//        
//        let level = max(0.2, CGFloat(level) + 50) / 2
//        
//        return CGFloat(level * 12 * 2)
//    }
    
    // MARK: MicrophoneMonitor
    
    //            self.currentSample = (self.currentSample + 1)
    //            % self.numberOfSamples
    
    //            if self.currentSample >= self.numberOfSamples {
    //                self.timer?.invalidate()
    //                self.audioRecorder!.stop()
    //            }
    
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    //            floatPointer.initialize(from: &sampleHolder, count: 1024)
    //
    //            self.soundSamples = SignalProcessing.fft(data: floatPointer, setup: fftSetup!)
    //        }
    
    
    //    @Published var amplitudeTime: [[Float]]
    //        self.amplitudeTime = [[Float]](repeating: [.zero, .zero], count: Constants.numberOfSamples)
    //    private var timeNum: Float
    //    self.timeNum = 0
    //            self.amplitudeTime[self.currentSample][0] = self.timeNum
    //            self.amplitudeTime[self.currentSample][1] = self.audioRecorder!.peakPower(forChannel: 0)
    //            self.timeNum += 0.01
    
   //            if self.currentSample == (self.numberOfSamples - 1) {
   //                floatPointer.initialize(from: &sampleHolder, count: 1024)
   //                self.soundSamples = SignalProcessing.fft(data: floatPointer, setup: fftSetup!)
   //                self.orderSamples()
   //            }
    
    
//    private func splitArray() -> [[Float]] {
//
//        let firstSplit = Array(self.soundSamples[0..<4])
//        let secondSplit = Array(self.soundSamples[4..<8])
//        let thirdSplit = Array(self.soundSamples[8..<60])
//        let fourthSplit = Array(self.soundSamples[60..<120])
//        let finalSplit = Array(self.soundSamples[120..<512])
//
//        return [firstSplit, secondSplit, thirdSplit, fourthSplit, finalSplit]
//    }
    
    
//        broadTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
//            floatPointer.initialize(from: &sampleHolder, count: Constants.samplesInUse)
//            self.soundSamples = SignalProcessing.fft(data: floatPointer, setup: fftSetup!)
//            self.orderSamples()
//        })
    
    // MARK: Ordering functions
    
    //    func orderSamples(array: [Float], int: Int) -> [[Float]] {
    //
    //        let splitArrays = splitArraySmall(array: array)
    //        var soundRanges = [Float](repeating: .zero, count: 5)
    //        var soundRangesWMem = [[Float]](repeating: ([Float](repeating: .zero, count: 8)), count: 5)
    //
    //        for i in 0..<5 {
    //            soundRanges[i] = splitArrays[i].reduce(0, +)
    //            soundRangesWMem[i][int % 8] = soundRanges[i]
    //        }
    //
    //        return soundRangesWMem
    //    }
    //
    //    func splitArraySmall(array: [Float]) -> [[Float]] {
    //
    //        let firstSplit = Array(array[0..<Constants.rangeNums[0]])
    //        let secondSplit = Array(array[Constants.rangeNums[0]..<Constants.rangeNums[1]])
    //        let thirdSplit = Array(array[Constants.rangeNums[1]..<Constants.rangeNums[2]])
    //        let fourthSplit = Array(array[Constants.rangeNums[2]..<Constants.rangeNums[3]])
    //        let finalSplit = Array(array[Constants.rangeNums[3]..<Constants.rangeNums[4]])
    //
    //        return [firstSplit, secondSplit, thirdSplit, fourthSplit, finalSplit]
    //    }

    
}
