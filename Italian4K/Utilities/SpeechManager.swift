//
//  SpeechManager.swift
//  Italian4K
//
//  Created by WARREN PETERS on 01/03/2026.
//

import AVFoundation

final class SpeechManager {

    static let shared = SpeechManager()
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String, language: String = "it-IT") {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}
