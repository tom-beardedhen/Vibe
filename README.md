# Vibe
Summary 
In the project there are a number of different approaches, none of which I feel are ideal. One of the main issues is that of scaling, as the amplitude data that comes back from the mics, or taps, is in dbfs; which is a relative scale with 0 being max sound and -160 being no sound. There is no real way that I have found of accurately converting this to decibels without some sort of prior calibration test. This is also an issue when passing the data through into the Fourier transform.

The code is split into 4 individual parts with some shared code. Hopefully you can understand it. Obviously not all would be needed for the final product, but they’re the attempts I’ve made to solve it.

Also, in terms of android, media recorder was not working for me and it said that it had be depreciated but there was no replacement.

Accelerate Docs
https://developer.apple.com/documentation/accelerate/1450014-vdsp_measqv

https://developer.apple.com/documentation/accelerate/1449881-vdsp_zvabs

https://developer.apple.com/documentation/accelerate/1450538-vdsp_dft_execute

https://developer.apple.com/documentation/accelerate/dspsplitcomplex

https://developer.apple.com/documentation/accelerate/1450020-vdsp_vsmul

https://developer.apple.com/documentation/accelerate/1450061-vdsp_dft_zop_createsetup

https://developer.apple.com/documentation/accelerate/vdsp_length

https://developer.apple.com/documentation/accelerate/vdsp_dft_direction


Example Code
- Has a lot of similarities to what we need but returns unuseful values for amplitude and frequency
https://betterprogramming.pub/audio-visualization-in-swift-using-metal-accelerate-part-1-390965c095d7

- Simple app representing changes in amplitude only
https://medium.com/swlh/swiftui-create-a-sound-visualizer-cadee0b6ad37

- Audio Engine tutorial 
https://www.raywenderlich.com/21672160-avaudioengine-tutorial-for-ios-getting-started

- This seemed promising but due to changes in AudioKit I couldn’t translate it into a new working copy
https://audiokitpro.com/audiovisualizertutorial/


Useful Docs
- Vibe Brief
https://docs.google.com/document/d/113XARTTz2BgjWmJ_T8M8m88jVLtgm2V8a0L1dATd7_c/edit

- Discussion of what swift packages to use
https://www.objc.io/issues/24-audio/audio-api-overview/

- Info on recent change of AudioKit behaviour 
https://audiokit.io/MigrationGuide/

https://www.toptal.com/algorithms/shazam-it-music-processing-fingerprinting-and-recognition#:~:text=How%20does%20the%20Shazam%20algorithm,each%20other%20within%20a%20song.

