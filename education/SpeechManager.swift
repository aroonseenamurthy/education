//
//  SpeechManager.swift
//  education
//

import AVFoundation
import Combine

class SpeechManager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    init() {
        // Play audio even when the device is on silent
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate            = 0.38
        utterance.pitchMultiplier = 1.1
        utterance.preUtteranceDelay = 0.15
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    func speakAlphabetCard(letter: String, word: String) {
        speak(word)
    }

    func speakAnimalCard(name: String, sound: String) {
        speak("\(name). \(name) says \(sound)!")
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
