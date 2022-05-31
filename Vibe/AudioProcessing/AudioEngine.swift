//
//  AudioEngine.swift
//  Vibe
//
//  Created by Tom Johnson on 31/05/2022.
//

import Foundation
import AVFoundation

class AudioEngine: ObservableObject {
    
    var isPlaying: Bool = false
    var isPlayerReady: Bool = false
    var meterLevel: Float = 0
    @Published var playerProgress: Double = 0
    var playerTime: PlayerTime = .zero
    
    private let engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    private let timeEffect = AVAudioUnitTimePitch()
    
    private var needsFileScheduled = true
    
    private var audioFile: AVAudioFile?
    private var audioSampleRate: Double = 0
    private var audioLengthSeconds: Double = 0
    
    private var seekFrame: AVAudioFramePosition = 0
    private var currentPosition: AVAudioFramePosition = 0
    private var audioSeekFrame: AVAudioFramePosition = 0
    private var audioLengthSamples: AVAudioFramePosition = 0
    
    private var currentFrame: AVAudioFramePosition {
        
        guard let lastRenderTime = player.lastRenderTime, let playerTime = player.playerTime(forNodeTime: lastRenderTime) else {
            return 0
        }
        
        return playerTime.sampleTime
    }
    
    init() {
        setupAudio()
        updateDisplay()
    }
    
    func playOrPause() {
      
      isPlaying.toggle()
      
      if player.isPlaying {
//        displayLink?.isPaused = true
        disconnectVolumeTap()
        
        player.pause()
      }
      else {
//        displayLink?.isPaused = false
        connectVolumeTap()
        
        if needsFileScheduled {
          scheduleAudioFile()
        }
        
        player.play()
      }
    }
    
    func skip(forwards: Bool) {
      
      let timeToseek: Double
      
      if forwards {
        timeToseek = 10
      } else {
        timeToseek = -10
      }
      
      seek(to: timeToseek)
    }

    private func setupAudio() {
      
      guard let fileURL = Bundle.main.url(forResource: "night_thunder", withExtension: "mp3") else {
        return
      }
      
      do {
        let file = try AVAudioFile(forReading: fileURL)
        let format = file.processingFormat
        
        audioLengthSamples = file.length
        audioSampleRate = format.sampleRate
        audioLengthSeconds = Double(audioLengthSamples) / audioSampleRate
        
        audioFile = file
        
        configureEngine(with: format)
        
      }
      catch {
        print("Error reading the audio file: \(error.localizedDescription)")
      }
    }
    
    private func configureEngine(with format: AVAudioFormat) {
      
      engine.attach(player)
      engine.attach(timeEffect)
      
      engine.connect(player, to: timeEffect, format: format)
      engine.connect(timeEffect, to: engine.mainMixerNode, format: format)
      
      engine.prepare()
      
      do {
        try engine.start()
        
        scheduleAudioFile()
        isPlayerReady = true
      }
      catch {
        print("Error starting the player: \(error.localizedDescription)")
      }
    }
    
    private func scheduleAudioFile() {
      
      guard let file = audioFile, needsFileScheduled else {
        return
      }

      needsFileScheduled = false
      seekFrame = 0
      
      player.scheduleFile(file, at: nil) {
        self.needsFileScheduled = true
      }
    }
    
    private func seek(to time: Double) {
      
      guard let audioFile = audioFile else {
        return
      }

      let offset = AVAudioFramePosition(time * audioSampleRate)
      seekFrame = currentPosition + offset
      seekFrame = max(seekFrame, 0)
      seekFrame = min(seekFrame, audioLengthSamples)
      currentPosition = seekFrame
      
      let wasPlaying = player.isPlaying
      player.stop()
      
      if currentPosition < audioLengthSamples {
        updateDisplay()
        needsFileScheduled = false
        
        let frameCount = AVAudioFrameCount(audioLengthSamples - seekFrame)
        
        player.scheduleSegment(audioFile, startingFrame: seekFrame, frameCount: frameCount, at: nil) {
          self.needsFileScheduled = true
        }
        
        if wasPlaying {
          player.play()
        }
      }
    }
    
    private func scaledPower(power: Float) -> Float {
      
      guard power.isFinite else {
        return 0.0
      }
      
      let minDb: Float = -80
      
      if power < minDb {
        return 0.0
      } else if power >= 1.0 {
        return 1.0
      } else {
        return (abs(minDb) - abs(power)) / abs(minDb)
      }
      
    }
    
    private func connectVolumeTap() {
      
      let format = engine.mainMixerNode.outputFormat(forBus: 0)
      
      engine.mainMixerNode.installTap(onBus: 0,
                                      bufferSize: 1024,
                                      format: format) { buffer, _ in
        
        guard let channelData = buffer.floatChannelData else {
          return
        }
        
        let channelDataValue = channelData.pointee
        
        let channelDataValueArray = stride(
          from: 0,
          to: Int(buffer.frameLength),
          by: buffer.stride)
          .map { channelDataValue[$0] }
        
        let rms = sqrt(channelDataValueArray.map {
          return $0 * $0
        }
        .reduce(0, +) / Float(buffer.frameLength))
        
        let avgPower = 20 * log10(rms)
        
        let meterLevel = self.scaledPower(power: avgPower)
        
        DispatchQueue.main.async {
          self.meterLevel = self.isPlaying ? meterLevel : 0
        }
        
      }
    }
    
    private func disconnectVolumeTap() {
      engine.mainMixerNode.removeTap(onBus: 0)
      meterLevel = 0
    }
    
    private func updateDisplay() {
      // 1
      currentPosition = currentFrame + seekFrame
      currentPosition = max(currentPosition, 0)
      currentPosition = min(currentPosition, audioLengthSamples)

      // 2
      if currentPosition >= audioLengthSamples {
        player.stop()
        
        seekFrame = 0
        currentPosition = 0
        
        isPlaying = false
        
        disconnectVolumeTap()
      }

      // 3
      playerProgress = Double(currentPosition) / Double(audioLengthSamples)

      let time = Double(currentPosition) / audioSampleRate
      playerTime = PlayerTime(
        elapsedTime: time,
        remainingTime: audioLengthSeconds - time
      )

    }
}
