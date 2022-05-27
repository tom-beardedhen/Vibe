//
//  Scraps.swift
//  Vibe
//
//  Created by Tom Johnson on 27/05/2022.
//

import SwiftUI

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
    
    static func rms(data: UnsafeMutablePointer<Float>, frameLength: UInt) -> Float {
        var val : Float = 0
//        vDSP_measqv(data, 1, &val, frameLength)

        var db = 10*log10f(val)
        //inverse dB to +ve range where 0(silent) -> 160(loudest)
        db = 160 + db;
        //Only take into account range from 120->160, so FSR = 40
        db = db - 120

        let dividor = Float(40/0.3)
        var adjustedVal = 0.3 + db/dividor

        //cutoff
        if (adjustedVal < 0.3) {
            adjustedVal = 0.3
        } else if (adjustedVal > 0.6) {
            adjustedVal = 0.6
        }
        
        return adjustedVal
    }
    
    //MARK: interpolate
    
    static func interpolate(current: Float, previous: Float) -> [Float]{
        var vals = [Float](repeating: 0, count: 11)
        vals[10] = current
        vals[5] = (current + previous)/2
        vals[2] = (vals[5] + previous)/2
        vals[1] = (vals[2] + previous)/2
        vals[8] = (vals[5] + current)/2
        vals[9] = (vals[10] + current)/2
        vals[7] = (vals[5] + vals[9])/2
        vals[6] = (vals[5] + vals[7])/2
        vals[3] = (vals[1] + vals[5])/2
        vals[4] = (vals[3] + vals[5])/2
        vals[0] = (previous + vals[1])/2
        
        return vals
    }
    
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
    
    private func soundLevel(level: Float) -> CGFloat {
        
        let level = max(0.2, CGFloat(level) + 50) / 2
        
        return CGFloat(level * 12 * 2)
    }
    
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
}
