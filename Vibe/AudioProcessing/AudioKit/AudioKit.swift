//
//  AudioKit.swift
//  Vibe
//
//  Created by Tom Johnson on 01/06/2022.
//

import Foundation
import AudioKit
//import AudioKitUI
//import AudioKitEX
//import AudioToolbox

class Conductor: ObservableObject {
    
//    let mic = AKMicrophone()
//    let mic = MicrophoneMonitor
    let engine = AudioEngine()
    var mic: AudioEngine.InputNode
    
//    let mixer = AKMixer()
    let micMixer = Mixer()
//
    let refreshTimeInterval: Double = 0.02
//
////    let fft: AKFFTTap
    let fft: FFTTap
//
    let FFT_SIZE = 512
//
    let sampleRate: double_t = 44100
//
////    let outputLimiter = AKPeakLimiter()
    let outputLimiter: PeakLimiter?
//
    @Published var amplitudes: [Double] = Array(repeating: 0.5, count: 50)

    
    init() {
        
        guard let input = engine.input else {
            fatalError()
        }
        
        mic = input
//
        outputLimiter = PeakLimiter(input)
//
//        // connect the fft tap to the mic mixer (this allows us to analyze the audio at the micMixer node)
        fft = FFTTap(input, bufferSize: UInt32(FFT_SIZE), handler: { _ in })
//
//        // route the audio from the microphone to the limiter
        setupMic()
//
//        // set the limiter as the last node in our audio chain
        engine.output = outputLimiter
//
//        // do any AudioKit setting changes before starting the AudioKit engine
        setAudioKitSettings()
//
//        // start the AudioKit engine
        do{
            try engine.start()
        }
        catch{
            assert(false, error.localizedDescription)
        }
//
//        // create a repeating timer at the rate of our chosen time interval - this updates the amplitudes each timer callback
        Timer.scheduledTimer(withTimeInterval: refreshTimeInterval, repeats: true) { timer in
            self.updateAmplitudes()
        }

    }
    
    /// Sets AudioKit to appropriate settings
    func setAudioKitSettings(){

        do {
//            try AKSettings.setSession(category: .ambient, with: [.mixWithOthers])
            try Settings.setSession(category: .ambient, with: [.mixWithOthers])
        } catch {
            Log("Could not set session category.")
        }

    }
    
    /// Does all the setup required for microphone input
    func setupMic(){

        // route mic to the micMixer which is tapped by our fft
//        mic.setOutput(to: micMixer)
        mic.addInput(micMixer)

        // route mixMixer to a mixer with no volume so that we don't output audio
        let silentMixer = Mixer(micMixer)
        silentMixer.volume = 0.0

        // route the silent Mixer to the limiter (you must always route the audio chain to AudioKit.output)
//        silentMixer.setOutput(to: outputLimiter)
//        silentMixer.addInput(outputLimiter)

    }
    
    /// Analyze fft data and write to our amplitudes array
    @objc func updateAmplitudes(){
        //If you are interested in knowing more about this calculation, I have provided a couple recommended links at the bottom of this file.

        // loop by two through all the fft data
        for i in stride(from: 0, to: self.FFT_SIZE - 1, by: 2) {

            // get the real and imaginary parts of the complex number
            let real = fft.fftData[i]
            let imaginary = fft.fftData[i + 1]

            let normalizedBinMagnitude = (2 * sqrt((real * real) * (imaginary * imaginary))) / Float(self.FFT_SIZE)
            let amplitude = (20.0 * log10(normalizedBinMagnitude))

            // scale the resulting data
            var scaledAmplitude = Double((amplitude + 250) / 229.80)

            // restrict the range to 0.0 - 1.0
            if (scaledAmplitude < 0) {
                scaledAmplitude = 0
            }
            if (scaledAmplitude > 1.0) {
                scaledAmplitude = 1.0
            }

            // add the amplitude to our array (further scaling array to look good in visualizer)
            DispatchQueue.main.async {
                if(i/2 < self.amplitudes.count){
                    self.amplitudes[i/2] = self.mapy(n: scaledAmplitude, start1: 0.3, stop1: 0.9, start2: 0.0, stop2: 1.0)
                }
            }
        }

    }
    
    /// simple mapping function to scale a value to a different range
    func mapy(n:Double, start1:Double, stop1:Double, start2:Double, stop2:Double) -> Double {
        return ((n-start1)/(stop1-start1))*(stop2-start2)+start2;
    }


}
