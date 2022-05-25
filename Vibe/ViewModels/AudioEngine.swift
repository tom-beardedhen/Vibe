//
//  AudioEngine.swift
//  Vibe
//
//  Created by Tom Johnson on 25/05/2022.
//

import Foundation
import AVFoundation
import Accelerate

class AudioEngine {
    
    var engine: AVAudioEngine!
    
    init() {
        setUpAudio()
    }
    
    func setUpAudio() {
        
        engine = AVAudioEngine()
        
        _ = engine.mainMixerNode
        
        engine.prepare()
        do {
            try engine.start()
        }
        catch {
            print(error)
        }
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        
        let player = AVAudioPlayerNode()
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
            
            let format = audioFile.processingFormat
            print(format)
            
            engine.attach(player)
            engine.connect(player, to: engine.mainMixerNode, format: format)
            
            player.scheduleFile(audioFile, at: nil, completionHandler: nil)
        }
        catch {
            print(error.localizedDescription)
        }
        
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, time in
            self.processAudioData(buffer: buffer)
        }
        
        player.play()
        
    }
    
    var prevRMSValue: Float = 0.3
    
    let fftSetup = vDSP_DFT_zop_CreateSetup(nil, 1024, vDSP_DFT_Direction.FORWARD)
    
    func processAudioData(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else {return}
        let frames = buffer.frameLength
        
        //rms
        let rmsValue = SignalProcessing.rms(data: channelData, frameLength: UInt(frames))
        let interpolatedResults = SignalProcessing.interpolate(current: rmsValue, previous: prevRMSValue)
        prevRMSValue = rmsValue
        
        //pass values to the audiovisualizer for the rendering
        for rms in interpolatedResults {
//            audioVisualizer.loudnessMagnitude = rms
        }
        
        //fft
        let fftMagnitudes =  SignalProcessing.fft(data: channelData, setup: fftSetup!)
//        audioVisualizer.frequencyVertices = fftMagnitudes
    }
    
}
